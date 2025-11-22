import 'dart:convert';

import 'package:flutter/services.dart';

class JsonLoaderService {
  static Future<List<dynamic>> loadJsonArrayAsset(String assetPath) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonArray = json.decode(jsonString) as List<dynamic>;

      print('Loaded ${jsonArray.length} items directly from array');
      return jsonArray;
    } catch (e) {
      print('Error in JsonLoaderService: $e');
      rethrow;
    }
  }
}