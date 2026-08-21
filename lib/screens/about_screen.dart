import 'package:flutter/material.dart';
import '../navigation/app_drawer.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.info_outline, color: Colors.white70),
            SizedBox(width: 12),
            Text('About'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: 'about'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAboutResearch(),
            const SizedBox(height: 40),
            _buildResearchObjectives(),
            const SizedBox(height: 40),
            _buildStudyParameters(),
            const SizedBox(height: 40),
            _buildTeamSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutResearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About the Research',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Text(
            'Measurement of EMF Distribution of 161 kV Transmission Line and Safe Zone of Inhabitants.\n\n'
            'This research project focuses on characterizing electromagnetic fields around high-voltage transmission lines '
            'and using machine learning to classify exposure levels and determine safe setback distances for residents.',
            style: TextStyle(fontSize: 15, height: 1.6),
          ),
        ),
      ],
    );
  }

  Widget _buildResearchObjectives() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Research Objectives', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _objectiveItem('1', 'Measure and characterize E-field and B-field around 161 kV line at various distances, heights, and load conditions.'),
        _objectiveItem('2', 'Develop and evaluate five ML classifiers (RF, SVM, KNN, GB, MLP) for exposure classification.'),
        _objectiveItem('3', 'Determine safe zone/setback distance considering ICNIRP levels and 0.4 µT precautionary threshold.'),
      ],
    );
  }

  Widget _objectiveItem(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 12, backgroundColor: AppTheme.primaryNavy, child: Text(num, style: const TextStyle(color: Colors.white, fontSize: 12))),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildStudyParameters() {
    return Card(
      color: AppTheme.secondaryBlue,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Study Parameters', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _paramRow('Voltage', '161 kV'),
            _paramRow('Frequency', '50 Hz'),
            _paramRow('Distances', '0 – 100 m (5 m intervals)'),
            _paramRow('Heights', '1.0 m, 1.5 m, 1.8 m'),
            _paramRow('Loads', 'Off-Peak, Average, Maximum'),
          ],
        ),
      ),
    );
  }

  Widget _paramRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Text(value, style: const TextStyle(color: AppTheme.accentElectricBlue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Research Team', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        const Text('Students', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 3 : 2);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.7,
              children: [
                _teamCard('PHILIP OWUSU', 'Index No: 06232067', imagePath: 'assets/pylip.jpeg'),
                _teamCard('ANTWI BENJAMIN', 'Index No: 06232026', imagePath: 'assets/antwi.jpeg'),
                _teamCard('ACHEAMPONG FREDERICK', 'Index No: 06230515', imagePath: 'assets/frederick.jpeg'),
              ],
            );
          },
        ),
        const SizedBox(height: 40),
        const Text('Supervisor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            // Calculate width to match student card width in the grid
            int crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 3 : 2);
            double spacing = 20.0 * (crossAxisCount - 1);
            double cardWidth = (constraints.maxWidth - spacing) / crossAxisCount;
            
            return Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: cardWidth,
                child: _teamCard('Mr. OPPONG TAWIAH MATTHEW', 'Research Supervisor', imagePath: 'assets/supervisor.jpeg'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _teamCard(String name, String role, {String? imagePath}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade100,
              child: imagePath != null
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
