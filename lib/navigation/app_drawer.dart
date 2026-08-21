import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/dashboard_screen.dart';
import '../screens/measurements_screen.dart';
import '../screens/prediction_screen.dart';
import '../screens/performance_screen.dart';
import '../screens/safe_zone_screen.dart';
import '../utils/navigation_utils.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.primaryNavy,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(context, Icons.dashboard_rounded, 'Dashboard', 'dashboard'),
                _buildMenuItem(context, Icons.sensors_rounded, 'EMF Measurements', 'measurements'),
                _buildMenuItem(context, Icons.psychology_rounded, 'ML Prediction', 'prediction'),
                _buildMenuItem(context, Icons.analytics_rounded, 'Model Performance', 'performance'),
                _buildMenuItem(context, Icons.location_on_rounded, 'Safe Zone Analysis', 'safe_zone'),
                const Divider(color: Colors.white10, height: 40),
                _buildMenuItem(context, Icons.info_outline_rounded, 'About', 'about'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'v1.0.0 (Research Edition)',
              style: TextStyle(color: Colors.white30, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: AppTheme.secondaryBlue,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryNavy,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentElectricBlue, width: 1),
            ),
            child: const Icon(Icons.bolt, color: AppTheme.accentElectricBlue, size: 30),
          ),
          const SizedBox(width: 15),
          const Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EMF SafeZone',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '161 kV Research System',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route) {
    bool isSelected = currentRoute == route;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.accentElectricBlue : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.white.withValues(alpha: 0.05),
      onTap: () {
        Navigator.pop(context);
        if (isSelected) return;
        NavigationUtils.navigateTo(context, route);
      },
    );
  }
}
