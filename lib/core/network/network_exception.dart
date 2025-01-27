import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final String path;
  final int statusCode;
  final String method;
  final dynamic data;
  final String baseUrl;

  NetworkException({
    required this.message,
    required this.path,
    this.statusCode = 503,
    this.method = 'GET',
    this.data,
    this.baseUrl = '',
  });

  DioException toDioException() {
    return DioException(
      requestOptions: RequestOptions(
        path: path,
        method: method,
        data: data,
        baseUrl: baseUrl,
      ),
      response: Response(
        requestOptions: RequestOptions(path: path),
        statusCode: statusCode,
      ),
      error: message,
      type: DioExceptionType.connectionError,
    );
  }

  static NetworkException noInternet({
    required String path,
    String method = 'GET',
    dynamic data,
    String baseUrl = '',
  }) {
    return NetworkException(
      message: 'No internet connection',
      path: path,
      method: method,
      data: data,
      baseUrl: baseUrl,
    );
  }
}
