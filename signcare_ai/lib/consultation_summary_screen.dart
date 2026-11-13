import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'l10n_ext.dart';
import 'report_history_screen.dart';
import 'report_paper.dart';
import 'report_share.dart';
import 'show_mode_screen.dart';
import 'summary_labels.dart';
import 'summary_store.dart';
import 'user_profile.dart';

class ConsultationSummaryScreen extends StatefulWidget {
  const ConsultationSummaryScreen({super.key});

  @override
  State<ConsultationSummaryScreen> createState() =>
      _ConsultationSummaryScreenState();
}

class _ConsultationSummaryScreenState extends State<ConsultationSummaryScreen> {
  final SummaryStore _store = SummaryStore.instance;
  final UserProfile _profile = UserProfile.instance;
  final GlobalKey _paperKey = GlobalKey();
  final DateTime _openedAt = DateTime.now();
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    _store.ensureLoaded();
    _profile.load();
  }

  // ---------------- Actions ----------------
  Future<void> _addNote() async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const _NoteDialog(),
    );
    if (text != null && text.trim().isNotEmpty) {
      await _store.add(SummaryCategory.note, text);
    }
  }

  Future<void> _confirmClear() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.sumClearTitle),
        content: Text(l10n.sumClearBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.sumClear,
              style: TextStyle(color: dialogContext.colors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) await _store.clearDraft();
  }

  Future<void> _saveToHistory() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await _store.saveToHistory();
    if (ok) messenger.showSnackBar(SnackBar(content: Text(l10n.sumSaved)));
  }

  Future<void> _share() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final dateText = formatDateTime(context, _openedAt);

    final mode = await pickShareMode(context);
    if (mode == null) return;

    bool ok;
    if (mode == ShareMode.text) {
      ok = await shareReportText(
        buildReportText(
          l10n,
          dateText: dateText,
          patientName: _profile.name,
          age: _profile.age,
          gender: _profile.gender,
          items: _store.items,
        ),
      );
    } else {
      // Buttons chhupao, ek frame ruko, phir image lo
      setState(() => _capturing = true);
      await WidgetsBinding.instance.endOfFrame;
      ok = await shareReportImage(_paperKey);
      if (mounted) setState(() => _capturing = false);
    }

    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.sumShareFailed)));
    }
  }

  void _open(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_store, _profile]),
      builder: (context, _) {
        final l10n = context.l10n;
        final items = _store.items;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.sumTitle),
            actions: [
              IconButton(
                tooltip: l10n.sumAddNote,
                icon: const Icon(Icons.note_add_outlined),
                onPressed: _addNote,
              ),
              IconButton(
                tooltip: l10n.sumHistory,
                icon: const Icon(Icons.history),
                onPressed: () => _open(const ReportHistoryScreen()),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'clear') _confirmClear();
                },
                itemBuilder: (_) => [
                  PopupMenuItem<String>(
                    value: 'clear',
                    enabled: items.isNotEmpty,
                    child: Text(l10n.sumClear),
                  ),
                ],
              ),
            ],
          ),
          body: items.isEmpty
              ? _buildEmpty(context)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: RepaintBoundary(
                    key: _paperKey,
                    child: ReportPaper(
                      items: items,
                      patientName: _profile.name,
                      age: _profile.age,
                      gender: _profile.gender,
                      createdAt: _openedAt,
                      onRemove: _capturing
                          ? null
                          : (item) => _store.remove(item.id),
                      onSpeak: _capturing
                          ? null
                          : (item) => speakItem(context, item.text),
                    ),
                  ),
                ),
          bottomNavigationBar: items.isEmpty
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _open(const ShowModeScreen()),
                          icon: const Icon(Icons.fullscreen),
                          label: Text(l10n.sumShowMode),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _share,
                                icon: const Icon(Icons.share_outlined),
                                label: Text(l10n.sumShare),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _saveToHistory,
                                icon: const Icon(Icons.bookmark_add_outlined),
                                label: Text(
                                  l10n.sumSaveHistory,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: colors.outline),
            const SizedBox(height: 16),
            Text(
              l10n.sumEmptyTitle,
              style: context.text.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.sumEmptyBody,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _addNote,
              icon: const Icon(Icons.note_add_outlined),
              label: Text(l10n.sumAddNote),
            ),
          ],
        ),
      ),
    );
  }
}

/// Note likhne ka dialog (controller apna khud sambhalta hai)
class _NoteDialog extends StatefulWidget {
  const _NoteDialog();

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.sumAddNote),
      content: TextField(
        controller: _controller,
        autofocus: true,
        minLines: 3,
        maxLines: 5,
        maxLength: 300,
        decoration: InputDecoration(hintText: l10n.sumNoteHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
