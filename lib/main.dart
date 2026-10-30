import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

void main() => runApp(const PastelShopApp());

class PastelShopApp extends StatelessWidget {
  const PastelShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastel Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          surface: AppColors.background,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: AppColors.textDark,
              displayColor: AppColors.textDark,
            ),
      ),
      home: const HomeScreen(),
    );
  }
}
