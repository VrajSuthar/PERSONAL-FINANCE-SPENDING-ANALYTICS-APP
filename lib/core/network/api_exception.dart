import 'package:dio/dio.dart';
import 'package:finance_app/core/error/failure.dart';

/// Maps low-level transport errors into domain [Failure]s.
///
/// Keeping this in one place is what lets every repository stay a one-liner
/// and guarantees a `DioException` never leaks above the data layer.
Failure mapDioError(Object error, [StackTrace? stackTrace]) {
  //*==== ensureSuccess (api_envelope.dart) already threw a Failure — pass it
  //*==== through instead of flattening it into an UnknownFailure. ====*/
  if (error is Failure) return error;

  if (error is! DioException) {
    //*==== a fromJson/cast blowing up on an unexpected shape lands here ====*/
    if (error is TypeError || error is FormatException) return const ParseFailure();
    return const UnknownFailure();
  }

  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.badResponse => _mapStatus(error.response?.statusCode, error.response?.data),
    DioExceptionType.cancel => const UnknownFailure('Request cancelled'),
    DioExceptionType.badCertificate => const NetworkFailure("Could not establish a secure connection"),
    DioExceptionType.unknown => error.error is FormatException ? const ParseFailure() : const NetworkFailure(),
  };
}

Failure _mapStatus(int? status, Object? body) {
  final message = _extractMessage(body);

  return switch (status) {
    401 || 403 => UnauthorizedFailure(message ?? 'Session expired'),
    404 => ServerFailure(message ?? 'Not found', statusCode: status),
    422 => ServerFailure(message ?? 'Please check the details you entered', statusCode: status),
    != null && >= 500 => ServerFailure(message ?? 'Server error, please try again', statusCode: status),
    _ => ServerFailure(message ?? 'Request failed', statusCode: status),
  };
}

/// The envelope (api_envelope.dart) is the normal shape, but try a couple of
/// common fallbacks before giving up — some errors (proxy timeouts, gateway
/// pages) never reach the app's own error middleware.
String? _extractMessage(Object? body) {
  if (body is! Map) return null;

  for (final key in const ['message', 'error', 'detail']) {
    final value = body[key];
    if (value is String && value.trim().isNotEmpty) return value;
  }

  final errors = body['errors'];

  //*==== {"errors": {"amount": "must be positive"}} ====*/
  if (errors is Map && errors.isNotEmpty) {
    final first = errors.values.first;
    if (first is String && first.trim().isNotEmpty) return first;
    if (first is List && first.isNotEmpty && first.first is String) return first.first as String;
  }

  //*==== {"errors": [{"message": "..."}]} or {"errors": ["..."]} ====*/
  if (errors is List && errors.isNotEmpty) {
    final first = errors.first;
    if (first is String && first.trim().isNotEmpty) return first;
    if (first is Map && first['message'] is String) return first['message'] as String;
  }

  return null;
}
