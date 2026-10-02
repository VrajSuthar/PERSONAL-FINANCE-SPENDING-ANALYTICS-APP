import 'package:finance_app/shared/widgets/common_text.dart';
import 'package:flutter/material.dart';

class SplashIntroScreen extends StatelessWidget {
  const SplashIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CommonText("Splash Intro Screen", fontSize: 16)));
  }
}
