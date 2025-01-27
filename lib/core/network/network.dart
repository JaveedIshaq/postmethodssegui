import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/storage.dart';
import 'package:mobile/core/network/dio_request_logger.dart';
import 'package:mobile/core/network/network_exception.dart';
import 'package:mobile/core/storage/secure_storage.dart';

@singleton
class Network {
  final SecureStorage _secureStorage;
  final Connectivity _connectivity;

  Network(this._secureStorage) : _connectivity = Connectivity();

  Dio? _dioWeather;
  Dio? _dioGeocoding;

  static const _baseUrlWeather = 'https://api.open-meteo.com/v1';
  static const _baseUrlGeocoding = 'https://geocoding-api.open-meteo.com/v1';

  @PostConstruct(preResolve: true)
  Future<void> initialize() async {
    _dioWeather = Dio(BaseOptions(
      baseUrl: _baseUrlWeather,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'user-agent': 'Dio/4.0.6'},
    ))
      ..interceptors.add(DioRequestLogger(level: Level.BODY))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: _onEveryRequest,
        onError: _onEveryRequestError,
      ));

    _dioGeocoding = Dio(BaseOptions(
      baseUrl: _baseUrlGeocoding,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'user-agent': 'Dio/4.0.6'},
    ))
      ..interceptors.add(DioRequestLogger(level: Level.BODY))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: _onEveryRequest,
        onError: _onEveryRequestError,
      ));
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final isConnected = connectivityResult.isNotEmpty &&
        connectivityResult[0] != ConnectivityResult.none;

    if (!isConnected) {
      Fluttertoast.showToast(
        msg: "No internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    return isConnected;
  }

  Future<Response> post(String url, Object? data,
      {bool isWeather = true}) async {
    if (!await checkConnectivity()) {
      throw NetworkException.noInternet(
        path: url,
        method: 'POST',
        data: data,
        baseUrl: isWeather ? _baseUrlWeather : _baseUrlGeocoding,
      ).toDioException();
    }
    return _getDio(isWeather).post(url, data: data);
  }

  Future<Response> get(String url, Map<String, String> params,
      {bool isWeather = true}) async {
    if (!await checkConnectivity()) {
      throw NetworkException.noInternet(
        path: url,
        method: 'GET',
        data: params,
        baseUrl: isWeather ? _baseUrlWeather : _baseUrlGeocoding,
      ).toDioException();
    }
    return _getDio(isWeather).get(url, queryParameters: params);
  }

  Future<Response> put(String url, Object? data,
      {bool isWeather = true}) async {
    if (!await checkConnectivity()) {
      throw NetworkException.noInternet(
        path: url,
        method: 'PUT',
        data: data,
        baseUrl: isWeather ? _baseUrlWeather : _baseUrlGeocoding,
      ).toDioException();
    }
    return _getDio(isWeather).put(url, data: data);
  }

  Future<Response<T>> request<T>(String url, String method, data,
      {bool isWeather = true}) async {
    if (!await checkConnectivity()) {
      throw NetworkException.noInternet(
        path: url,
        method: method,
        data: data,
        baseUrl: isWeather ? _baseUrlWeather : _baseUrlGeocoding,
      ).toDioException();
    }
    final response = await _getDio(isWeather).request<T>(
      url,
      data: data,
      options: Options(method: method),
    );
    return response;
  }

  Dio _getDio(bool isWeather) {
    return isWeather ? _dioWeather! : _dioGeocoding!;
  }

  Future<void> _onEveryRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _secureStorage.read(StorageValues.accessToken);

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  Future<void> _onEveryRequestError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Logout the User If Token invalid
    if (error.response?.statusCode == 400 &&
        error.response?.data['message'] is List &&
        error.response?.data['message'].contains("Token invalid")) {
      //getIt<AppCubit>().onLogOut();
    }

    if (error.response?.statusCode == 401) {
      try {
        await _refreshAccessToken();
      } on DioException catch (_) {
        // Implement logout
        return;
      }
      try {
        var response =
            await _getDio(error.requestOptions.baseUrl == _baseUrlWeather)
                .request(
          error.requestOptions.path,
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters,
          options: Options(
            method: error.requestOptions.method,
            headers: error.requestOptions.headers,
          ),
        );
        return handler.resolve(response);
      } on DioException catch (err) {
        return handler.next(err);
      }
    }

    if (error.type == DioExceptionType.badResponse) {
      return handler.next(DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        error: error.response?.data["errorMessage"],
        type: error.type,
      ));
    }

    if (error.message?.contains("SocketException") ?? false) {
      return handler.next(DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        error: "It appears you don't have internet. Please try again later.",
        type: error.type,
      ));
    }

    return handler.next(error);
  }

  Future _refreshAccessToken() async {
    final refreshToken = await _secureStorage.read(StorageValues.refreshToken);
    if (refreshToken != null) {
      final response = await request(
        '/access-token',
        'POST',
        {'refreshToken': refreshToken},
      );

      //Save new token
      await _secureStorage.write(
          StorageValues.accessToken, response.data['accessToken']);
    }
  }
}
