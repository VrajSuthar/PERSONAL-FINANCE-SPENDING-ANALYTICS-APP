import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:finance_app/core/network/api_routes.dart';
import 'package:finance_app/core/network/auth_interceptor.dart';
import 'package:flutter/foundation.dart';

/// The single configured Dio for the app.
///
/// `ApiClient()` always returns the same instance, so there is one connection
/// pool and one place where auth headers and request logging are handled.
/// Paths passed to the verbs are **relative** — `BaseOptions.baseUrl` comes
/// from [ApiRoutes.baseUrl], so pointing the app at another backend is a
/// `--dart-define`.
///
/// Nothing here unwraps the response envelope or swallows errors: a verb
/// returns the decoded body exactly as the server sent it — repositories run
/// it through `ensureSuccess`/`asJsonMap` (core/network/api_envelope.dart)
/// before touching `data`. Any non-2xx response throws a `DioException`,
/// which `guard()` turns into a `Failure` via `mapDioError`.
class ApiClient {
  ApiClient._internal({Duration timeout = const Duration(seconds: 20)}) {
    final options = BaseOptions(
      baseUrl: ApiRoutes.baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: const {'Accept': 'application/json'},
    );

    //*==== No interceptors: used to refresh and to replay, so it can't recurse ====*/
    final refreshDio = Dio(options);

    _dio = Dio(options);

    _dio.interceptors.addAll([
      AuthInterceptor(refreshDio: refreshDio, onSessionExpired: _handleSessionExpired),
      InterceptorsWrapper(onRequest: _logRequest, onResponse: _onResponse, onError: _onError),
    ]);
  }

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  late final Dio _dio;

  Dio get dio => _dio;

  /// Runs once [AuthInterceptor] gives up renewing the session (refresh
  /// failed, or there was no refresh token to use). Left as a hook rather
  /// than wired straight to navigation, since no router/session provider
  /// exists yet — assign it once one does, e.g. from app bootstrap:
  /// `ApiClient.onSessionExpired = () async => ref.read(sessionProvider.notifier).signOut();`
  static Future<void> Function()? onSessionExpired;

  Future<void> _handleSessionExpired() async {
    final hook = onSessionExpired;
    if (hook != null) await hook();
  }

  //*========================================== Interceptors ==========================================*/

  void _logRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint("┌─────────────────────────────────────────");
      debugPrint("│ 📡 ${options.method} → ${options.uri}");
      if (options.data != null) debugPrint("│ 📦 Body: ${options.data}");
      debugPrint("└─────────────────────────────────────────");
    }

    handler.next(options);
  }

  void _onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (kDebugMode) _logBody("✅ RESPONSE [${response.statusCode}] → ${response.requestOptions.path}", response.data);
    handler.next(response);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logBody(
        "❌ ERROR [${error.response?.statusCode}] → ${error.requestOptions.path}",
        error.response?.data ?? error.message,
      );
    }

    //*==== 401 handling lives in AuthInterceptor, which runs first ====*/
    handler.next(error);
  }

  void _logBody(String header, dynamic data) {
    final pretty = data is Map || data is List ? const JsonEncoder.withIndent('  ').convert(data) : data.toString();
    debugPrint("┌─────────────────────────────────────────");
    debugPrint("│ $header");
    for (final line in pretty.split('\n')) {
      debugPrint("│   $line");
    }
    debugPrint("└─────────────────────────────────────────");
  }

  //*========================================== Verbs ==========================================*/

  //*==== Each returns the decoded body as-is and throws DioException on failure. ====*/

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get<dynamic>(path, queryParameters: queryParameters);
    return response.data;
  }

  Future<dynamic> post(
    String path,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: body,
      queryParameters: queryParameters,
      options: headers == null ? null : Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> put(
    String path,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.put<dynamic>(
      path,
      data: body,
      queryParameters: queryParameters,
      options: headers == null ? null : Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> patch(
    String path,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.patch<dynamic>(
      path,
      data: body,
      queryParameters: queryParameters,
      options: headers == null ? null : Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.delete<dynamic>(
      path,
      data: body,
      queryParameters: queryParameters,
      options: headers == null ? null : Options(headers: headers),
    );
    return response.data;
  }

  /// Uploads a single file via multipart/form-data PUT — e.g. replacing a
  /// profile photo. [fieldName] is the form field name the server expects.
  Future<dynamic> uploadFile(String path, String filePath, {String fieldName = 'file'}) async {
    final formData = FormData.fromMap({fieldName: await MultipartFile.fromFile(filePath)});
    final response = await _dio.put<dynamic>(
      path,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data;
  }

  /// Posts plain [fields] alongside zero or more files in one
  /// multipart/form-data request — e.g. a transaction's note plus a receipt
  /// photo. Every file is sent under the same [filesFieldName] (repeated
  /// parts), matching how most REST APIs accept an array of uploads.
  Future<dynamic> postMultipart(
    String path, {
    Map<String, dynamic> fields = const {},
    List<String> filePaths = const [],
    String filesFieldName = 'attachments',
  }) async {
    final formData = FormData.fromMap({
      ...fields,
      if (filePaths.isNotEmpty)
        filesFieldName: await Future.wait(filePaths.map((path) => MultipartFile.fromFile(path))),
    });
    final response = await _dio.post<dynamic>(
      path,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data;
  }
}
