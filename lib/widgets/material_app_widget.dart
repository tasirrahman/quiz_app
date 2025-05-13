import 'package:flutter/material.dart';
import 'package:quiz_app/app/app_info.dart';
import 'package:quiz_app/utils/app_theme.dart';

class MaterialAppWidget extends StatefulWidget {
  final Widget child;

  const MaterialAppWidget({super.key, required this.child});

  @override
  State<MaterialAppWidget> createState() => _MaterialAppWidgetState();
}

class _MaterialAppWidgetState extends State<MaterialAppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: appName,
      home: widget.child,
    );
  }
}
