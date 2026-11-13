import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum SpeakResult { ok, languageMissing, failed }

/// Poori app ke liye ek hi "bolne wala". Kahin se bhi:
///   TtsService.instance.speak('text');
class TtsService extends ChangeNotifier {
  TtsService._();
  static final TtsService instance = TtsService._();

  static const double defaultRate = 0.45;

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool _speaking = false;

  bool get isSpeaking => _speaking;

  /// Text mein Urdu (Arabic script) ke harf hain?
  static bool containsUrdu(String text) =>
      RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  static String languageFor(String text) =>
      containsUrdu(text) ? 'ur-PK' : 'en-US';

  void _setSpeaking(bool value) {
    if (_speaking == value) return;
    _speaking = value;
    notifyListeners();
  }

  Future<void> _init() async {
    if (_ready) return;
    _tts.setStartHandler(() => _setSpeaking(true));
    _tts.setCompletionHandler(() => _setSpeaking(false));
    _tts.setCancelHandler(() => _setSpeaking(false));
    _tts.setErrorHandler((message) {
      debugPrint('TTS error: $message');
      _setSpeaking(false);
    });
    await _tts.setPitch(1.0);
    _ready = true;
  }

  Future<bool> _isAvailable(String language) async {
    try {
      final result = await _tts.isLanguageAvailable(language);
      return result == true || result == 1;
    } catch (_) {
      return false;
    }
  }

  /// [language] na do to text dekh kar khud chunta hai.
  Future<SpeakResult> speak(
    String text, {
    String? language,
    double rate = defaultRate,
  }) async {
    final clean = text.trim();
    if (clean.isEmpty) return SpeakResult.failed;

    try {
      await _init();
      final lang = language ?? languageFor(clean);

      // Urdu voice phone mein na ho to ajeeb awaaz ki jagah user ko batao
      if (lang.startsWith('ur') && !await _isAvailable(lang)) {
        return SpeakResult.languageMissing;
      }

      await _tts.stop(); // pehli awaaz band, warna awaazein chadh jati hain
      await _tts.setLanguage(lang);
      await _tts.setSpeechRate(rate);
      final result = await _tts.speak(clean);
      return result == 0 ? SpeakResult.failed : SpeakResult.ok;
    } catch (e) {
      debugPrint('TTS speak error: $e');
      return SpeakResult.failed;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
    _setSpeaking(false);
  }
}
