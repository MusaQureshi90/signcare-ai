import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n_ext.dart';

/// Year / Month / Day dropdown wala calendar.
/// Tareekh milti hai (DateTime) ya cancel par null.
Future<DateTime?> showDobPicker(BuildContext context, {DateTime? initial}) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) => _DobDialog(initial: initial),
  );
}

class _DobDialog extends StatefulWidget {
  final DateTime? initial;
  const _DobDialog({this.initial});

  @override
  State<_DobDialog> createState() => _DobDialogState();
}

class _DobDialogState extends State<_DobDialog> {
  final DateTime _now = DateTime.now();
  late int _year;
  late int _month;
  late int _day;

  @override
  void initState() {
    super.initState();
    final base = widget.initial ?? DateTime(_now.year - 20, 1, 1);
    _year = base.year;
    _month = base.month;
    _day = base.day;
    _fix();
  }

  int get _maxMonth => _year == _now.year ? _now.month : 12;

  int get _maxDay {
    final daysInMonth = DateUtils.getDaysInMonth(_year, _month);
    if (_year == _now.year && _month == _now.month) {
      return daysInMonth < _now.day ? daysInMonth : _now.day;
    }
    return daysInMonth;
  }

  /// Month/day ko valid range mein rakhta hai (jaise 31 Feb nahi ho sakti)
  void _fix() {
    if (_month > _maxMonth) _month = _maxMonth;
    if (_day > _maxDay) _day = _maxDay;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;

    final years = [for (int y = _now.year; y >= _now.year - 110; y--) y];
    final months = [for (int m = 1; m <= _maxMonth; m++) m];
    final days = [for (int d = 1; d <= _maxDay; d++) d];

    return AlertDialog(
      title: Text(l10n.dobDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row(
              label: l10n.dobYear,
              child: DropdownButton<int>(
                isExpanded: true,
                value: _year,
                items: [
                  for (final y in years)
                    DropdownMenuItem(value: y, child: Text('$y')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _year = v;
                    _fix();
                  });
                },
              ),
            ),
            _row(
              label: l10n.dobMonth,
              child: DropdownButton<int>(
                isExpanded: true,
                value: _month,
                items: [
                  for (final m in months)
                    DropdownMenuItem(
                      value: m,
                      child: Text(
                        DateFormat.MMMM(languageCode)
                            .format(DateTime(2000, m, 1)),
                      ),
                    ),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _month = v;
                    _fix();
                  });
                },
              ),
            ),
            _row(
              label: l10n.dobDay,
              child: DropdownButton<int>(
                isExpanded: true,
                value: _day,
                items: [
                  for (final d in days)
                    DropdownMenuItem(value: d, child: Text('$d')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _day = v);
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () =>
              Navigator.pop(context, DateTime(_year, _month, _day)),
          child: Text(l10n.dobConfirm),
        ),
      ],
    );
  }

  Widget _row({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}