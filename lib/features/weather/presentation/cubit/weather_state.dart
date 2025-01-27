part of 'weather_cubit.dart';

class WeatherState extends BaseState {
  final String errorMessage;
  final LocationEntity locationEntity;
  final WeatherEntity weatherEntity;

  @override
  final RequestStatus submitStatus;

  const WeatherState({
    this.submitStatus = RequestStatus.initial,
    required this.locationEntity,
    required this.errorMessage,
    required this.weatherEntity,
  });

  factory WeatherState.initial() => WeatherState(
        submitStatus: RequestStatus.initial,
        errorMessage: "",
        locationEntity: const LocationEntity.empty(),
        weatherEntity: WeatherEntity.empty(),
      );

  @override
  List<Object?> get props => [
        submitStatus,
        errorMessage,
        locationEntity,
        weatherEntity,
      ];

  @override
  WeatherState copyWith({
    String? errorMessage,
    RequestStatus? submitStatus,
    LocationEntity? locationEntity,
    WeatherEntity? weatherEntity,
  }) {
    return WeatherState(
      errorMessage: errorMessage ?? this.errorMessage,
      submitStatus: submitStatus ?? this.submitStatus,
      locationEntity: locationEntity ?? this.locationEntity,
      weatherEntity: weatherEntity ?? this.weatherEntity,
    );
  }
}
