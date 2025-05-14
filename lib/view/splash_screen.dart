// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/app/app_info.dart';
import 'package:quiz_app/app/routes/navigate.dart';
import 'package:quiz_app/utils/app_colors.dart';
import 'package:quiz_app/utils/app_theme.dart';
import 'package:quiz_app/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 4), _navigateToNext);
  }

  void _navigateToNext() {
    if (!mounted) return;
    Navigate.to(context, HomeScreen());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.appColor),
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: appName,
      home: Scaffold(
        body: Center(
          child: Image.asset('asset/quizapp_app_logo_transparent.png'),
        ),
      ),
    );
  }
}
