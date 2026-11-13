import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'l10n_ext.dart';
import 'report_paper.dart';
import 'report_share.dart';
import 'summary_labels.dart';
import 'summary_store.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  final SummaryStore _store = SummaryStore.instance;

  @override
  void initState() {
    super.initState();
    _store.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final l10n = context.l10n;
        final colors = context.colors;
        final reports = _store.history;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.sumHistoryTitle)),
          body: reports.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, size: 80, color: colors.outline),
                        const SizedBox(height: 16),
                        Text(
                          l10n.sumHistoryEmpty,
                          textAlign: TextAlign.center,
                          style: context.text.bodyLarge
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: colors.primaryContainer,
                          child: Icon(Icons.assignment_outlined,
                              color: colors.onPrimaryContainer),
                        ),
                        title: Text(
                          formatDateTime(context, report.createdAt),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(l10n.sumHistoryCount(report.items.length)),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 16, color: colors.onSurfaceVariant),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SavedReportScreen(report: report),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

/// Ek saved summary dekhna, share karna, hatana
class SavedReportScreen extends StatelessWidget {
  final SavedReport report;
  SavedReportScreen({super.key, required this.report});

  final GlobalKey _paperKey = GlobalKey();

  Future<void> _share(BuildContext context) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final dateText = formatDateTime(context, report.createdAt);

    final mode = await pickShareMode(context);
    if (mode == null) return;

    final bool ok;
    if (mode == ShareMode.text) {
      ok = await shareReportText(
        buildReportText(
          l10n,
          dateText: dateText,
          patientName: report.patientName,
          age: report.age,
          gender: report.gender,
          items: report.items,
        ),
      );
    } else {
      ok = await shareReportImage(_paperKey);
    }
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.sumShareFailed)));
    }
  }

  Future<void> _delete(BuildContext context) async {
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.sumDeleteReportTitle),
        content: Text(l10n.sumDeleteReportBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.delete,
              style: TextStyle(color: dialogContext.colors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await SummaryStore.instance.deleteReport(report.id);
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sumReportTitle),
        actions: [
          IconButton(
            tooltip: l10n.sumShare,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _share(context),
          ),
          IconButton(
            tooltip: l10n.delete,
            icon: Icon(Icons.delete_outline, color: context.colors.error),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: RepaintBoundary(
          key: _paperKey,
          child: ReportPaper(
            items: report.items,
            patientName: report.patientName,
            age: report.age,
            gender: report.gender,
            createdAt: report.createdAt,
          ),
        ),
      ),
    );
  }
}