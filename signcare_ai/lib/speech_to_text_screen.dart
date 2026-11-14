import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'app_theme.dart';
import 'consultation_manager.dart';
import 'l10n_ext.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _ready = false;
  bool _wantListening = false; // ap ne mic ON kiya hai
  bool _listening = false; // engine abhi sun raha hai
  bool _starting = false;
  bool _langInit = false;

  String _lang = 'en';
  String? _localeId;
  String _live = '';
  String? _message;
  double _fontSize = 26;
  final List<String> _lines = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_langInit) {
      _langInit = true;
      _lang =
          Localizations.localeOf(context).languageCode == 'ur' ? 'ur' : 'en';
    }
  }

  @override
  void dispose() {
    _wantListening = false;
    _speech.cancel();
    super.dispose();
  }

  // ---------------- Engine ----------------
  Future<bool> _ensureReady() async {
    if (_ready) return true;
    try {
      _ready = await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
      );
    } catch (e) {
      debugPrint('speech init error: $e');
      _ready = false;
    }
    return _ready;
  }

  /// Phone ki list mein zabaan mile to wahi, warna seedha ur_PK / en_US try karta hai
  /// (Android ki list aksar adhoori hoti hai, isliye usper bharosa nahi)
  Future<String> _resolveLocale(String lang) async {
    final fallback = lang == 'ur' ? 'ur_PK' : 'en_US';
    try {
      final locales = await _speech.locales();
      String norm(String id) => id.toLowerCase().replaceAll('-', '_');

      final matches = locales
          .where((l) => norm(l.localeId).startsWith('${lang}_'))
          .toList();
      if (matches.isEmpty) return fallback;

      final preferred = lang == 'ur' ? 'ur_pk' : 'en_us';
      for (final l in matches) {
        if (norm(l.localeId) == preferred) return l.localeId;
      }
      return matches.first.localeId;
    } catch (e) {
      debugPrint('speech locales error: $e');
      return fallback;
    }
  }

  Future<void> _start() async {
    final l10n = context.l10n;
    if (!await _ensureReady()) {
      if (!mounted) return;
      setState(() => _message = l10n.speechUnavailable);
      return;
    }
    final locale = await _resolveLocale(_lang);
    if (!mounted) return;
    setState(() {
      _localeId = locale;
      _message = null;
      _wantListening = true;
    });
    await _listenOnce();
  }

  Future<void> _listenOnce() async {
    if (!mounted || !_wantListening || _starting || _speech.isListening) {
      return;
    }
    _starting = true;
    try {
      await _speech.listen(
        onResult: _onResult,
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: false,
        ).copyWith(
          listenFor: const Duration(seconds: 60),
          pauseFor: const Duration(seconds: 5),
          localeId: _localeId,
        ),
      );
      if (mounted) setState(() => _listening = true);
    } catch (e) {
      debugPrint('speech listen error: $e');
    } finally {
      _starting = false;
    }
  }

  void _onResult(SpeechRecognitionResult r) {
    if (!mounted) return;
    setState(() {
      _live = r.recognizedWords;
      if (r.finalResult) _commit();
    });
  }

  void _commit() {
    final t = _live.trim();
    if (t.isNotEmpty) _lines.insert(0, t);
    _live = '';
  }

  void _onStatus(String status) {
    if (!mounted) return;
    if (status == 'done' || status == 'notListening') {
      setState(() {
        _listening = false;
        if (_live.trim().isNotEmpty) _commit();
      });
      if (_wantListening) {
        Future.delayed(const Duration(milliseconds: 400), _listenOnce);
      }
    }
  }

  void _onError(SpeechRecognitionError e) {
    debugPrint('speech error: ${e.errorMsg} permanent=${e.permanent}');
    if (!mounted) return;
    final msg = e.errorMsg.toLowerCase();
    final noPermission = msg.contains('permission');
    final langProblem = msg.contains('language');

    if (e.permanent || noPermission || langProblem) {
      final l10n = context.l10n;
      setState(() {
        _wantListening = false;
        _listening = false;
        if (noPermission) {
          _message = l10n.speechPermission;
        } else if (langProblem) {
          _message = l10n.speechNoLocale;
        } else {
          _message = l10n.speechUnavailable;
        }
      });
    }
    // Baqi errors (jaise khamoshi) par status handler khud dobara shuru karta hai
  }

  Future<void> _stop() async {
    setState(() {
      _wantListening = false;
      _listening = false;
      if (_live.trim().isNotEmpty) _commit();
    });
    await _speech.stop();
  }

  Future<void> _toggle() async {
    if (_wantListening) {
      await _stop();
    } else {
      await _start();
    }
  }

  Future<void> _changeLanguage(String lang) async {
    final was = _wantListening;
    if (was) await _stop();
    if (!mounted) return;
    setState(() {
      _lang = lang;
      _message = null;
    });
    if (was) await _start();
  }

  // ---------------- Small actions ----------------
  Future<void> _copy(String text) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(SnackBar(content: Text(l10n.speechCopied)));
  }

  void _addToSummary(String text) {
    final l10n = context.l10n;
    ConsultationManager.addItem('Speech', text);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.typeAdded)));
  }

  void _resize(double delta) {
    setState(() => _fontSize = (_fontSize + delta).clamp(18, 48).toDouble());
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    final bigText =
        _live.isNotEmpty ? _live : (_lines.isNotEmpty ? _lines.first : '');
    final history = _live.isNotEmpty ? _lines : _lines.skip(1).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.speechTitle),
        actions: [
          IconButton(
            tooltip: l10n.speechSmaller,
            icon: const Icon(Icons.text_decrease),
            onPressed: () => _resize(-4),
          ),
          IconButton(
            tooltip: l10n.speechBigger,
            icon: const Icon(Icons.text_increase),
            onPressed: () => _resize(4),
          ),
          IconButton(
            tooltip: l10n.speechClear,
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => setState(() {
              _lines.clear();
              _live = '';
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(value: 'en', label: Text('English')),
                  ButtonSegment<String>(value: 'ur', label: Text('اردو')),
                ],
                selected: {_lang},
                onSelectionChanged: (s) => _changeLanguage(s.first),
              ),
            ),
          ),

          // ---------- Bada text ----------
          Expanded(
            flex: 3,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      _message ?? (bigText.isEmpty ? l10n.speechIdle : bigText),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _message != null || bigText.isEmpty
                            ? 18
                            : _fontSize,
                        fontWeight: FontWeight.w600,
                        color: _message != null
                            ? colors.error
                            : (bigText.isEmpty
                                ? colors.onSurfaceVariant
                                : colors.onSurface),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (_listening)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                children: [
                  const LinearProgressIndicator(),
                  const SizedBox(height: 4),
                  Text(l10n.speechListening,
                      style: context.text.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant)),
                ],
              ),
            ),

          // ---------- History ----------
          if (history.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.speechEarlier,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                itemCount: history.length,
                itemBuilder: (context, i) {
                  final t = history[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(14, 4, 0, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(t, style: const TextStyle(fontSize: 16)),
                          ),
                          IconButton(
                            tooltip: l10n.speechCopy,
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () => _copy(t),
                          ),
                          IconButton(
                            tooltip: l10n.cardsAddSummary,
                            icon: Icon(Icons.assignment_add,
                                size: 22, color: colors.primary),
                            onPressed: () => _addToSummary(t),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else
            const Spacer(flex: 1),

          // ---------- Mic button ----------
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: _wantListening ? colors.error : null,
                    foregroundColor: _wantListening ? colors.onError : null,
                  ),
                  onPressed: _toggle,
                  icon: Icon(_wantListening ? Icons.stop : Icons.mic),
                  label: Text(
                    _wantListening ? l10n.speechStop : l10n.speechStart,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}