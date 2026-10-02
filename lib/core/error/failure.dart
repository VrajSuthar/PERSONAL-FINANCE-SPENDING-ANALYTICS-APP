/// Domain-level error type.
///
/// Sealed, so a `switch` over failures is exhaustive — the compiler forces the
/// UI to handle every case. Nothing above the data layer should ever see a
/// `DioException`; repositories map transport errors into one of these via
/// `mapDioError` (see core/network/api_exception.dart).
sealed class Failure {
  const Failure(this.message);

  /// Safe to show to a user as-is.
  final String message;

  @override
  String toString() => '$runtimeType($message)';

  @override
  bool operator ==(Object other) => other is Failure && other.runtimeType == runtimeType && other.message == message;

  @override
  int get hashCode => Object.hash(runtimeType, message);
}

/// No usable connection — timeouts, DNS, airplane mode.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// The server answered, but not with success.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  bool operator ==(Object other) =>
      other is ServerFailure && other.message == message && other.statusCode == statusCode;

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode);
}

/// 401/403 — the session is gone or was never valid.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired']);
}

/// The request succeeded but the payload could not be parsed into a model.
class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Unexpected response from server']);
}

/// Local storage (Hive) read/write problem.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong']);
}
