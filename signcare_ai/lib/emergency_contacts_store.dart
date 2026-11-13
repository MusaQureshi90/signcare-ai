import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyContact {
  final String id;
  final String name;
  final String number;
  final String relation;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.number,
    required this.relation,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'number': number,
    'relation': relation,
  };

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      EmergencyContact(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        number: json['number']?.toString() ?? '',
        relation: json['relation']?.toString() ?? '',
      );
}

/// Har account ke ziada se ziada 5 emergency contacts, phone mein save.
class EmergencyContactsStore extends ChangeNotifier {
  EmergencyContactsStore._();
  static final EmergencyContactsStore instance = EmergencyContactsStore._();

  static const int maxContacts = 5;

  String _phone = '';
  bool _loaded = false;
  Future<void>? _loading;
  List<EmergencyContact> _contacts = [];

  List<EmergencyContact> get contacts => List.unmodifiable(_contacts);

  String get _key => 'emergency_contacts_$_phone';

  /// 7 se 15 digits ka number theek mana jata hai
  static bool isValidNumber(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 7 && digits.length <= 15;
  }

  Future<void> ensureLoaded() {
    final running = _loading;
    if (running != null) return running;
    final future = _load().whenComplete(() {
      _loading = null;
    });
    _loading = future;
    return future;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('logged_phone') ?? '';
    if (_loaded && phone == _phone) return;

    _phone = phone;
    _loaded = true;
    _contacts = [];
    if (phone.isNotEmpty) {
      final raw = prefs.getString(_key);
      if (raw != null && raw.isNotEmpty) {
        try {
          final data = jsonDecode(raw);
          if (data is List) {
            _contacts = data
                .whereType<Map>()
                .map(
                  (e) =>
                      EmergencyContact.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList();
          }
        } catch (e) {
          debugPrint('contacts decode error: $e');
        }
      }
    }
    notifyListeners();
  }

  /// Logout par: sirf memory saaf (phone mein saved rehta hai)
  void unload() {
    _phone = '';
    _loaded = false;
    _contacts = [];
    notifyListeners();
  }

  Future<void> _persist() async {
    if (_phone.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(_contacts.map((e) => e.toJson()).toList()),
    );
  }

  /// false = 5 se zyada ya login nahi
  Future<bool> add(String name, String number, String relation) async {
    await ensureLoaded();
    if (_phone.isEmpty || _contacts.length >= maxContacts) return false;
    _contacts = [
      ..._contacts,
      EmergencyContact(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name.trim(),
        number: number.trim(),
        relation: relation.trim(),
      ),
    ];
    notifyListeners();
    await _persist();
    return true;
  }

  Future<void> update(EmergencyContact updated) async {
    _contacts = _contacts.map((c) => c.id == updated.id ? updated : c).toList();
    notifyListeners();
    await _persist();
  }

  Future<void> remove(String id) async {
    _contacts = _contacts.where((c) => c.id != id).toList();
    notifyListeners();
    await _persist();
  }
}
