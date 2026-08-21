import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for others
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    } catch (_) {}
    return 'http://127.0.0.1:8000';
  }

  static Future<Map<String, dynamic>> predict({
    required double distance,
    required double height,
    required String loadCondition,
    required String modelName,
  }) async {
    final url = Uri.parse('$baseUrl/predict');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'distance': distance,
        'height': height,
        'load_condition': loadCondition,
        'model_name': modelName,
      }),
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to get prediction from server');
    }
  }

  static Future<Map<String, dynamic>> getSafeZoneDistance({
    double height = 1.5,
    String loadCondition = 'Maximum-Peak',
    String modelName = 'Random Forest',
  }) async {
    final url = Uri.parse('$baseUrl/safe-zone?height=$height&load_condition=$loadCondition&model_name=$modelName');
    
    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to get safe zone distance');
    }
  }
}
