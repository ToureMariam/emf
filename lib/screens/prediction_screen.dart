import 'package:flutter/material.dart';
import '../navigation/app_drawer.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/emf_measurement.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedModel = 'Random Forest';
  LoadCondition _selectedLoad = LoadCondition.averagePeak;
  double _distance = 20;
  double _height = 1.5;
  
  bool _showResult = false;
  bool _isLoading = false;
  Map<String, dynamic>? _apiResult;

  final List<String> _models = [
    'Random Forest',
    'Support Vector Machine (SVM)',
    'k-Nearest Neighbours (KNN)',
    'Gradient Boosting',
    'Multilayer Perceptron (MLP)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.psychology, color: Colors.white70),
            SizedBox(width: 12),
            Text('ML Prediction'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: 'prediction'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exposure Classification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter environmental and measurement data to predict exposure compliance using machine learning.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 32),
            
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: _buildForm()),
                      const SizedBox(width: 32),
                      Expanded(flex: 1, child: _isLoading 
                        ? const Center(child: CircularProgressIndicator()) 
                        : (_showResult ? _buildResultCard() : _buildEmptyState())),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildForm(),
                      const SizedBox(height: 32),
                      _isLoading 
                        ? const CircularProgressIndicator() 
                        : (_showResult ? _buildResultCard() : _buildEmptyState()),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownField('Select Machine Learning Model', _selectedModel, _models, (val) => setState(() => _selectedModel = val!)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildTextField('Distance (m)', '20', (val) => _distance = double.tryParse(val) ?? 0.0)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Height (m)', '1.5', (val) => _height = double.tryParse(val) ?? 0.0)),
                ],
              ),
              const SizedBox(height: 20),
              _buildDropdownField('Load Condition', _selectedLoad.display, LoadCondition.values.map((e) => e.display).toList(), 
                (val) => setState(() => _selectedLoad = LoadCondition.values.firstWhere((e) => e.display == val))),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _handlePredict,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryNavy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Predict Exposure', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String initial, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initial,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _handlePredict() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _showResult = false;
    });

    try {
      final result = await ApiService.predict(
        distance: _distance,
        height: _height,
        loadCondition: _selectedLoad.display,
        modelName: _selectedModel,
      );

      setState(() {
        _apiResult = result;
        _showResult = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        String message = e.toString().contains('Exception:') 
            ? e.toString().split('Exception:')[1] 
            : 'Could not reach the backend server. Please ensure the Python FastAPI server is running.';
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildResultCard() {
    final isCompliant = _apiResult?['is_compliant'] ?? false;
    final classification = _apiResult?['classification'] ?? 'UNKNOWN';
    final resultBField = _apiResult?['magnetic_flux'] ?? 0.0;
    final resultEField = _apiResult?['electric_field'] ?? 0.0;
    final thresholdB = _apiResult?['threshold_b'] ?? 0.4;
    final metrics = _apiResult?['metrics'] ?? {};
    final r2 = metrics['r2'] ?? 0.0;
    
    Color color = isCompliant ? AppTheme.successGreen : AppTheme.dangerRed;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(isCompliant ? Icons.verified : Icons.warning, color: color, size: 64),
            ),
            const SizedBox(height: 24),
            Text(
              classification,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color, letterSpacing: 1.5),
            ),
            const SizedBox(height: 8),
            const Text('Exposure Prediction Result', style: TextStyle(color: Colors.grey)),
            const Divider(height: 40),
            _resultRow('Selected Model', _selectedModel),
            _resultRow('Model R² Score', '${(r2 * 100).toStringAsFixed(1)}% Accuracy'),
            _resultRow('Height', '$_height m'),
            _resultRow('Electric Field', '${resultEField.toStringAsFixed(2)} V/m'),
            _resultRow('Magnetic Flux', '${resultBField.toStringAsFixed(2)} µT'),
            _resultRow('Threshold (B)', '$thresholdB µT (Precautionary)'),
            _resultRow('Distance', '$_distance m'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
              child: Text(
                isCompliant 
                  ? 'The predicted exposure level is within safe limits according to the $thresholdB µT precautionary threshold.'
                  : 'The predicted exposure level exceeds the $thresholdB µT precautionary threshold. Caution is advised.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '* Note: This prediction is generated by the ${_selectedModel} model, scaled and optimized for current environment parameters.',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.psychology_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Enter data and press Predict\nto see results here', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
        ],
      ),
    );
  }
}
