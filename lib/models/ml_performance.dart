class MLPerformance {
  final String modelName;
  final double accuracy;
  final double precision;
  final double recall;
  final double f1Score;
  final double auc;

  MLPerformance({
    required this.modelName,
    required this.accuracy,
    required this.precision,
    required this.recall,
    required this.f1Score,
    required this.auc,
  });
}
