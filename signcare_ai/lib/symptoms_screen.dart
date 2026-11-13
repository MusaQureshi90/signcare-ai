import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'l10n_ext.dart';
import 'symptom_duration_screen.dart';
import 'symptoms_data.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final Set<String> _selected = {};
  final List<SymptomItem> _custom = [];

  List<SymptomItem> get _all => [..._custom, ...symptomList];

  void _toggle(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      if (!_selected.remove(id)) _selected.add(id);
    });
  }

  Future<void> _addOther() async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const _OtherDialog(),
    );
    if (text == null || text.trim().isEmpty || !mounted) return;
    final item = SymptomItem(
      'x_${DateTime.now().microsecondsSinceEpoch}',
      '🩹',
      text.trim(),
      text.trim(),
      custom: true,
    );
    setState(() {
      _custom.insert(0, item);
      _selected.add(item.id);
    });
  }

  Future<void> _next() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final items = _all.where((s) => _selected.contains(s.id)).toList();

    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => SymptomDetailsScreen(items: items)),
    );

    if (saved == true && mounted) {
      setState(_selected.clear);
      messenger.showSnackBar(SnackBar(content: Text(l10n.symSaved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';
    final all = _all;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.symTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.symPickHint,
                style: context.text.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                mainAxisExtent: 112,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: all.length + 1,
              itemBuilder: (context, i) {
                if (i == all.length) return _otherCard(context);
                return _symptomCard(context, all[i], isUrdu);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selected.isEmpty ? null : _next,
                  child: Text(l10n.symNext(_selected.length)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _symptomCard(BuildContext context, SymptomItem s, bool isUrdu) {
    final colors = context.colors;
    final selected = _selected.contains(s.id);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: selected ? colors.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? colors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: () => _toggle(s.id),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                child: Column(
                  children: [
                    Text(s.emoji, style: const TextStyle(fontSize: 34)),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Center(
                        child: Text(
                          s.name(isUrdu),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: selected ? colors.onPrimaryContainer : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (selected)
            PositionedDirectional(
              top: 6,
              end: 6,
              child: Icon(Icons.check_circle, size: 20, color: colors.primary),
            ),
        ],
      ),
    );
  }

  Widget _otherCard(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _addOther,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 34, color: colors.primary),
            const SizedBox(height: 6),
            Text(
              l10n.symOther,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtherDialog extends StatefulWidget {
  const _OtherDialog();

  @override
  State<_OtherDialog> createState() => _OtherDialogState();
}

class _OtherDialogState extends State<_OtherDialog> {
  final TextEditingController _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.symOtherTitle),
      content: TextField(
        controller: _text,
        autofocus: true,
        maxLines: 2,
        inputFormatters: [LengthLimitingTextInputFormatter(60)],
        decoration: InputDecoration(labelText: l10n.symOtherLabel),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _text.text),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
