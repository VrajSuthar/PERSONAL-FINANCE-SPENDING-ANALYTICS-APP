import 'package:finance_app/core/constants/app_images.dart';
import 'dart:async';

import 'package:finance_app/core/router/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      context.push(RoutesNames.splash_intro_screen);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.1),
            radius: 1,
            colors: [Color(0xFF166534), Color(0xFF064E3B), Color(0xFF07110D), Color(0xFF000000)],
            stops: [0.0, 0.3, 0.65, 1.0],
          ),
        ),
        child: Center(
          child: Image.asset(AppImages.fullLogo, height: 0.5.sh, width: 1.sw, fit: BoxFit.contain)
              .animate()
              .fade(duration: const Duration(milliseconds: 1200))
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: const Duration(milliseconds: 1200),
              ),
        ),
      ),
    );
  }
}
