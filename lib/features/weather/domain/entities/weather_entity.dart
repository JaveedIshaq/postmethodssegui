import 'package:equatable/equatable.dart';
import 'package:mobile/core/enum/weather_condition.dart';

class WeatherEntity extends Equatable {
  final double temperature;
  final double weatherCode;
  final DateTime lastUpdated;
  final WeatherCondition weatherCondition;

  const WeatherEntity({
    required this.temperature,
    required this.weatherCode,
    required this.lastUpdated,
    required this.weatherCondition,
  });

  @override
  List<Object?> get props {
    return [temperature, weatherCode, lastUpdated, weatherCondition];
  }

  WeatherEntity.empty()
      : temperature = 0,
        weatherCode = 0.0,
        lastUpdated = DateTime(0),
        weatherCondition = WeatherCondition.unknown;

  WeatherEntity copyWith({
    double? temperature,
    double? weatherCode,
    DateTime? lastUpdated,
    WeatherCondition? weatherCondition,
  }) {
    return WeatherEntity(
      temperature: temperature ?? this.temperature,
      weatherCode: weatherCode ?? this.weatherCode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      weatherCondition: weatherCondition ?? this.weatherCondition,
    );
  }
}
