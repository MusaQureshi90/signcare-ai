import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/app_localizations.dart';
import 'l10n_ext.dart';
import 'summary_store.dart';
import 'tts_service.dart';

String categoryLabel(AppLocalizations l10n, String code) {
  switch (code) {
    case SummaryCategory.cards:
      return l10n.catCards;
    case SummaryCategory.typed:
      return l10n.catTyped;
    case SummaryCategory.symptom:
      return l10n.catSymptom;
    case SummaryCategory.body:
      return l10n.catBody;
    case SummaryCategory.emotion:
      return l10n.catEmotion;
    case SummaryCategory.emergency:
      return l10n.catEmergency;
    case SummaryCategory.speech:
      return l10n.catSpeech;
    case SummaryCategory.note:
      return l10n.catNote;
    default:
      return l10n.catOther;
  }
}

IconData categoryIcon(String code) {
  switch (code) {
    case SummaryCategory.cards:
      return Icons.note_add_outlined;
    case SummaryCategory.typed:
      return Icons.keyboard_outlined;
    case SummaryCategory.symptom:
      return Icons.sick_outlined;
    case SummaryCategory.body:
      return Icons.accessibility_new;
    case SummaryCategory.emotion:
      return Icons.sentiment_satisfied_alt;
    case SummaryCategory.emergency:
      return Icons.warning_amber_rounded;
    case SummaryCategory.speech:
      return Icons.mic;
    case SummaryCategory.note:
      return Icons.edit_note;
    default:
      return Icons.label_outline;
  }
}

Color categoryColor(String code) {
  switch (code) {
    case SummaryCategory.cards:
      return Colors.teal;
    case SummaryCategory.typed:
      return Colors.blue;
    case SummaryCategory.symptom:
      return Colors.orange;
    case SummaryCategory.body:
      return Colors.pink;
    case SummaryCategory.emotion:
      return Colors.purple;
    case SummaryCategory.emergency:
      return Colors.red;
    case SummaryCategory.speech:
      return Colors.cyan;
    case SummaryCategory.note:
      return Colors.green;
    default:
      return Colors.blueGrey;
  }
}

String genderLabel(AppLocalizations l10n, String gender) {
  switch (gender) {
    case 'Male':
      return l10n.genderMale;
    case 'Female':
      return l10n.genderFemale;
    case 'Other':
      return l10n.genderOther;
    default:
      return '';
  }
}

String formatDateTime(BuildContext context, DateTime date) {
  final lang = Localizations.localeOf(context).languageCode;
  return DateFormat.yMMMd(lang).add_jm().format(date);
}

/// Ek item bolta hai; na bol sake to snackbar dikhata hai
Future<void> speakItem(BuildContext context, String text) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final result = await TtsService.instance.speak(text);
  if (result == SpeakResult.languageMissing) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.ttsVoiceMissingBody)));
  } else if (result == SpeakResult.failed) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.ttsError)));
  }
}