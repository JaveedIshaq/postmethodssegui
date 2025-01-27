import 'package:flutter/material.dart';
import 'package:mobile/core/cubit/base_cubit.dart';
import 'package:mobile/features/weather/domain/entities/location_entity.dart';
import 'package:mobile/features/weather/domain/entities/weather_entity.dart';
import 'package:mobile/features/weather/presentation/widgets/weather_empty.dart';
import 'package:mobile/features/weather/presentation/widgets/weather_error.dart';
import 'package:mobile/features/weather/presentation/widgets/weather_loading.dart';
import 'package:mobile/features/weather/presentation/widgets/weather_populated.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({
    super.key,
    required this.onRefresh,
    required this.submitStatus,
    required this.weatherEntity,
    required this.locationEntity,
  });

  final Future<void> Function() onRefresh;
  final RequestStatus submitStatus;
  final WeatherEntity? weatherEntity;
  final LocationEntity? locationEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: Center(
          child: Builder(
            builder: (context) {
              switch (submitStatus) {
                case RequestStatus.initial:
                  return const WeatherEmpty();
                case RequestStatus.loading:
                  return const WeatherLoading();
                case RequestStatus.success:
                  if (weatherEntity == null || locationEntity == null) {
                    return const WeatherError();
                  }
                  return WeatherPopulated(
                    weather: weatherEntity!,
                    location: locationEntity!,
                    onRefresh: onRefresh,
                  );
                case RequestStatus.failure:
                  return const WeatherError();
              }
            },
          ),
        ),
      ),
    );
  }
}
