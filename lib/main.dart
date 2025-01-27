import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/app.dart';
import 'package:mobile/core/env/app_env.dart';
import 'package:mobile/core/injection/injection.dart';
import 'package:mobile/core/logger/logger.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initApp();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: AppEnv.flavor.isProd && kReleaseMode
          ? const Locale('en')
          : const Locale('fr'),
      useOnlyLangCode: true,
      child: DevicePreview(
        enabled: false,
        builder: (_) => const MyApp(),
      ),
    ),
  );

  FlutterNativeSplash.remove();
}

Future initApp() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // DI
  await configureDependencies();

  await Future.wait([
    // Localization
    EasyLocalization.ensureInitialized(),
  ]);

  Log.configureLogger();

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60
    ..textColor = Colors.black
    ..radius = 20
    ..backgroundColor = Colors.transparent
    ..maskColor = Colors.white
    ..indicatorColor = Colors.black54
    ..userInteractions = false
    ..dismissOnTap = false
    ..indicatorWidget = Container(
      child: Lottie.asset(
        'assets/lottie/splash.json',
      ),
    )
    ..boxShadow = <BoxShadow>[]
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid;
}
