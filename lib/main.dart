import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const EMFSafeZoneApp());
}

class EMFSafeZoneApp extends StatelessWidget {
  const EMFSafeZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMF SafeZone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Forcing light theme for research aesthetic
      home: const SplashScreen(),
    );
  }
}
