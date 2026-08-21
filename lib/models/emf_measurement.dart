enum LoadCondition { offPeak, averagePeak, maximumPeak }

extension LoadConditionExtension on LoadCondition {
  String get display {
    switch (this) {
      case LoadCondition.offPeak: return 'Off-Peak';
      case LoadCondition.averagePeak: return 'Average-Peak';
      case LoadCondition.maximumPeak: return 'Maximum-Peak';
    }
  }
}

class EMFMeasurement {
  final double distance;
  final double height;
  final LoadCondition loadCondition;
  final double electricField; // V/m
  final double magneticFlux; // µT

  EMFMeasurement({
    required this.distance,
    required this.height,
    required this.loadCondition,
    required this.electricField,
    required this.magneticFlux,
  });

  bool get isIcnirpCompliant => electricField <= 5000.0 && magneticFlux <= 100.0;
  bool get isPrecautionaryCompliant => magneticFlux <= 0.4;
}
