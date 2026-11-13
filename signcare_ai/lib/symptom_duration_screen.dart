import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'consultation_manager.dart';
import 'l10n_ext.dart';
import 'summary_labels.dart';
import 'symptoms_data.dart';

class SymptomDetailsScreen extends StatefulWidget {
  final List<SymptomItem> items;
  const SymptomDetailsScreen({super.key, required this.items});

  @override
  State<SymptomDetailsScreen> createState() => _SymptomDetailsScreenState();
}

class _SymptomDetailsScreenState extends State<SymptomDetailsScreen> {
  final Map<String, int> _intensity = {};
  final Map<String, String> _duration = {};

  DurationOption? _durationFor(String symptomId) {
    final id = _duration[symptomId];
    if (id == null) return null;
    return durationOptions.firstWhere((o) => o.id == id);
  }

  List<String> _lines(String sep, bool isUrdu) => [
        for (final s in widget.items)
          symptomLine(s, _intensity[s.id], _durationFor(s.id), isUrdu, sep),
      ];

  void _speakAll() {
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';
    speakItem(context, _lines(', ', isUrdu).join('. '));
  }

  void _save() {
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';
    for (final line in _lines(' — ', isUrdu)) {
      ConsultationManager.addItem('Symptoms', line);
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';

    String severity(int v) {
      if (v <= 3) return l10n.symMild;
      if (v <= 6) return l10n.symModerate;
      if (v <= 9) return l10n.symSevere;
      return l10n.symWorst;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.symDetailsTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final s in widget.items)
                  Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(s.emoji, style: const TextStyle(fontSize: 30)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  s.name(isUrdu),
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(l10n.symHowStrong,
                              style: context.text.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant)),
                          const SizedBox(height: 8),
                          _ScaleRow(
                            value: _intensity[s.id],
                            onChanged: (v) =>
                                setState(() => _intensity[s.id] = v),
                          ),
                          if (_intensity[s.id] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                severity(_intensity[s.id]!),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.lerp(Colors.green, Colors.red,
                                      _intensity[s.id]! / 10),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(l10n.symWhenStart,
                              style: context.text.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              for (final d in durationOptions)
                                ChoiceChip(
                                  label: Text(capitalize(d.text(isUrdu))),
                                  selected: _duration[s.id] == d.id,
                                  onSelected: (on) => setState(() {
                                    if (on) {
                                      _duration[s.id] = d.id;
                                    } else {
                                      _duration.remove(s.id);
                                    }
                                  }),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _speakAll,
                    icon: const Icon(Icons.volume_up),
                    label: Text(l10n.typeSpeak),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.assignment_add),
                      label: Text(l10n.symSave),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 0 se 10 tak rangeen gol buttons (hamesha left-to-right)
class _ScaleRow extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;
  const _ScaleRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (int i = 0; i <= 10; i++) _dot(i),
        ],
      ),
    );
  }

  Widget _dot(int i) {
    final color = Color.lerp(Colors.green, Colors.red, i / 10)!;
    final selected = value == i;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => onChanged(i),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
        ),
        child: Text(
          '$i',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}