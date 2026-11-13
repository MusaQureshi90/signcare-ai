import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'l10n/app_localizations.dart';
import 'l10n_ext.dart';
import 'summary_labels.dart';
import 'summary_store.dart';

enum ShareMode { image, text }

/// "Image ya text?" wala bottom sheet
Future<ShareMode?> pickShareMode(BuildContext context) {
  final l10n = context.l10n;
  return showModalBottomSheet<ShareMode>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: Text(l10n.sumShareImage),
            onTap: () => Navigator.pop(sheetContext, ShareMode.image),
          ),
          ListTile(
            leading: const Icon(Icons.text_snippet_outlined),
            title: Text(l10n.sumShareText),
            onTap: () => Navigator.pop(sheetContext, ShareMode.text),
          ),
        ],
      ),
    ),
  );
}

/// RepaintBoundary ki image bana kar share karta hai. true = share sheet khul gayi.
Future<bool> shareReportImage(GlobalKey boundaryKey) async {
  try {
    final context = boundaryKey.currentContext;
    if (context == null) return false;
    final boundary = context.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) return false;

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/signcare_summary_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(data.buffer.asUint8List());

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: 'image/png')]),
    );
    return true;
  } catch (e) {
    debugPrint('shareReportImage error: $e');
    return false;
  }
}

Future<bool> shareReportText(String text) async {
  try {
    await SharePlus.instance.share(ShareParams(text: text));
    return true;
  } catch (e) {
    debugPrint('shareReportText error: $e');
    return false;
  }
}

/// Report ka saada text (WhatsApp waghera ke liye)
String buildReportText(
  AppLocalizations l10n, {
  required String dateText,
  required String patientName,
  required int? age,
  required String gender,
  required List<SummaryItem> items,
}) {
  final buffer = StringBuffer();
  buffer.writeln('${l10n.appName} - ${l10n.sumReportTitle}');
  if (patientName.isNotEmpty) buffer.writeln(patientName);

  final info = <String>[
    if (age != null) l10n.profileAge(age),
    if (genderLabel(l10n, gender).isNotEmpty) genderLabel(l10n, gender),
  ];
  if (info.isNotEmpty) buffer.writeln(info.join(' • '));
  buffer.writeln(l10n.sumCreated(dateText));

  final grouped = <String, List<SummaryItem>>{};
  for (final item in items) {
    grouped.putIfAbsent(item.category, () => []).add(item);
  }
  final codes = <String>[
    ...SummaryCategory.order.where(grouped.containsKey),
    ...grouped.keys.where((k) => !SummaryCategory.order.contains(k)),
  ];
  for (final code in codes) {
    buffer.writeln();
    buffer.writeln('${categoryLabel(l10n, code)}:');
    for (final item in grouped[code]!) {
      buffer.writeln('- ${item.text}');
    }
  }
  buffer.writeln();
  buffer.writeln(l10n.sumDisclaimer);
  return buffer.toString();
}