import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'l10n_ext.dart';
import 'summary_labels.dart';
import 'summary_store.dart';
import 'user_profile.dart';

class ShowModeScreen extends StatelessWidget {
  const ShowModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = SummaryStore.instance;
    final profile = UserProfile.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([store, profile]),
      builder: (context, _) {
        final l10n = context.l10n;
        final colors = context.colors;

        final grouped = <String, List<SummaryItem>>{};
        for (final item in store.items) {
          grouped.putIfAbsent(item.category, () => []).add(item);
        }
        final codes = <String>[
          ...SummaryCategory.order.where(grouped.containsKey),
          ...grouped.keys.where((k) => !SummaryCategory.order.contains(k)),
        ];

        final age = profile.age;
        final genderText = genderLabel(l10n, profile.gender);
        final info = <String>[
          if (age != null) l10n.profileAge(age),
          if (genderText.isNotEmpty) genderText,
        ].join('  •  ');

        return Scaffold(
          appBar: AppBar(title: Text(l10n.sumShowMode)),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (profile.name.isNotEmpty)
                Text(
                  profile.name,
                  style: context.text.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              if (info.isNotEmpty)
                Text(
                  info,
                  style: context.text.titleMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              for (final code in codes) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: categoryColor(code).withAlpha(40),
                      child: Icon(categoryIcon(code),
                          color: categoryColor(code), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        categoryLabel(l10n, code),
                        style: context.text.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: categoryColor(code),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final item in grouped[code]!)
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 4, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.text,
                              style: const TextStyle(
                                  fontSize: 26, height: 1.35),
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.sumReadAloud,
                            icon: Icon(Icons.volume_up_outlined,
                                color: colors.primary),
                            onPressed: () => speakItem(context, item.text),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 20),
              Text(
                l10n.sumDisclaimer,
                textAlign: TextAlign.center,
                style: context.text.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}