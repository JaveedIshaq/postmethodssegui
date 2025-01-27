import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile/generated/locale_keys.g.dart';

class WeatherLoading extends StatelessWidget {
  const WeatherLoading({super.key});

  @override
  // Builds the widget tree for displaying a loading screen with a weather icon and text.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('⛅', style: TextStyle(fontSize: 64)),
        Text(
          LocaleKeys.loadingWeather.tr(),
          style: theme.textTheme.headlineSmall,
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
