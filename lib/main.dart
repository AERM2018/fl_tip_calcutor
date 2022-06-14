import 'package:flutter/material.dart';
import 'package:tip_calc/screens/screens.dart';
import 'package:tip_calc/theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: const TipScreen(),
      theme: AppTheme.lightTheme,
    );
  }
}
