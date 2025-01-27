import 'package:equatable/equatable.dart';

class AppError extends Equatable {
  final int? code;
  final ErrorType type;
  final String message;
  final String? error;
  final String? trace;

  const AppError({
    this.code,
    required this.type,
    this.message = 'Something went wrong!',
    this.error,
    this.trace,
  });

  factory AppError.fromApi({
    int? code,
    String? message,
    dynamic error,
    StackTrace? trace,
  }) =>
      AppError(
        code: code,
        type: ErrorType.server,
        message: message ?? 'Something went wrong!',
        error: error?.toString(),
        trace: trace?.toString(),
      );

  factory AppError.fromNetwork({
    int? code,
    String? message,
    dynamic error,
    StackTrace? trace,
  }) =>
      AppError(
        code: code,
        type: ErrorType.server,
        message: message ?? 'Something went wrong!',
        error: error?.toString(),
        trace: trace?.toString(),
      );

  factory AppError.fromUnknown({
    int? code,
    String? message,
    dynamic error,
    StackTrace? trace,
  }) =>
      AppError(
        code: code,
        type: ErrorType.unknown,
        message: message ?? 'Something went wrong!',
        error: error?.toString(),
        trace: trace?.toString(),
      );

  @override
  List<Object?> get props => [
        code,
        type,
        message,
        error,
        trace,
      ];
}

enum ErrorType { server, unknown }
