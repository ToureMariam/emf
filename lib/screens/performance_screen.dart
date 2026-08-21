import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../navigation/app_drawer.dart';
import '../theme/app_theme.dart';
import '../models/ml_performance.dart';
import '../data/mock_data.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MLPerformance> performanceData = MockData.getModelPerformance();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.analytics, color: Colors.white70),
            SizedBox(width: 12),
            Text('Model Performance'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: 'performance'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ML Model Comparison',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
            ),
            const SizedBox(height: 32),
            
            _buildAccuracyChart(performanceData),
            const SizedBox(height: 32),
            
            _buildMetricsTable(performanceData),
            const SizedBox(height: 32),
            _buildClassificationOutcome(),
            const SizedBox(height: 32),
            _buildChartPlaceholders(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccuracyChart(List<MLPerformance> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Model Accuracy Comparison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1.0,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                data[value.toInt()].modelName.split(' ')[0],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 0.2)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.accuracy,
                          color: AppTheme.primaryNavy,
                          width: 30,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsTable(List<MLPerformance> data) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Performance Metrics Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Model')),
                DataColumn(label: Text('Accuracy')),
                DataColumn(label: Text('Precision')),
                DataColumn(label: Text('Recall')),
                DataColumn(label: Text('F1-Score')),
                DataColumn(label: Text('AUC')),
              ],
              rows: data.map((m) => DataRow(cells: [
                DataCell(Text(m.modelName, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(m.accuracy.toString())),
                DataCell(Text(m.precision.toString())),
                DataCell(Text(m.recall.toString())),
                DataCell(Text(m.f1Score.toString())),
                DataCell(Text(m.auc.toString())),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassificationOutcome() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dataset Classification Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(value: 65, title: '65%', color: AppTheme.successGreen, radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    PieChartSectionData(value: 35, title: '35%', color: AppTheme.dangerRed, radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _indicator(AppTheme.successGreen, 'Compliant'),
                const SizedBox(width: 20),
                _indicator(AppTheme.dangerRed, 'Non-Compliant'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicator(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildChartPlaceholders() {
    return Row(
      children: [
        Expanded(
          child: _placeholderCard('Confusion Matrix', Icons.grid_view_rounded),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _placeholderCard('ROC Curve', Icons.show_chart_rounded),
        ),
      ],
    );
  }

  Widget _placeholderCard(String title, IconData icon) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey.shade300, size: 48),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const Text('Placeholder for trained models', style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}
