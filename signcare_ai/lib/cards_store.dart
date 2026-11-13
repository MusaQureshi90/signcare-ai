import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cards_data.dart';

/// Favourites, recent aur apne cards (har account ke alag) + "tap par bolo" setting
class CardsStore extends ChangeNotifier {
  CardsStore._();
  static final CardsStore instance = CardsStore._();

  static const int maxCustom = 30;
  static const int maxRecent = 12;
  static const String _speakKey = 'cards_speak_on_tap';

  String _phone = '';
  bool _loaded = false;
  Future<void>? _loading;

  bool _speakOnTap = true;
  Set<String> _favourites = {};
  List<String> _recent = [];
  List<CardItem> _custom = [];

  bool get speakOnTap => _speakOnTap;
  List<String> get recent => List.unmodifiable(_recent);
  List<CardItem> get custom => List.unmodifiable(_custom);
  bool isFavourite(String id) => _favourites.contains(id);

  String get _who => _phone.isEmpty ? 'guest' : _phone;
  String get _favKey => 'cards_fav_$_who';
  String get _recentKey => 'cards_recent_$_who';
  String get _customKey => 'cards_custom_$_who';

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
    _speakOnTap = prefs.getBool(_speakKey) ?? true;
    _favourites = (prefs.getStringList(_favKey) ?? <String>[]).toSet();
    _recent = List<String>.from(prefs.getStringList(_recentKey) ?? <String>[]);
    _custom = [];

    final raw = prefs.getString(_customKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final data = jsonDecode(raw);
        if (data is List) {
          _custom = data
              .whereType<Map>()
              .map((e) => CardItem.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      } catch (e) {
        debugPrint('custom cards decode error: $e');
      }
    }
    notifyListeners();
  }

  /// Logout par: sirf memory saaf (phone mein saved rehta hai)
  void unload() {
    _phone = '';
    _loaded = false;
    _favourites = {};
    _recent = [];
    _custom = [];
    notifyListeners();
  }

  Future<void> setSpeakOnTap(bool value) async {
    _speakOnTap = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_speakKey, value);
  }

  Future<void> toggleFavourite(String id) async {
    await ensureLoaded();
    if (!_favourites.remove(id)) _favourites.add(id);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favKey, _favourites.toList());
  }

  Future<void> markUsed(String id) async {
    await ensureLoaded();
    _recent.remove(id);
    _recent.insert(0, id);
    if (_recent.length > maxRecent) {
      _recent = _recent.sublist(0, maxRecent);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentKey, _recent);
  }

  /// false = 30 se zyada apne cards
  Future<bool> addCustom(String emoji, String text) async {
    await ensureLoaded();
    if (_custom.length >= maxCustom) return false;
    _custom = [
      CardItem(
        'u_${DateTime.now().microsecondsSinceEpoch}',
        emoji,
        text.trim(),
        text.trim(),
        'custom',
        custom: true,
      ),
      ..._custom,
    ];
    notifyListeners();
    await _saveCustom();
    return true;
  }

  Future<void> remove(String id) async {
    await ensureLoaded();
    _custom = _custom.where((c) => c.id != id).toList();
    _favourites.remove(id);
    _recent.remove(id);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favKey, _favourites.toList());
    await prefs.setStringList(_recentKey, _recent);
    await _saveCustom();
  }

  Future<void> _saveCustom() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _customKey,
      jsonEncode(_custom.map((c) => c.toJson()).toList()),
    );
  }
}
