import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme.dart';
import 'auth_widgets.dart';
import 'l10n_ext.dart';

/// Register ya password reset ke baad naya recovery code dikhata hai.
/// User ke "maine save kar liya" tick kiye bagair aage nahi ja sakte,
/// aur back se bhi nahi nikal sakte (code dobara nahi dikhaya jata).
class RecoveryCodeScreen extends StatefulWidget {
  const RecoveryCodeScreen({
    super.key,
    required this.code,
    required this.nextBuilder,
  });

  final String code;

  /// Agli screen (register ke baad Home, reset ke baad Login).
  final Widget Function() nextBuilder;

  @override
  State<RecoveryCodeScreen> createState() => _RecoveryCodeScreenState();
}

class _RecoveryCodeScreenState extends State<RecoveryCodeScreen> {
  bool _saved = false;

  Future<void> _copy() async {
    final messenger = ScaffoldMessenger.of(context);
    final text = context.l10n.recCopied;
    await Clipboard.setData(ClipboardData(text: widget.code));
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  void _continue() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => widget.nextBuilder()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return PopScope(
      canPop: false,
      child: AuthScaffold(
        title: l10n.recTitle,
        subtitle: l10n.recBody,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SelectableText(
                widget.code,
                textAlign: TextAlign.center,
                style: context.text.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.recShownOnce,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(
              color: colors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _copy,
            icon: const Icon(Icons.copy),
            label: Text(l10n.recCopy),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(l10n.recSavedCheck),
            value: _saved,
            onChanged: (value) => setState(() => _saved = value ?? false),
          ),
          const SizedBox(height: 8),
          AuthButton(
            label: l10n.recContinue,
            onPressed: _saved ? _continue : null,
          ),
        ],
      ),
    );
  }
}
