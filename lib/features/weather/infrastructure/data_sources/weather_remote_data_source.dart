import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/core/extensions/log_extension.dart';
import 'package:mobile/core/network/network.dart';
import 'package:mobile/features/weather/infrastructure/dtos/location_dto.dart';
import 'package:mobile/features/weather/infrastructure/dtos/weather_dto.dart';

/// Exception thrown when locationSearch fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}

@lazySingleton
class WeatherRemoteDataSource {
  final Network _network;

  WeatherRemoteDataSource(this._network);

  Future<LocationDto> locationSearch({required String query}) async {
    // Construct the query parameters
    final Map<String, String> queryParams = {
      'name': query,
      'count': '1',
      'language': 'en',
      'format': 'json'
    };

    final response =
        await _network.get('/search', queryParams, isWeather: false);

    "the response is: response.data: ${response.data}".log();

    debugPrint("the response is: ${response.data}");

    return LocationDto.fromJson(
        response.data['results'][0] as Map<String, dynamic>);
  }

  Future<WeatherDto> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final Map<String, String> queryParams = {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true',
    };

    final response =
        await _network.get('/forecast', queryParams, isWeather: true);

    return WeatherDto.fromJson(
        response.data['current_weather'] as Map<String, dynamic>);
  }
}
