import 'package:injectable/injectable.dart';
import 'package:mobile/core/cubit/base_cubit.dart';
import 'package:mobile/features/weather/domain/entities/location_entity.dart';
import 'package:mobile/features/weather/domain/entities/weather_entity.dart';
import 'package:mobile/features/weather/domain/repositories/weather_repository.dart';

part 'weather_state.dart';

@lazySingleton
class WeatherCubit extends BaseCubit<WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherCubit(
    this._weatherRepository,
  ) : super(WeatherState.initial());

  Future<void> onFetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(submitStatus: RequestStatus.loading));

    final response = await _weatherRepository.getLocationSearch(query: city);

    response.fold(
      (err) {
        emit(state.copyWith(
          submitStatus: RequestStatus.failure,
          errorMessage: err.message,
        ));
      },
      (location) async {
        // copy state with location Data
        emit(
          state.copyWith(
            locationEntity: location.toEntity(),
          ),
        );

        final weatherResponse = await _weatherRepository.getWeatherData(
            latitude: location.latitude ?? 0,
            longitude: location.longitude ?? 0);

        weatherResponse.fold(
          (err) {
            emit(state.copyWith(
              submitStatus: RequestStatus.failure,
              errorMessage: err.message,
            ));
          },
          (weather) {
            emit(
              state.copyWith(
                submitStatus: RequestStatus.success,
                errorMessage: '',
                weatherEntity: weather.toEntity(),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> onRefreshWeatherData() async {
    if (state.locationEntity == const LocationEntity.empty()) return;

    await onFetchWeather(state.locationEntity.name);
  }
}
