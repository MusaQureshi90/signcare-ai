import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App ki global settings: theme, language, home layout.
/// Kahin se bhi use karo:   AppSettings.instance.isUrdu
/// Badalne ke liye:         AppSettings.instance.setLanguageName('Urdu')
class AppSettings extends ChangeNotifier {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  // SharedPreferences ki keys (purani wali hi rakhi hain taake purana data na toote)
  static const String _kTheme = 'app_theme';
  static const String _kLanguage = 'app_language';
  static const String _kLayout = 'home_layout';

  ThemeMode _themeMode = ThemeMode.light;
  String _languageName = 'English';
  String _homeLayout = 'List';

  ThemeMode get themeMode => _themeMode;
  String get languageName => _languageName;
  bool get isUrdu => _languageName == 'Urdu';
  Locale get locale => isUrdu ? const Locale('ur') : const Locale('en');
  String get homeLayout => _homeLayout;

  /// Phone ki saved settings parhta hai.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = _themeFromString(prefs.getString(_kTheme) ?? 'light');
    _languageName = prefs.getString(_kLanguage) == 'Urdu' ? 'Urdu' : 'English';
    _homeLayout = prefs.getString(_kLayout) == 'Grid' ? 'Grid' : 'List';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTheme, _themeToString(mode));
  }

  Future<void> setLanguageName(String name) async {
    _languageName = name == 'Urdu' ? 'Urdu' : 'English';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguage, _languageName);
  }

  Future<void> setHomeLayout(String layout) async {
    _homeLayout = layout == 'Grid' ? 'Grid' : 'List';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLayout, _homeLayout);
  }

  static ThemeMode _themeFromString(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  static String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }
}