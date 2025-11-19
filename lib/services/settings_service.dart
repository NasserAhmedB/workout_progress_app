import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _weightUnitKey = 'weight_unit';
  static const String _languageKey = 'language';

  SharedPreferences? _prefs;
  
  // In-memory fallback storage when SharedPreferences fails
  String _memoryWeightUnit = 'kg';
  String _memoryLanguage = 'en';

  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      // Load existing values from persistent storage
      _memoryWeightUnit = _prefs?.getString(_weightUnitKey) ?? 'kg';
      _memoryLanguage = _prefs?.getString(_languageKey) ?? 'en';
    } catch (e) {
      // If SharedPreferences fails (e.g., in web), continue with memory storage
      _prefs = null;
    }
  }

  // Weight Unit (kg or lb)
  String getWeightUnit() {
    if (_prefs != null) {
      return _prefs!.getString(_weightUnitKey) ?? _memoryWeightUnit;
    }
    return _memoryWeightUnit;
  }

  Future<void> setWeightUnit(String unit) async {
    _memoryWeightUnit = unit;
    await _prefs?.setString(_weightUnitKey, unit);
  }

  bool isKg() {
    return getWeightUnit() == 'kg';
  }

  // Convert weight between kg and lb
  double convertWeight(double weight, {bool toKg = true}) {
    if (toKg) {
      return weight * 0.453592; // lb to kg
    } else {
      return weight * 2.20462; // kg to lb
    }
  }

  // Display weight with correct unit
  String formatWeight(double weight) {
    final unit = getWeightUnit();
    return '${weight.toStringAsFixed(1)} $unit';
  }

  // Language (en or ar)
  String getLanguage() {
    if (_prefs != null) {
      return _prefs!.getString(_languageKey) ?? _memoryLanguage;
    }
    return _memoryLanguage;
  }

  Future<void> setLanguage(String language) async {
    _memoryLanguage = language;
    await _prefs?.setString(_languageKey, language);
  }

  bool isArabic() {
    return getLanguage() == 'ar';
  }

  bool isEnglish() {
    return getLanguage() == 'en';
  }
}
