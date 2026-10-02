import 'package:finance_app/core/router/routes_names.dart';
import 'package:finance_app/shared/widgets/common_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      context.push(RoutesNames.splash_intro_screen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CommonText("Splash Screen", fontSize: 16)));
  }
}
