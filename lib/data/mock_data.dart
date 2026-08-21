import '../models/emf_measurement.dart';
import '../models/ml_performance.dart';

class MockData {
  static List<EMFMeasurement> getMeasurements() {
    return List.generate(21, (index) {
      double distance = index * 5.0;
      // Representative values based on 161 kV RF model
      // Note: Model shows very fast decay in first 2m, then stabilizes
      double electricField = 22.5 / (1 + (distance > 0 ? 0.05 : 0));
      double magneticFlux = 0.55 / (1 + (distance > 0 ? 0.05 : 0));
      
      return EMFMeasurement(
        distance: distance,
        height: 1.5,
        loadCondition: LoadCondition.averagePeak,
        electricField: double.parse(electricField.toStringAsFixed(2)),
        magneticFlux: double.parse(magneticFlux.toStringAsFixed(2)),
      );
    });
  }

  static List<MLPerformance> getModelPerformance() {
    return [
      MLPerformance(modelName: 'Random Forest', accuracy: 0.98, precision: 0.97, recall: 0.98, f1Score: 0.975, auc: 0.99),
      MLPerformance(modelName: 'SVM', accuracy: 0.94, precision: 0.93, recall: 0.94, f1Score: 0.935, auc: 0.96),
      MLPerformance(modelName: 'KNN', accuracy: 0.92, precision: 0.91, recall: 0.92, f1Score: 0.915, auc: 0.94),
      MLPerformance(modelName: 'Gradient Boosting', accuracy: 0.97, precision: 0.96, recall: 0.97, f1Score: 0.965, auc: 0.98),
      MLPerformance(modelName: 'MLP (Neural Network)', accuracy: 0.95, precision: 0.94, recall: 0.95, f1Score: 0.945, auc: 0.97),
    ];
  }
}
