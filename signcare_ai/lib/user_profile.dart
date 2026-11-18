import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'auth_session.dart';

/// Login hue user ka profile data (naam, umar, gender) ek hi jagah.
/// Kahin se bhi:   UserProfile.instance.name
///
/// Asal data server par hai. Yahan phone ki local copy hai jo
/// AuthSession ke zariye server se sync hoti hai.
class UserProfile extends ChangeNotifier {
  UserProfile._();
  static final UserProfile instance = UserProfile._();

  String phone = '';
  String name = '';
  String ageText = ''; // format: "26 years (14/03/2000)"
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

  /// Phone ki saved details parhta hai (AuthSession inhe server se likhta hai)
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

  /// Pehle server par save hota hai. Kamyab ho to hi phone ki copy badalti hai,
  /// taake server aur phone kabhi alag na hon. Nakaam ho to result.error mein
  /// wajah hoti hai (jaise internet nahi).
  Future<ApiResult> save({
    required String newName,
    required DateTime dob,
    required String newGender,
  }) async {
    final dd = dob.day.toString().padLeft(2, '0');
    final mm = dob.month.toString().padLeft(2, '0');
    final newAge = '${ageFromDate(dob)} years ($dd/$mm/${dob.year})';

    // AuthSession kamyabi par khud phone ki copy aur UserProfile.load() karta hai
    return AuthSession.instance.updateProfile({
      'name': newName.trim(),
      'age': newAge,
      'gender': newGender,
    });
  }
}
