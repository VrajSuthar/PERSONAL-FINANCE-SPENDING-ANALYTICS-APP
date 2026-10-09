import 'package:finance_app/core/constants/app_const.dart';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:finance_app/core/network/api_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local, Hive-backed access/refresh token pair.
///
/// A single box keeps both tokens together so application code can never
/// observe a partial write (access saved, refresh not yet) — [saveTokens]
/// writes them in one call.
class TokenStorage {
  const TokenStorage._();

  static const String _boxName = AppConst.authBox;
  static const String _accessKey = 'accessToken';
  static const String _refreshKey = 'refreshToken';

  static Future<Box<dynamic>> _box() async => Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : Hive.openBox(_boxName);

  static Future<String?> readAccessToken() async => (await _box()).get(_accessKey) as String?;

  static Future<String?> readRefreshToken() async => (await _box()).get(_refreshKey) as String?;

  static Future<void> saveTokens({required String access, String? refresh}) async {
    final box = await _box();
    await box.put(_accessKey, access);
    if (refresh != null) await box.put(_refreshKey, refresh);
  }

  static Future<void> clear() async => (await _box()).clear();
}

/// Attaches the bearer token and performs a **single-flight** refresh on 401.
///
/// Concurrent 401s are coalesced onto one refresh future, so N failing
/// requests trigger one refresh call rather than N. A `QueuedInterceptor`
/// (rather than a plain one) guarantees the callbacks run one at a time, so
/// two requests can't both observe a null in-flight future and race.
///
/// If refresh is unavailable or fails for any reason — including the
/// endpoint not existing yet — [onSessionExpired] runs and the original 401
/// propagates. That degrade is deliberate: a wrong refresh path costs a
/// forced sign-out, never a wedged app.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required Dio refreshDio, required Future<void> Function() onSessionExpired})
    : _refreshDio = refreshDio,
      _onSessionExpired = onSessionExpired;

  /// A bare Dio with no interceptors, so refreshing can't recurse into itself.
  final Dio _refreshDio;

  final Future<void> Function() _onSessionExpired;

  Future<String?>? _inFlightRefresh;

  static const String _retriedFlag = 'retried';
  static const String _authHeader = 'Authorization';

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers[_authHeader] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra[_retriedFlag] == true;

    //*==== Never retry the refresh call itself, or a request we already retried ====*/
    if (!is401 || alreadyRetried || err.requestOptions.path == ApiRoutes.refreshToken) {
      if (is401) await _expire();
      return handler.next(err);
    }

    final newToken = await _tokenForRetry(err.requestOptions);

    if (newToken == null) {
      await _expire();
      return handler.next(err);
    }

    //*==== Replay the original request with the new token ====*/
    final request = err.requestOptions
      ..headers[_authHeader] = 'Bearer $newToken'
      ..extra[_retriedFlag] = true;

    try {
      final replayed = await _refreshDio.fetch<dynamic>(request);
      return handler.resolve(replayed);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// The token a retry should use, refreshing only if nobody else already has.
  ///
  /// Because this is a [QueuedInterceptor], concurrent 401s arrive here one
  /// at a time — the second one would find `_inFlightRefresh` already
  /// cleared and refresh again. Comparing the token the request was signed
  /// with against the one now in storage catches that: a mismatch means a
  /// sibling request already renewed the session and this one just needs
  /// replaying.
  Future<String?> _tokenForRetry(RequestOptions request) async {
    final stored = await TokenStorage.readAccessToken();
    final used = request.headers[_authHeader]?.toString().replaceFirst('Bearer ', '');

    if (stored != null && stored.isNotEmpty && stored != used) return stored;

    final refreshed = await (_inFlightRefresh ??= _refresh());
    _inFlightRefresh = null;

    return refreshed;
  }

  /// Returns a fresh access token, or `null` if the session cannot be renewed.
  Future<String?> _refresh() async {
    final refreshToken = await TokenStorage.readRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await _refreshDio.post<dynamic>(ApiRoutes.refreshToken, data: {'refreshToken': refreshToken});

      final body = response.data;
      if (body is! Map) return null;

      final data = body['data'] is Map ? body['data'] as Map : body;

      final access = data['accessToken'] as String?;
      final refresh = data['refreshToken'] as String?;

      if (access == null || access.isEmpty) return null;

      await TokenStorage.saveTokens(access: access, refresh: refresh);

      return access;
    } on DioException catch (e) {
      if (kDebugMode) debugPrint("🔒 Token refresh failed (${e.response?.statusCode}) — signing out");
      return null;
    }
  }

  Future<void> _expire() async {
    _inFlightRefresh = null;
    await TokenStorage.clear();
    await _onSessionExpired();
  }
}
