import 'package:finance_app/core/network/api_exception.dart';
import 'package:finance_app/core/error/failure.dart';
import 'package:finance_app/core/error/result.dart';

/// Wraps a data-layer call so every repository method stays a single line and
/// no transport exception escapes as an exception:
///
/// ```dart
/// Future<Result<CourtModel>> fetchCourts() =>
///     guard(() async => CourtModel.fromJson(await ApiClient().get(ApiRoutes.courts)));
/// ```
///
/// Anything thrown inside [body] — `DioException`, a `fromJson` `TypeError`,
/// anything else — comes back as an `Err` carrying a domain [Failure].
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Ok(await body());
  } catch (e, st) {
    return Err(mapDioError(e, st));
  }
}
