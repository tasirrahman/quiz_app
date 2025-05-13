import 'package:flutter/material.dart';
import 'package:quiz_app/view/splash_screen.dart';
import 'package:quiz_app/widgets/material_app_widget.dart';

void main() {
  runApp(MaterialAppWidget(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
