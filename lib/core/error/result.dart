import 'package:finance_app/core/error/failure.dart';

/// Explicit success/error union.
///
/// Repositories return `Result<T>` instead of throwing, so callers are forced
/// to acknowledge the failure path. Pattern-match it:
///
/// ```dart
/// switch (result) {
///   Ok(:final value) => emit(state.copyWith(data: value)),
///   Err(:final failure) => emit(state.copyWith(failure: failure)),
/// }
/// ```
sealed class Result<T> {
  const Result();

  R when<R>({required R Function(T value) ok, required R Function(Failure failure) err}) => switch (this) {
    Ok<T>(:final value) => ok(value),
    Err<T>(:final failure) => err(failure),
  };

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  /// The value on success, `null` on failure.
  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };

  /// The failure on error, `null` on success.
  Failure? get failureOrNull => switch (this) {
    Ok<T>() => null,
    Err<T>(:final failure) => failure,
  };
}

class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;

  @override
  String toString() => 'Ok($value)';

  @override
  bool operator ==(Object other) => other is Ok<T> && other.value == value;

  @override
  int get hashCode => Object.hash(Ok<T>, value);
}

class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;

  @override
  String toString() => 'Err($failure)';

  @override
  bool operator ==(Object other) => other is Err<T> && other.failure == failure;

  @override
  int get hashCode => Object.hash(Err<T>, failure);
}
