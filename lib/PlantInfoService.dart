// plant_info_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rose/plantinfo.dart';

class PlantInfoService {
  static Future<List<PlantInfo>> loadPlantInfo(int index) async {
    // String path = 'assets/data/$index.json';

    try {
      final String jsonString = await rootBundle.loadString('assets/data/$index.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => PlantInfo.fromJson(json)).toList();
    } catch (e) {
      print("Error loading plant info: $e");
      return [];
    }
  }
}
