import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/cubit/base_cubit.dart';
import 'package:mobile/core/injection/injection.dart';
import 'package:mobile/features/common/presentation/widgets/theme_toggle_button.dart';
import 'package:mobile/core/theme/cubit/theme_cubit.dart';
import 'package:mobile/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:mobile/features/weather/presentation/screens/search_screen.dart';
import 'package:mobile/features/weather/presentation/views/weather_view.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherCubit, WeatherState>(
      bloc: getIt<WeatherCubit>(),
      listener: (context, state) {
        if (state.submitStatus == RequestStatus.success) {
          getIt<ThemeCubit>().toggleTheme();
        }
      },
      child: BlocBuilder<WeatherCubit, WeatherState>(
        bloc: getIt<WeatherCubit>(),
        builder: (context, state) {
          return Scaffold(
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  WeatherView(
                    onRefresh: () =>
                        getIt<WeatherCubit>().onRefreshWeatherData(),
                    submitStatus: state.submitStatus,
                    weatherEntity: state.weatherEntity,
                    locationEntity: state.locationEntity,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ThemeToggleButton(),
                          DropdownButton<Locale>(
                            value: context.locale,
                            onChanged: (Locale? value) {
                              if (value == null) return;
                              setState(() {
                                context.setLocale(value);
                              });
                            },
                            items:
                                context.supportedLocales.map((Locale locale) {
                              return DropdownMenuItem<Locale>(
                                value: locale,
                                child: Text(locale.languageCode),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.search, semanticLabel: 'Search'),
              onPressed: () async {
                final city =
                    await Navigator.of(context).push(SearchScreen.route());
                if (!context.mounted) return;
                await getIt<WeatherCubit>().onFetchWeather(city);
              },
            ),
          );
        },
      ),
    );
  }
}
