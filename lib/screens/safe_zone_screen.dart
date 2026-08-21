import 'package:flutter/material.dart';
import '../navigation/app_drawer.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';

class SafeZoneScreen extends StatefulWidget {
  const SafeZoneScreen({super.key});

  @override
  State<SafeZoneScreen> createState() => _SafeZoneScreenState();
}

class _SafeZoneScreenState extends State<SafeZoneScreen> {
  double _safeDistance = 35.0; // Default fallback
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSafeZone();
  }

  Future<void> _fetchSafeZone() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Calculate safe zone for Maximum-Peak load as per research requirement
      final result = await ApiService.getSafeZoneDistance(
        height: 1.5,
        loadCondition: 'Maximum-Peak',
      );
      
      if (mounted) {
        setState(() {
          if (result.containsKey('safe_distance') && result['safe_distance'] != null) {
            _safeDistance = (result['safe_distance'] as num).toDouble();
            _isLoading = false;
          } else {
            _errorMessage = 'API returned invalid data. Using fallback.';
            _isLoading = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.location_on, color: Colors.white70),
            SizedBox(width: 12),
            Flexible(child: Text('Safe Zone Analysis', overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSafeZone,
            tooltip: 'Recalculate',
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: 'safe_zone'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transmission Line Setback Analysis',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_errorMessage, style: const TextStyle(color: AppTheme.dangerRed, fontSize: 12)),
              ),
            const SizedBox(height: 32),
            
            _buildVisualizationCard(context),
            const SizedBox(height: 32),
            _buildSpatialHeatmap(),
            const SizedBox(height: 32),
            _buildDistanceDecayChart(),
            const SizedBox(height: 32),
            _buildResultSummary(),
            const SizedBox(height: 32),
            
            _buildComplianceCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Spatial Exposure Visualization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            
            // Visual Representation
            Center(
              child: Column(
                children: [
                  const Icon(Icons.bolt, color: Colors.amber, size: 60),
                  const Text('161 kV TRANSMISSION LINE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 30),
                  
                  // Gradient Zone Representation
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.dangerRed,
                          AppTheme.warningOrange,
                          AppTheme.successGreen,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Expanded(child: Center(child: FittedBox(child: Text('Danger', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))),
                        Expanded(child: Center(child: FittedBox(child: Text('Precautionary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))),
                        Expanded(child: Center(child: FittedBox(child: Text('Safe Zone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))),
                      ],
                    ),
                  ),
                  
                  // Distance markers
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(child: FittedBox(child: Text('0 m'))),
                        Flexible(child: FittedBox(child: Text('${(_safeDistance / 2).toStringAsFixed(0)} m'))),
                        Flexible(child: FittedBox(child: Text('${_safeDistance.toStringAsFixed(0)} m'))),
                        const Flexible(child: FittedBox(child: Text('100 m'))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpatialHeatmap() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Spatial Exposure Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.dangerRed.withValues(alpha: 0.8),
                    AppTheme.warningOrange.withValues(alpha: 0.5),
                    AppTheme.successGreen.withValues(alpha: 0.2),
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
              child: const Center(
                child: Text(
                  '161 kV Line Proximity Heatmap',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Visualization shows field intensity decreasing with lateral distance from the centerline.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceDecayChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Magnetic Flux vs Distance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 1.0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 0.72), // Near tower (Danger)
                        const FlSpot(5, 0.44), // Edge of danger
                        FlSpot(_safeDistance, 0.40), // Safety Threshold
                        const FlSpot(30, 0.24), // Clear Safe Zone
                        const FlSpot(60, 0.19), // Far Zone
                        const FlSpot(100, 0.19), // Decay limit
                      ],
                      color: AppTheme.primaryNavy,
                      barWidth: 4,
                      isCurved: true,
                    ),
                    // Threshold Line
                    LineChartBarData(
                      spots: const [FlSpot(0, 0.4), FlSpot(100, 0.4)],
                      color: AppTheme.dangerRed,
                      barWidth: 2,
                      dashArray: [5, 5],
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Distance (m)'),
                      sideTitles: SideTitles(showTitles: true, interval: 25),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(width: 12, height: 2, color: AppTheme.dangerRed),
                const SizedBox(width: 8),
                const Text('0.4 µT Precautionary Limit', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSummary() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppTheme.primaryNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Recommended Setback Distance',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Based on 0.4 µT threshold + safety margin',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.accentElectricBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _isLoading 
              ? const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: AppTheme.primaryNavy))
              : Text(
                '${_safeDistance.toStringAsFixed(0)} m',
                style: const TextStyle(color: AppTheme.primaryNavy, fontSize: 32, fontWeight: FontWeight.bold),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _assessmentCard('ICNIRP Assessment', 'Compliant from 12m', Icons.check_circle, Colors.green),
            _assessmentCard('Precautionary Assessment', 'Compliant from ${_safeDistance.toStringAsFixed(0)}m', Icons.info, Colors.orange),
            _assessmentCard('Engineering Margin', '+ 5m safety buffer', Icons.verified_user, Colors.blue),
          ],
        );
      },
    );
  }

  Widget _assessmentCard(String title, String result, IconData icon, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(result, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
