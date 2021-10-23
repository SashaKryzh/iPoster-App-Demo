import 'package:flutter/material.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizationProvider with ChangeNotifier {
  static const _localePrefKey = 'appLocale';

  static const uaLocale = 'uk';
  static const ruLocale = 'ru';
  static const uaLocaleLabel = 'Українська';
  static const ruLocaleLabel = 'Русский';

  String _currentLocale;
  String get currentLocale => _currentLocale;

  Future init() async {
    await _loadPrefferedLocale();
  }

  Future _loadPrefferedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String key = prefs.getString(_localePrefKey);

    // Try to assing locale using preffered languages
    if (key == null) {
      final deviceLocales = (await Devicelocale.preferredLanguages)
          .map((v) => v.split('-').first)
          .toList();
      for (var deviceLocale in deviceLocales) {
        if (deviceLocale == uaLocale || deviceLocale == ruLocale) {
          key = deviceLocale;
          break;
        }
      }
    }

    // If still null, then assign Ukraine
    if (key == null) {
      key = uaLocale;
    }

    _currentLocale = key;
  }

  Future setLocale(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_localePrefKey, key);
    _currentLocale = key;
    notifyListeners();
  }

  Locale getPrefferedLocale() {
    return Locale(_currentLocale);
  }

  String getPrefferedLocaleKey() {
    return _currentLocale;
  }
}
