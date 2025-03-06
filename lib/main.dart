import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(DogNutritionApp());
}

class DogNutritionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawPerfect Nutrition',
      theme: appTheme,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}