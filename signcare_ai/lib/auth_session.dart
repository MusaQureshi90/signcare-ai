import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'app_settings.dart';
import 'consultation_manager.dart';
import 'user_profile.dart';

/// Login ki halat. Kahin se bhi:  AuthSession.instance.isLoggedIn
///
/// Token FlutterSecureStorage mein rehta hai. Baqi purani screens/stores
/// 'logged_phone' wagera SharedPreferences se parhti hain, isliye yahan se
/// wo keys bhi sath sath likhi/mitayi jati hain (password KABHI nahi).
class AuthSession extends ChangeNotifier with WidgetsBindingObserver {
  AuthSession._();
  static final AuthSession instance = AuthSession._();

  static const String _kToken = 'auth_token';
  static const String _kProfile = 'auth_profile';
  // true = phone ki settings server tak nahi pahunchi (net band tha)
  static const String _kSettingsDirty = 'settings_dirty';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient get _api => ApiClient.instance;

  String? _token;
  Map<String, dynamic> _profile = {};
  bool _remember = true;
  bool _restored = false;
  bool _observing = false;
  DateTime? _lastRefresh;

  bool get isRestored => _restored;
  bool get isLoggedIn => _token != null;
  Map<String, dynamic> get profile => Map.unmodifiable(_profile);

  String field(String key) => (_profile[key] ?? '').toString();
  String get phone => field('phone_number');
  String get name => field('name');

  // ---------------- app khulte waqt ----------------

  /// Phone mein saved login parhta hai. main() mein ek baar bulana hai.
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();

    // Purane version ka local plain password, ab kabhi nahi rakhna.
    for (final key in prefs.getKeys().toList()) {
      if (key.startsWith('reg_pass_')) await prefs.remove(key);
    }

    try {
      _token = await _storage.read(key: _kToken);
      final raw = await _storage.read(key: _kProfile);
      if (_token != null && raw != null) {
        final decoded = jsonDecode(raw);
        if (decoded is Map) _profile = Map<String, dynamic>.from(decoded);
      }
    } catch (e) {
      debugPrint('AuthSession.restore error: $e');
      _token = null;
      _profile = {};
    }

    // Purani Settings screen logout par sirf is_logged_in=false likhti hai.
    // Wo bhi logout maana jaye.
    final flag = prefs.getBool('is_logged_in') ?? false;
    if (_token != null && !flag) {
      await _deleteStored();
      _token = null;
      _profile = {};
    }
    if (_token == null) {
      await prefs.remove('logged_phone');
      await prefs.remove('logged_name');
      await prefs.remove('is_logged_in');
    } else {
      _remember = true; // token sirf tab save hota hai jab remember ho
    }

    _restored = true;
    if (!_observing) {
      WidgetsBinding.instance.addObserver(this);
      _observing = true;
    }
    notifyListeners();
    if (_token != null) unawaited(refreshProfile());
  }

  /// App background se wapas aaye to server se taaza data (30 second mein ek baar).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || _token == null) return;
    final last = _lastRefresh;
    if (last != null &&
        DateTime.now().difference(last) < const Duration(seconds: 30)) {
      return;
    }
    unawaited(refreshProfile());
  }

  /// Server se taaza profile. Internet na ho to chupchap chhod deta hai.
  ///
  /// Agar phone ki settings abhi server tak nahi pahunchi thin to pehle wo
  /// bhejta hai (phone jeetta hai). Warna server ki settings phone par lagata hai.
  Future<void> refreshProfile() async {
    if (_token == null) return;
    _lastRefresh = DateTime.now();
    if (await _isSettingsDirty()) {
      await syncSettings();
      return;
    }
    final res = await _authed((t) => _api.get('/me/', token: t));
    final p = res.profile;
    if (res.ok && p != null) {
      await _adoptProfile(p);
      await _applyServerSettings();
    }
  }

  Future<bool> _isSettingsDirty() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kSettingsDirty) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _setSettingsDirty(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setBool(_kSettingsDirty, true);
      } else {
        await prefs.remove(_kSettingsDirty);
      }
    } catch (e) {
      debugPrint('AuthSession dirty flag error: $e');
    }
  }

  /// Language / theme / layout server par bhejta hai. Fail ho jaye to flag
  /// rehta hai aur agli dafa (app kholne par) dobara koshish hoti hai.
  Future<ApiResult> syncSettings() async {
    if (_token == null) {
      return const ApiResult(status: 401, error: ApiError.unauthorized);
    }
    await _setSettingsDirty(true);
    final s = AppSettings.instance;
    final res = await updateProfile({
      'language': s.languageName,
      'theme_mode': _themeName(s.themeMode),
      'home_layout': s.homeLayout,
    });
    if (res.ok) await _setSettingsDirty(false);
    return res;
  }

  static String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }

  // ---------------- register / login ----------------

  Future<ApiResult> register({
    required String phone,
    required String password,
    String name = '',
    String age = '',
    String gender = '',
    String language = 'English',
    String theme = 'light',
    String layout = 'List',
    bool remember = true,
  }) async {
    final res = await _api.post('/auth/register/', body: {
      'phone_number': phone,
      'password': password,
      'name': name,
      'age': age,
      'gender': gender,
      'language': language,
      'theme_mode': theme,
      'home_layout': layout,
      'device': Platform.operatingSystem,
      'remember_me': remember,
    });
    if (res.ok) await _startSession(res, remember, applySettings: false);
    return res;
  }

  Future<ApiResult> login({
    required String phone,
    required String password,
    bool remember = true,
  }) async {
    final res = await _api.post('/auth/login/', body: {
      'phone_number': phone,
      'password': password,
      'device': Platform.operatingSystem,
      'remember_me': remember,
    });
    if (res.ok) await _startSession(res, remember, applySettings: true);
    return res;
  }

  /// Local logout foran hota hai; server ko batane ke liye max 5 second.
  Future<void> logout() async {
    final t = _token;
    if (t != null) {
      await _api.post('/auth/logout/', token: t).timeout(
            const Duration(seconds: 5),
            onTimeout: () =>
                const ApiResult(status: 0, error: ApiError.timeout),
          );
    }
    await _clear();
  }

  // ---------------- account ----------------

  /// fields mein sirf wohi bhejein jo badalna hai:
  /// name, age, gender, language, theme_mode, home_layout
  Future<ApiResult> updateProfile(Map<String, dynamic> fields) async {
    final res = await _authed((t) => _api.patch('/me/', body: fields, token: t));
    final p = res.profile;
    if (res.ok && p != null) await _adoptProfile(p);
    return res;
  }

  Future<ApiResult> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return _authed((t) => _api.post(
          '/auth/change-password/',
          body: {'old_password': oldPassword, 'new_password': newPassword},
          token: t,
        ));
  }

  /// Login ke bagair: phone + recovery code + naya password.
  /// Kamyabi par res.recoveryCode mein NAYA code hota hai, user ko dikhana hai.
  Future<ApiResult> resetPassword({
    required String phone,
    required String recoveryCode,
    required String newPassword,
  }) {
    return _api.post('/auth/reset-password/', body: {
      'phone_number': phone,
      'recovery_code': recoveryCode,
      'new_password': newPassword,
    });
  }

  Future<ApiResult> deleteAccount({required String password}) async {
    final res = await _authed(
      (t) => _api.post('/me/delete/', body: {'password': password}, token: t),
    );
    if (res.ok) {
      // Is phone ka user data bhi hatao (language/theme/layout bacha ke)
      try {
        final prefs = await SharedPreferences.getInstance();
        const keep = {'app_language', 'app_theme', 'home_layout'};
        for (final key in prefs.getKeys().toList()) {
          if (!keep.contains(key)) await prefs.remove(key);
        }
      } catch (e) {
        debugPrint('AuthSession wipe error: $e');
      }
      await _clear();
    }
    return res;
  }

  // ---------------- andar ke helpers ----------------

  Future<ApiResult> _authed(
    Future<ApiResult> Function(String token) call,
  ) async {
    final t = _token;
    if (t == null) {
      return const ApiResult(status: 401, error: ApiError.unauthorized);
    }
    final res = await call(t);
    if (res.error == ApiError.unauthorized) {
      await _clear(); // token khatam, dobara login karna hoga
    }
    return res;
  }

  Future<void> _startSession(
    ApiResult res,
    bool remember, {
    required bool applySettings,
  }) async {
    ConsultationManager.clear(); // pichle user ka data memory se hatao
    await _setSettingsDirty(false); // pichle user ka pending flag
    _token = res.token;
    _profile = res.profile ?? {};
    _remember = remember;
    try {
      if (remember && _token != null) {
        await _storage.write(key: _kToken, value: _token);
        await _storage.write(key: _kProfile, value: jsonEncode(_profile));
      } else {
        await _deleteStored();
      }
    } catch (e) {
      debugPrint('AuthSession save error: $e');
    }
    await _writeLegacyPrefs();
    if (applySettings) await _applyServerSettings();
    await UserProfile.instance.load();
    notifyListeners();
  }

  Future<void> _adoptProfile(Map<String, dynamic> p) async {
    _profile = p;
    if (_remember) {
      try {
        await _storage.write(key: _kProfile, value: jsonEncode(_profile));
      } catch (e) {
        debugPrint('AuthSession profile save error: $e');
      }
    }
    await _writeLegacyPrefs();
    await UserProfile.instance.load();
    notifyListeners();
  }

  /// Purani screens/stores ye keys parhti hain.
  Future<void> _writeLegacyPrefs() async {
    final p = phone;
    if (p.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_phone', p);
      await prefs.setString('logged_name', name);
      await prefs.setBool('is_logged_in', _remember);
      await prefs.setString('reg_name_$p', name);
      await prefs.setString('reg_age_$p', field('age'));
      await prefs.setString('reg_gender_$p', field('gender'));
      await prefs.remove('reg_pass_$p');
    } catch (e) {
      debugPrint('AuthSession prefs error: $e');
    }
  }

  /// Naye phone par login karte hi us account ki saved settings lagao.
  Future<void> _applyServerSettings() async {
    final s = AppSettings.instance;
    final lang = field('language');
    if (lang == 'English' || lang == 'Urdu') await s.setLanguageName(lang);

    final theme = field('theme_mode');
    if (theme == 'dark') {
      await s.setThemeMode(ThemeMode.dark);
    } else if (theme == 'system') {
      await s.setThemeMode(ThemeMode.system);
    } else if (theme == 'light') {
      await s.setThemeMode(ThemeMode.light);
    }

    final layout = field('home_layout');
    if (layout == 'List' || layout == 'Grid') await s.setHomeLayout(layout);
  }

  Future<void> _deleteStored() async {
    try {
      await _storage.delete(key: _kToken);
      await _storage.delete(key: _kProfile);
    } catch (e) {
      debugPrint('AuthSession delete error: $e');
    }
  }

  Future<void> _clear() async {
    _token = null;
    _profile = {};
    await _deleteStored();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('logged_phone');
      await prefs.remove('logged_name');
      await prefs.remove('is_logged_in');
      await prefs.remove(_kSettingsDirty);
    } catch (e) {
      debugPrint('AuthSession clear error: $e');
    }
    ConsultationManager.clear(); // agla user pichle ka data na dekhe
    await UserProfile.instance.load(); // khali profile
    notifyListeners();
  }
}
