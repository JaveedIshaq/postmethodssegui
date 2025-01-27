import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile/core/env/app_env.dart';
import 'package:mobile/core/extensions/log_extension.dart';
import 'package:mobile/core/injection/injection.dart';
import 'package:mobile/core/router/router.dart';
import 'package:mobile/core/util/observer_utils.dart';
import 'package:mobile/core/theme/cubit/theme_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    ('FLAVOR: ${AppEnv.flavor}').log();
    _themeCubit = getIt<ThemeCubit>()..init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _themeCubit,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            themeMode: themeState.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: themeState.color,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: themeState.color,
              brightness: Brightness.dark,
            ),
            onGenerateRoute: generateRoute,
            initialRoute: Routes.splashScreen,
            navigatorObservers: [
              ObserverUtils.routeObserver,
            ],
            builder: (context, child) {
              final wrappedChild = EasyLoading.init()(context, child);
              return wrappedChild;
            },
          );
        },
      ),
    );
  }
}
