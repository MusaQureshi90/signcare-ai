import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'app_settings.dart';

/// Login hue user ka profile data (naam, umar, gender) ek hi jagah.
/// Kahin se bhi:   UserProfile.instance.name
class UserProfile extends ChangeNotifier {
  UserProfile._();
  static final UserProfile instance = UserProfile._();

  String phone = '';
  String name = '';
  String ageText = ''; // purana format: "26 years (14/03/2000)"
  String gender = ''; // 'Male' / 'Female' / 'Other' ya khali

  /// ageText ke andar (dd/mm/yyyy) se tareekh nikalta hai
  DateTime? get dateOfBirth {
    final match = RegExp(r'(\d{2})/(\d{2})/(\d{4})').firstMatch(ageText);
    if (match == null) return null;
    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);
    final date = DateTime(year, month, day);
    // 31/02 jaisi galat tareekh ko reject karo
    if (date.month != month || date.day != day) return null;
    return date;
  }

  int? get age {
    final dob = dateOfBirth;
    return dob == null ? null : ageFromDate(dob);
  }

  /// Sahi umar: din aur mahina bhi dekhta hai
  static int ageFromDate(DateTime dob) {
    final now = DateTime.now();
    int years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  static String _normalizeGender(String value) {
    switch (value.trim().toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      default:
        return '';
    }
  }

  /// Phone ki saved details parhta hai
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('logged_phone') ?? '';
    if (phone.isEmpty) {
      name = '';
      ageText = '';
      gender = '';
    } else {
      name =
          prefs.getString('reg_name_$phone') ??
          prefs.getString('logged_name') ??
          '';
      ageText = prefs.getString('reg_age_$phone') ?? '';
      gender = _normalizeGender(prefs.getString('reg_gender_$phone') ?? '');
    }
    notifyListeners();
  }

  /// Pehle is device par save (foran). Server par bhejna background mein hota
  /// hai, isliye ye function kabhi atakta nahi.
  Future<void> save({
    required String newName,
    required DateTime dob,
    required String newGender,
  }) async {
    if (phone.isEmpty) return;

    final dd = dob.day.toString().padLeft(2, '0');
    final mm = dob.month.toString().padLeft(2, '0');

    name = newName.trim();
    ageText = '${ageFromDate(dob)} years ($dd/$mm/${dob.year})';
    gender = newGender;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reg_name_$phone', name);
    await prefs.setString('logged_name', name);
    await prefs.setString('reg_age_$phone', ageText);
    await prefs.setString('reg_gender_$phone', gender);
    notifyListeners();

    unawaited(_syncToServer(prefs));
  }

  Future<void> _syncToServer(SharedPreferences prefs) async {
    // Pehle server se parho. Na parh sako to khali data likhne se bacho.
    final server = await ApiService.getPreferences(phone);
    if (server == null) return;

    String password = prefs.getString('reg_pass_$phone') ?? '';
    if (password.isEmpty) {
      password = server['password']?.toString() ?? '';
    }

    final s = AppSettings.instance;
    final themeName = s.themeMode == ThemeMode.dark
        ? 'dark'
        : (s.themeMode == ThemeMode.system ? 'system' : 'light');

    await ApiService.savePreferences(
      phone,
      name,
      ageText,
      gender,
      password,
      s.languageName,
      themeName,
      s.homeLayout,
    );
  }
}
