import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/measurements_screen.dart';
import '../screens/prediction_screen.dart';
import '../screens/performance_screen.dart';
import '../screens/safe_zone_screen.dart';
import '../screens/about_screen.dart';

class NavigationUtils {
  static void navigateTo(BuildContext context, String route) {
    Widget screen;
    switch (route) {
      case 'dashboard': screen = const DashboardScreen(); break;
      case 'measurements': screen = const MeasurementsScreen(); break;
      case 'prediction': screen = const PredictionScreen(); break;
      case 'performance': screen = const PerformanceScreen(); break;
      case 'safe_zone': screen = const SafeZoneScreen(); break;
      case 'about': screen = const AboutScreen(); break;
      default: screen = const DashboardScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
