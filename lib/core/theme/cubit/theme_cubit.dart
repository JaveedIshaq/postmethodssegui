import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/core/cubit/cubit.dart';
import 'package:mobile/core/enum/weather_condition.dart';
import 'package:mobile/features/weather/domain/entities/weather_entity.dart';

@lazySingleton
class ThemeCubit extends BaseCubit<ThemeState> {
  ThemeCubit(this._prefs)
      : super(const ThemeState(
          themeMode: ThemeMode.system,
          color: defaultColor,
        ));

  static const defaultColor = Color(0xFF2196F3);
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  Future<void> init() async {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      emit(state.copyWith(
        themeMode: ThemeMode.values.firstWhere(
          (e) => e.toString() == savedTheme,
          orElse: () => ThemeMode.system,
        ),
      ));
    }
  }

  void toggleTheme() {
    final newMode = switch (state.themeMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };

    _prefs.setString(_themeKey, newMode.toString());
    emit(state.copyWith(themeMode: newMode));
  }

  void onUpdateWeatherColor(WeatherEntity weather) {
    if (weather != WeatherEntity.empty()) {
      emit(state.copyWith(color: weather.toColor));
    }
  }
}

class ThemeState {
  final ThemeMode themeMode;
  final Color color;

  const ThemeState({
    required this.themeMode,
    required this.color,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? color,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      color: color ?? this.color,
    );
  }
}

extension WeatherColorExtension on WeatherEntity {
  Color get toColor {
    switch (weatherCondition) {
      case WeatherCondition.clear:
        return Colors.yellow;
      case WeatherCondition.snowy:
        return Colors.lightBlueAccent;
      case WeatherCondition.cloudy:
        return Colors.blueGrey;
      case WeatherCondition.rainy:
        return Colors.indigoAccent;
      case WeatherCondition.unknown:
        return ThemeCubit.defaultColor;
    }
  }
}
