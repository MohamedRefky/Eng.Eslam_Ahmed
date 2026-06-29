import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class OfficeData {
  static String? _loadedLang;
  static Map<String, dynamic> _data = {};
  static Map<String, dynamic> get data => _data;

  static Future<void> load([String lang = 'ar']) async {
    if (_loadedLang == lang) return;
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/data_$lang.json',
      );
      _data = jsonDecode(jsonString);
      _loadedLang = lang;
    } catch (e) {
      _data = {};
      debugPrint('Error loading portfolio data for $lang: $e');
    }
  }
}
