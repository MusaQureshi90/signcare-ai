import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile.dart';

/// Summary ke hisse. Ye codes zubaan se alag hain (sirf display par translate hote hain).
class SummaryCategory {
  static const String cards = 'cards';
  static const String typed = 'typed';
  static const String symptom = 'symptom';
  static const String body = 'body';
  static const String emotion = 'emotion';
  static const String emergency = 'emergency';
  static const String speech = 'speech';
  static const String note = 'note';
  static const String other = 'other';

  /// Report mein dikhne ka tarteeb
  static const List<String> order = [
    emergency, symptom, body, emotion, cards, typed, speech, note, other,
  ];

  /// Purani screens English naam bhejti hain ('Common Needs' waghera)
  static String fromLegacy(String label) {
    final t = label.toLowerCase();
    if (t.contains('common') || t.contains('card')) return cards;
    if (t.contains('typed') || t.contains('custom')) return typed;
    if (t.contains('symptom') || t.contains('pain')) return symptom;
    if (t.contains('body')) return body;
    if (t.contains('emotion')) return emotion;
    if (t.contains('emergency')) return emergency;
    if (t.contains('speech')) return speech;
    if (t.contains('note')) return note;
    return other;
  }
}

class SummaryItem {
  final String id;
  final String category;
  final String text;
  final DateTime createdAt;

  const SummaryItem({
    required this.id,
    required this.category,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SummaryItem.fromJson(Map<String, dynamic> json) => SummaryItem(
        id: json['id']?.toString() ?? '',
        category: json['category']?.toString() ?? SummaryCategory.other,
        text: json['text']?.toString() ?? '',
        createdAt:
            DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      );
}

class SavedReport {
  final String id;
  final DateTime createdAt;
  final String patientName;
  final int? age;
  final String gender;
  final List<SummaryItem> items;

  const SavedReport({
    required this.id,
    required this.createdAt,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'patientName': patientName,
        'age': age,
        'gender': gender,
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory SavedReport.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return SavedReport(
      id: json['id']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      patientName: json['patientName']?.toString() ?? '',
      age: json['age'] is int ? json['age'] as int : null,
      gender: json['gender']?.toString() ?? '',
      items: rawItems is List
          ? rawItems
              .whereType<Map>()
              .map((e) => SummaryItem.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <SummaryItem>[],
    );
  }
}

/// Patient ka summary (draft) aur saved history. Har account ka alag, phone mein save.
class SummaryStore extends ChangeNotifier {
  SummaryStore._();
  static final SummaryStore instance = SummaryStore._();

  static const int _maxHistory = 50;

  String _phone = '';
  bool _loaded = false;
  Future<void>? _loading;
  List<SummaryItem> _items = [];
  List<SavedReport> _history = [];

  List<SummaryItem> get items => List.unmodifiable(_items);
  List<SavedReport> get history => List.unmodifiable(_history);

  String get _draftKey => 'summary_draft_$_phone';
  String get _historyKey => 'summary_history_$_phone';

  /// Login hue user ka data load karta hai (ek hi baar, account badle to dobara)
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
    _items = [];
    _history = [];
    if (phone.isNotEmpty) {
      _items = _decodeItems(prefs.getString(_draftKey));
      _history = _decodeReports(prefs.getString(_historyKey));
    }
    notifyListeners();
  }

  /// Logout par: sirf memory saaf (phone mein saved data wahi rehta hai)
  void unload() {
    _phone = '';
    _loaded = false;
    _items = [];
    _history = [];
    notifyListeners();
  }

  List<SummaryItem> _decodeItems(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final data = jsonDecode(raw);
      if (data is List) {
        return data
            .whereType<Map>()
            .map((e) => SummaryItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('summary decode error: $e');
    }
    return [];
  }

  List<SavedReport> _decodeReports(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final data = jsonDecode(raw);
      if (data is List) {
        return data
            .whereType<Map>()
            .map((e) => SavedReport.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      debugPrint('history decode error: $e');
    }
    return [];
  }

  Future<void> _persistDraft() async {
    if (_phone.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _draftKey,
      jsonEncode(_items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _persistHistory() async {
    if (_phone.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _historyKey,
      jsonEncode(_history.map((e) => e.toJson()).toList()),
    );
  }

  /// true = naya item juda. false = khali ya pehle se maujood ya login nahi.
  Future<bool> add(String category, String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return false;
    await ensureLoaded();
    if (_phone.isEmpty) return false;
    if (_items.any((i) => i.category == category && i.text == clean)) {
      return false;
    }
    _items = [
      ..._items,
      SummaryItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        category: category,
        text: clean,
        createdAt: DateTime.now(),
      ),
    ];
    notifyListeners();
    await _persistDraft();
    return true;
  }

  Future<void> remove(String id) async {
    _items = _items.where((i) => i.id != id).toList();
    notifyListeners();
    await _persistDraft();
  }

  Future<void> clearDraft() async {
    _items = [];
    notifyListeners();
    await _persistDraft();
  }

  /// Draft ki copy history mein rakhta hai (draft wahi rehta hai)
  Future<bool> saveToHistory() async {
    await ensureLoaded();
    if (_phone.isEmpty || _items.isEmpty) return false;
    final profile = UserProfile.instance;
    final report = SavedReport(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      patientName: profile.name,
      age: profile.age,
      gender: profile.gender,
      items: List<SummaryItem>.from(_items),
    );
    _history = [report, ..._history];
    if (_history.length > _maxHistory) {
      _history = _history.sublist(0, _maxHistory);
    }
    notifyListeners();
    await _persistHistory();
    return true;
  }

  Future<void> deleteReport(String id) async {
    _history = _history.where((r) => r.id != id).toList();
    notifyListeners();
    await _persistHistory();
  }
}