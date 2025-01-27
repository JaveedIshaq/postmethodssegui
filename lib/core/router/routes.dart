import 'package:flutter/material.dart';
import 'package:mobile/core/router/values.dart';
import 'package:mobile/features/app/presentation/screens/splash_screen.dart';
import 'package:mobile/features/weather/presentation/screens/weather_screen.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.splashScreen:
      return _route(
        Routes.splashScreen,
        const SplashScreen(),
      );
    case Routes.weatherScreen:
      return _route(
        Routes.weatherScreen,
        const WeatherScreen(),
      );
    default:
      return null;
  }
}

Route<dynamic> _route(String name, Widget page) {
  return MaterialPageRoute(
    builder: (_) => page,
    settings: RouteSettings(name: name),
  );
}
