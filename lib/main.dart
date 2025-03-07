import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/navigation_service.dart';
import 'utils/theme.dart';

void main() {
  runApp(const DogNutritionApp());
}

class DogNutritionApp extends StatelessWidget {
  const DogNutritionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        Provider<NavigationService>(create: (_) => NavigationService()),
      ],
      child: MaterialApp(
        title: 'PawPerfect Nutrition',
        theme: appTheme,
        home: Consumer<AuthService>(
          builder: (context, authService, child) {
            return authService.isLoggedIn ? HomeScreen() : const LoginScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
