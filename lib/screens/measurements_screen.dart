import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../navigation/app_drawer.dart';
import '../theme/app_theme.dart';
import '../models/emf_measurement.dart';
import '../data/mock_data.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  LoadCondition _selectedLoad = LoadCondition.averagePeak;
  double _selectedHeight = 1.5;
  bool _showElectricField = true;
  final List<EMFMeasurement> _data = MockData.getMeasurements();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.sensors, color: Colors.white70),
            SizedBox(width: 12),
            Text('EMF Measurements'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: 'measurements'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfiguration(),
            const SizedBox(height: 32),
            _buildSummaryCards(),
            const SizedBox(height: 32),
            _buildChartSection(),
            const SizedBox(height: 32),
            _buildAdditionalAnalysis(),
            const SizedBox(height: 32),
            _buildDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfiguration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 30,
          runSpacing: 20,
          children: [
            _buildDropdown<LoadCondition>(
              'Load Condition',
              _selectedLoad,
              LoadCondition.values.map((l) => DropdownMenuItem(value: l, child: Text(l.display))).toList(),
              (val) => setState(() => _selectedLoad = val!),
            ),
            _buildDropdown<double>(
              'Measurement Height',
              _selectedHeight,
              [1.0, 1.5, 1.8].map((h) => DropdownMenuItem(value: h, child: Text('$h m'))).toList(),
              (val) => setState(() => _selectedHeight = val!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(String label, T value, List<DropdownMenuItem<T>> items, ValueChanged<T?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          underline: Container(height: 2, color: AppTheme.primaryNavy),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _metricCard('Electric Field Intensity', '22.57 V/m', Icons.bolt, Colors.amber),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _metricCard('Magnetic Flux Density', '0.55 µT', Icons.waves, Colors.blue),
        ),
      ],
    );
  }

  Widget _metricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('EMF Level vs Distance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('E-Field'), icon: Icon(Icons.bolt)),
                    ButtonSegment(value: false, label: Text('B-Field'), icon: Icon(Icons.waves)),
                  ],
                  selected: {_showElectricField},
                  onSelectionChanged: (set) => setState(() => _showElectricField = set.first),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Distance (m)'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _data.map((m) => FlSpot(m.distance, _showElectricField ? m.electricField : m.magneticFlux)).toList(),
                      isCurved: true,
                      color: _showElectricField ? Colors.amber : Colors.blue,
                      barWidth: 4,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (_showElectricField ? Colors.amber : Colors.blue).withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _showElectricField ? 'Units: V/m' : 'Units: µT',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalAnalysis() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            children: [
              Expanded(child: _analysisCard('Load Condition Impact', _buildLoadImpactChart())),
              const SizedBox(width: 24),
              Expanded(child: _analysisCard('EMF vs Height Comparison', _buildHeightComparisonChart())),
            ],
          );
        } else {
          return Column(
            children: [
              _analysisCard('Load Condition Impact', _buildLoadImpactChart()),
              const SizedBox(height: 24),
              _analysisCard('EMF vs Height Comparison', _buildHeightComparisonChart()),
            ],
          );
        }
      },
    );
  }

  Widget _analysisCard(String title, Widget chart) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            SizedBox(height: 200, child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadImpactChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 0.51, color: Colors.blue, width: 20)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 0.55, color: Colors.orange, width: 20)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 0.64, color: Colors.red, width: 20)]),
        ],
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0: return const Text('Off', style: TextStyle(fontSize: 10));
                  case 1: return const Text('Avg', style: TextStyle(fontSize: 10));
                  case 2: return const Text('Max', style: TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildHeightComparisonChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: const [FlSpot(0, 0.52), FlSpot(50, 0.51), FlSpot(100, 0.51)],
            color: Colors.blue,
            barWidth: 3,
            isCurved: true,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: const [FlSpot(0, 0.55), FlSpot(50, 0.52), FlSpot(100, 0.52)],
            color: Colors.orange,
            barWidth: 3,
            isCurved: true,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: const [FlSpot(0, 0.56), FlSpot(50, 0.53), FlSpot(100, 0.53)],
            color: Colors.green,
            barWidth: 3,
            isCurved: true,
            dotData: const FlDotData(show: false),
          ),
        ],
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildDataTable() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Detailed Measurement Points', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Dist (m)')),
                DataColumn(label: Text('Height (m)')),
                DataColumn(label: Text('Load')),
                DataColumn(label: Text('E-Field (V/m)')),
                DataColumn(label: Text('B-Field (µT)')),
                DataColumn(label: Text('Compliance')),
              ],
              rows: _data.map((m) => DataRow(cells: [
                DataCell(Text(m.distance.toString())),
                DataCell(Text(m.height.toString())),
                DataCell(Text(m.loadCondition.display)),
                DataCell(Text(m.electricField.toString())),
                DataCell(Text(m.magneticFlux.toString())),
                DataCell(_buildStatusChip(m)),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(EMFMeasurement m) {
    bool ok = m.isIcnirpCompliant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (ok ? AppTheme.successGreen : AppTheme.dangerRed).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        ok ? 'Compliant' : 'Non-Compliant',
        style: TextStyle(color: ok ? AppTheme.successGreen : AppTheme.dangerRed, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
