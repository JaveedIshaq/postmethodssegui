import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/core/error/error.dart';
import 'package:mobile/features/weather/domain/repositories/weather_repository.dart';
import 'package:mobile/features/weather/infrastructure/data_sources/weather_remote_data_source.dart';
import 'package:mobile/features/weather/infrastructure/dtos/location_dto.dart';
import 'package:mobile/features/weather/infrastructure/dtos/weather_dto.dart';

@LazySingleton(as: WeatherRepository)
class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherRemoteDataSource _weatherRemoteDataSource;

  WeatherRepositoryImpl(this._weatherRemoteDataSource);

  @override
  Future<Either<AppError, WeatherDto>> getWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _weatherRemoteDataSource.getWeather(
        latitude: latitude,
        longitude: longitude,
      );
      return right(response);
    } on DioException catch (e, t) {
      return left(AppError.fromNetwork(
        message: e.message,
        error: e,
        trace: t,
      ));
    } catch (e, t) {
      return left(AppError.fromUnknown(
        error: e,
        trace: t,
      ));
    }
  }

  @override
  Future<Either<AppError, LocationDto>> getLocationSearch({
    required String query,
  }) async {
    try {
      final response =
          await _weatherRemoteDataSource.locationSearch(query: query);
      return right(response);
    } on DioException catch (e, t) {
      return left(AppError.fromNetwork(
        message: e.message,
        error: e,
        trace: t,
      ));
    } catch (e, t) {
      return left(AppError.fromUnknown(
        error: e,
        trace: t,
      ));
    }
  }
}
