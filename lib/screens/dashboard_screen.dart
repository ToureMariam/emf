import 'package:flutter/material.dart';
import '../navigation/app_drawer.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import '../utils/navigation_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.bolt, color: Colors.amber),
            SizedBox(width: 8),
            Text('EMF SafeZone'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: 'dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EMF Monitoring & Safety Analysis',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryNavy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Monitor electromagnetic field measurements and analyze exposure conditions around the 161 kV transmission line.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            
            // Summary Grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
                double aspectRatio = constraints.maxWidth > 900 ? 1.8 : (constraints.maxWidth > 600 ? 2.0 : 2.8);
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    DashboardCard(title: 'Transmission Voltage', value: '161 kV', icon: Icons.bolt, iconColor: Colors.amber),
                    DashboardCard(title: 'System Frequency', value: '50 Hz', icon: Icons.waves, iconColor: Colors.blue),
                    DashboardCard(title: 'Measurement Range', value: '0 – 100 m', icon: Icons.straighten, iconColor: Colors.green),
                    DashboardCard(title: 'ML Models Active', value: '5 Classifiers', icon: Icons.psychology, iconColor: Colors.purple),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            const Text(
              'Research Workflow',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
            ),
            const SizedBox(height: 16),
            _buildWorkflowStepper(),
            
            const SizedBox(height: 40),
            
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
            ),
            const SizedBox(height: 16),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowStepper() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _workflowItem('Measurement', Icons.settings_remote, true),
            _workflowArrow(),
            _workflowItem('Analysis', Icons.analytics, true),
            _workflowArrow(),
            _workflowItem('ML Classification', Icons.smart_toy, true),
            _workflowArrow(),
            _workflowItem('Safe-Zone', Icons.security, true),
          ],
        ),
      ),
    );
  }

  Widget _workflowItem(String label, IconData icon, bool active) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active ? AppTheme.primaryNavy.withValues(alpha: 0.05) : Colors.grey.shade50,
            shape: BoxShape.circle,
            border: Border.all(color: active ? AppTheme.primaryNavy : Colors.grey.shade300),
          ),
          child: Icon(icon, color: active ? AppTheme.primaryNavy : Colors.grey.shade400),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? AppTheme.primaryNavy : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _workflowArrow() {
    return Icon(Icons.chevron_right, color: Colors.grey.shade300);
  }

  Widget _buildQuickActions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 2 : 2);
        double aspectRatio = constraints.maxWidth > 600 ? 1.5 : 1.1;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
          children: [
            _actionCard(context, 'Record/View\nMeasurements', Icons.list_alt, Colors.blue, 'measurements'),
            _actionCard(context, 'Run ML\nPrediction', Icons.auto_graph, Colors.purple, 'prediction'),
            _actionCard(context, 'View Model\nPerformance', Icons.speed, Colors.orange, 'performance'),
            _actionCard(context, 'Analyze\nSafe Zone', Icons.verified_user, Colors.green, 'safe_zone'),
          ],
        );
      },
    );
  }

  Widget _actionCard(BuildContext context, String title, IconData icon, Color color, String route) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          NavigationUtils.navigateTo(context, route);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
