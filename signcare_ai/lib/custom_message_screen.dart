import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'consultation_manager.dart';
import 'l10n_ext.dart';
import 'summary_labels.dart';

const List<List<String>> _starters = [
  ['I have a question', 'میرا ایک سوال ہے'],
  ['I need help', 'مجھے مدد چاہیے'],
  ['Please wait a moment', 'براہ کرم تھوڑا انتظار کریں'],
  ['I did not understand', 'مجھے سمجھ نہیں آئی'],
  ['Please speak slowly', 'براہ کرم آہستہ بولیں'],
  ['Thank you', 'شکریہ'],
];

bool _hasUrdu(String s) => RegExp(r'[\u0600-\u06FF]').hasMatch(s);

class CustomMessageScreen extends StatefulWidget {
  const CustomMessageScreen({super.key});

  @override
  State<CustomMessageScreen> createState() => _CustomMessageScreenState();
}

class _CustomMessageScreenState extends State<CustomMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _recent = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _loadRecent();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _key() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('logged_phone') ?? '';
    return 'typed_recent_${phone.isEmpty ? 'guest' : phone}';
  }

  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(await _key()) ?? <String>[];
    if (!mounted) return;
    setState(() => _recent = list);
  }

  Future<void> _remember(String text) async {
    final list = List<String>.from(_recent)..remove(text);
    list.insert(0, text);
    final trimmed = list.length > 10 ? list.sublist(0, 10) : list;
    if (mounted) setState(() => _recent = trimmed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(await _key(), trimmed);
  }

  Future<void> _clearRecent() async {
    setState(() => _recent = []);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(await _key());
  }

  // ---------------- Actions ----------------
  String? _textOrWarn() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.msgEmpty)));
      return null;
    }
    return text;
  }

  void _speak() {
    final text = _textOrWarn();
    if (text == null) return;
    speakItem(context, text);
    _remember(text);
  }

  void _show() {
    final text = _textOrWarn();
    if (text == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _BigTextScreen(text: text),
      ),
    );
  }

  void _addToSummary() {
    final text = _textOrWarn();
    if (text == null) return;
    ConsultationManager.addItem('Custom Typed Message', text);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.typeAdded)));
  }

  void _fill(String text) {
    _controller.text = text;
    _controller.selection = TextSelection.collapsed(offset: text.length);
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';
    final text = _controller.text;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.msgTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            minLines: 4,
            maxLines: 7,
            style: const TextStyle(fontSize: 20),
            textDirection: text.isEmpty
                ? null
                : (_hasUrdu(text) ? TextDirection.rtl : TextDirection.ltr),
            decoration: InputDecoration(
              hintText: l10n.msgHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              suffixIcon: text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.speechClear,
                      icon: const Icon(Icons.clear),
                      onPressed: _controller.clear,
                    ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _speak,
              icon: const Icon(Icons.volume_up),
              label: Text(l10n.typeSpeak, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _show,
                  icon: const Icon(Icons.fullscreen),
                  label: Text(l10n.msgShow),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _addToSummary,
                  icon: const Icon(Icons.assignment_add),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(l10n.cardsAddSummary),
                  ),
                ),
              ),
            ],
          ),

          // ---------- Tayyar jumle ----------
          _header(context, l10n.msgQuick),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final s in _starters)
                ActionChip(
                  label: Text(isUrdu ? s[1] : s[0]),
                  onPressed: () => _fill(isUrdu ? s[1] : s[0]),
                ),
            ],
          ),

          // ---------- Pichle jumle ----------
          if (_recent.isNotEmpty) ...[
            _header(
              context,
              l10n.msgRecent,
              trailing: TextButton(
                onPressed: _clearRecent,
                child: Text(l10n.speechClear),
              ),
            ),
            for (final r in _recent)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _fill(r),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(14, 4, 0, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(r, style: const TextStyle(fontSize: 16)),
                        ),
                        IconButton(
                          tooltip: l10n.typeSpeak,
                          icon: Icon(Icons.volume_up, color: colors.primary),
                          onPressed: () => speakItem(context, r),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 22, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Poori screen par bohat bada text (samne wale ko dikhane ke liye)
class _BigTextScreen extends StatelessWidget {
  final String text;
  const _BigTextScreen({required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Directionality(
                    textDirection:
                        _hasUrdu(text) ? TextDirection.rtl : TextDirection.ltr,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: 4,
                end: 4,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}