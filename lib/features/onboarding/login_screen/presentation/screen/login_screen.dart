import 'package:finance_app/shared/widgets/common_text.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CommonText("Login Screen", fontSize: 16)));
  }
}
