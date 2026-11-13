import 'package:flutter/material.dart';
import 'l10n_ext.dart';
import 'summary_labels.dart';
import 'summary_store.dart';

class ReportPaper extends StatelessWidget {
  final List<SummaryItem> items;
  final String patientName;
  final int? age;
  final String gender;
  final DateTime createdAt;

  /// Dene par har item ke saath hatane/bolne ke buttons dikhte hain
  /// (image share karte waqt null rakho taake image mein na aayein).
  final void Function(SummaryItem item)? onRemove;
  final void Function(SummaryItem item)? onSpeak;

  const ReportPaper({
    super.key,
    required this.items,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.createdAt,
    this.onRemove,
    this.onSpeak,
  });

  // Kaghaz ke rang hamesha ek jaise (dark mode se alag)
  static const Color _paper = Colors.white;
  static const Color _ink = Color(0xFF1F2933);
  static const Color _muted = Color(0xFF52606D);
  static const Color _brand = Color(0xFF00796B);
  static const Color _line = Color(0xFFD9E2E2);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final grouped = <String, List<SummaryItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    final codes = <String>[
      ...SummaryCategory.order.where(grouped.containsKey),
      ...grouped.keys.where((k) => !SummaryCategory.order.contains(k)),
    ];

    final ageValue = age;
    final genderText = genderLabel(l10n, gender);
    final infoParts = <String>[
      if (ageValue != null) l10n.profileAge(ageValue),
      if (genderText.isNotEmpty) genderText,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: _ink, fontSize: 16, height: 1.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Header ----------
            Row(
              children: [
                const Icon(Icons.health_and_safety_outlined,
                    color: _brand, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appName,
                        style: const TextStyle(
                          color: _brand,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        l10n.sumReportTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (patientName.isNotEmpty)
              Text(
                patientName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            if (infoParts.isNotEmpty)
              Text(
                infoParts.join('  •  '),
                style: const TextStyle(color: _muted, fontSize: 15),
              ),
            Text(
              l10n.sumCreated(formatDateTime(context, createdAt)),
              style: const TextStyle(color: _muted, fontSize: 13),
            ),
            const SizedBox(height: 12),
            const Divider(color: _line, height: 1),

            // ---------- Sections ----------
            for (final code in codes) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(categoryIcon(code), color: categoryColor(code), size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      categoryLabel(l10n, code),
                      style: TextStyle(
                        color: categoryColor(code),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              for (final item in grouped[code]!)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          top: 10, end: 10, start: 4),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: categoryColor(code),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(item.text, style: const TextStyle(fontSize: 17)),
                      ),
                    ),
                    if (onSpeak != null)
                      IconButton(
                        tooltip: l10n.sumReadAloud,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.volume_up_outlined,
                            size: 20, color: _muted),
                        onPressed: () => onSpeak?.call(item),
                      ),
                    if (onRemove != null)
                      IconButton(
                        tooltip: l10n.sumRemoveItem,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.close, size: 20, color: _muted),
                        onPressed: () => onRemove?.call(item),
                      ),
                  ],
                ),
            ],

            // ---------- Footer ----------
            const SizedBox(height: 18),
            const Divider(color: _line, height: 1),
            const SizedBox(height: 10),
            Text(
              l10n.sumDisclaimer,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: _muted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.sumCreatedWith,
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}