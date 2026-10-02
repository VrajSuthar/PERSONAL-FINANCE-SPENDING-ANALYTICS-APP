import 'package:finance_app/core/error/failure.dart';

/// Every endpoint answers `{"success": bool, "data": any, "message": string,
/// "errors": {...}?}` — even a 200 is not automatically a success.
///
/// `ApiClient` hands the raw decoded body back to the repository untouched;
/// the repository runs it through here before touching `data`, so a
/// `success: false` body throws a [Failure] `guard()` can catch instead of
/// being mistaken for a good response:
///
/// ```dart
/// Future<Result<AccountModel>> fetchAccount(String id) => guard(() async {
///   final body = await ApiClient().get(ApiRoutes.accountById(id));
///   ensureSuccess(body);
///   return AccountModel.fromJson(asJsonMap(dataOf(body)));
/// });
/// ```
void ensureSuccess(dynamic body, {String fallback = 'Request failed'}) {
  if (body == null) throw const ParseFailure('Empty response from server');
  if (body is! Map) return;

  if (body['success'] == false) {
    throw ServerFailure(messageOf(body) ?? fallback);
  }
}

/// The human-readable message the server sent, if any.
String? messageOf(dynamic body) {
  if (body is! Map) return null;

  final message = body['message'];
  return message is String && message.trim().isNotEmpty ? message : null;
}

/// The `data` field of an already-[ensureSuccess]-checked body.
Object? dataOf(dynamic body) => body is Map ? body['data'] : null;

/// Asserts the body is a JSON object before a `fromJson` runs, so a surprise
/// `null`/list surfaces as a [ParseFailure] instead of a `TypeError`.
Map<String, dynamic> asJsonMap(dynamic body) {
  if (body is Map<String, dynamic>) return body;
  if (body is Map) return Map<String, dynamic>.from(body);
  throw const ParseFailure();
}

/// Same as [asJsonMap], for a `data` field that's a JSON array.
List<dynamic> asJsonList(dynamic body) {
  if (body is List) return body;
  throw const ParseFailure();
}
