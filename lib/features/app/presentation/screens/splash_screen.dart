import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/core/router/values.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  bool isAnimationCompleteAndShowStartUpView = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Lottie.asset(
        "assets/lottie/splash.json",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        controller: _controller,
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward().whenComplete(() async {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.weatherScreen, (route) => false);
            });
        },
      ),
    );
  }
}
