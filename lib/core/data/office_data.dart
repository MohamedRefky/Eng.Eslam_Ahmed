import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../main.dart';

class OfficeData {
  static final Map<String, Map<String, dynamic>> _cache = {};

  static Map<String, dynamic> get data {
    final currentLang = appLocale.value.languageCode;
    return _cache[currentLang] ?? _cache.values.firstOrNull ?? {};
  }

  static Future<void> load([String lang = 'ar']) async {
    // 1. Load active language if not cached
    if (!_cache.containsKey(lang)) {
      await _loadLanguage(lang);
    }

    // 2. Preload the other language in the background so it's ready when switched
    final otherLang = lang == 'ar' ? 'en' : 'ar';
    if (!_cache.containsKey(otherLang)) {
      _loadLanguage(otherLang).catchError((e) {
        debugPrint('Failed to background preload other language: $e');
      });
    }
  }

  static Future<void> _loadLanguage(String lang) async {
    try {
      final ByteData data = await rootBundle.load('assets/data/data_$lang.json');
      final String jsonString = utf8.decode(data.buffer.asUint8List());
      _cache[lang] = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      _cache[lang] = {};
      debugPrint('Error loading portfolio data for $lang: $e');
    }
  }
}

