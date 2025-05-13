// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:quiz_app/app/routes/navigate.dart';
import 'package:quiz_app/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 4),
      () => {Navigate.to(context, HomeScreen())},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('asset/quizapp_app_logo_transparent.png'),
      ),
    );
  }
}
