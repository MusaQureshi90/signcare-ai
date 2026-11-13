import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'consultation_manager.dart';
import 'l10n_ext.dart';
import 'tts_service.dart';

class CustomMessageScreen extends StatefulWidget {
  const CustomMessageScreen({super.key});

  @override
  State<CustomMessageScreen> createState() => _CustomMessageScreenState();
}

class _CustomMessageScreenState extends State<CustomMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final TtsService _tts = TtsService.instance;

  @override
  void dispose() {
    _tts.stop();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _speak() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final text = _controller.text.trim();

    if (text.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.typeEmptyError)));
      return;
    }

    final result = await _tts.speak(text);
    if (!mounted) return;

    if (result == SpeakResult.languageMissing) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.ttsVoiceMissingTitle),
          content: Text(l10n.ttsVoiceMissingBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    } else if (result == SpeakResult.failed) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.ttsError)));
    }
  }

  void _addToSummary() {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final text = _controller.text.trim();

    if (text.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.typeEmptyError)));
      return;
    }
    ConsultationManager.addItem('Custom Typed Message', text);
    messenger.showSnackBar(SnackBar(content: Text(l10n.typeAdded)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = _controller.text;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.typeTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.typeInstruction,
            style: context.text.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            minLines: 5,
            maxLines: 8,
            style: const TextStyle(fontSize: 20, height: 1.4),
            // Urdu likho to text khud right-to-left ho jaye
            textDirection: TtsService.containsUrdu(text)
                ? TextDirection.rtl
                : null,
            decoration: InputDecoration(hintText: l10n.typeHint),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: text.isEmpty
                  ? null
                  : () {
                      _controller.clear();
                      setState(() {});
                    },
              icon: const Icon(Icons.clear),
              label: Text(l10n.typeClear),
            ),
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: _tts,
            builder: (context, _) {
              final speaking = _tts.isSpeaking;
              return ElevatedButton.icon(
                onPressed: speaking ? _tts.stop : _speak,
                icon: Icon(speaking ? Icons.stop : Icons.volume_up),
                label: Text(
                  speaking ? l10n.typeStop : l10n.typeSpeak,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _addToSummary,
            icon: const Icon(Icons.assignment_add),
            label: Text(
              l10n.typeAddToSummary,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
