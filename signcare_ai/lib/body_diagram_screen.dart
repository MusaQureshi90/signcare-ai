import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'body_data.dart';
import 'consultation_manager.dart';
import 'l10n_ext.dart';
import 'scale_row.dart';
import 'summary_labels.dart';
import 'symptoms_data.dart';
import 'user_profile.dart';

/// m = -1 matlab shiddat nahi chuni
Color _markColor(int m, Color accent) =>
    m < 0 ? accent : Color.lerp(Colors.green, Colors.red, m / 10)!;

class BodyDiagramScreen extends StatefulWidget {
  const BodyDiagramScreen({super.key});

  @override
  State<BodyDiagramScreen> createState() => _BodyDiagramScreenState();
}

class _BodyDiagramScreenState extends State<BodyDiagramScreen> {
  final UserProfile _profile = UserProfile.instance;

  bool _back = false;
  bool _listMode = false;
  String? _modelChoice; // sirf "Other" gender ke liye
  String? _selectedId;
  final Map<String, int> _marked = {}; // hissa -> shiddat (-1 = nahi chuni)

  @override
  void initState() {
    super.initState();
    _profile.load();
  }

  bool get _needsChoice =>
      _profile.gender != 'Male' && _profile.gender != 'Female';

  String get _model {
    if (_profile.gender == 'Female') return 'female';
    if (_profile.gender == 'Male') return 'male';
    return _modelChoice ?? 'male';
  }

  Future<void> _openPart(BodyRegion r) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';

    setState(() => _selectedId = r.id);

    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PartSheet(region: r, model: _model, isUrdu: isUrdu),
    );

    if (!mounted) return;
    setState(() {
      _selectedId = null;
      if (result != null) _marked[r.id] = result;
    });
    if (result != null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.typeAdded)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';

    return ListenableBuilder(
      listenable: _profile,
      builder: (context, _) {
        final regions = buildRegions(_model, _back);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.bodyTitle),
            actions: [
              IconButton(
                tooltip:
                    _listMode ? l10n.bodyDiagramView : l10n.bodyListView,
                icon: Icon(
                    _listMode ? Icons.accessibility_new : Icons.view_list),
                onPressed: () => setState(() => _listMode = !_listMode),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<bool>(
                        segments: [
                          ButtonSegment<bool>(
                            value: false,
                            label: Text(l10n.bodyFront),
                            icon: const Icon(Icons.person),
                          ),
                          ButtonSegment<bool>(
                            value: true,
                            label: Text(l10n.bodyBack),
                            icon: const Icon(Icons.person_outline),
                          ),
                        ],
                        selected: {_back},
                        onSelectionChanged: (s) =>
                            setState(() => _back = s.first),
                      ),
                    ),
                    if (_needsChoice) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          l10n.bodyOtherHint,
                          style: context.text.bodySmall?.copyWith(
                              color: context.colors.onSurfaceVariant),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<String>(
                          segments: [
                            ButtonSegment<String>(
                              value: 'male',
                              label: Text(l10n.bodyMale),
                              icon: const Icon(Icons.male),
                            ),
                            ButtonSegment<String>(
                              value: 'female',
                              label: Text(l10n.bodyFemale),
                              icon: const Icon(Icons.female),
                            ),
                          ],
                          selected: {_model},
                          onSelectionChanged: (s) =>
                              setState(() => _modelChoice = s.first),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: _listMode
                    ? _buildList(context, regions, isUrdu)
                    : _buildDiagram(context, regions, isUrdu),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiagram(
      BuildContext context, List<BodyRegion> regions, bool isUrdu) {
    final l10n = context.l10n;
    final colors = context.colors;

    String? selectedLabel;
    for (final r in regions) {
      if (r.id == _selectedId) selectedLabel = regionLabel(r, isUrdu);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            selectedLabel ?? l10n.bodyTapHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: selectedLabel == null
                  ? colors.onSurfaceVariant
                  : colors.primary,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _BodyCanvas(
              regions: regions,
              marked: _marked,
              selectedId: _selectedId,
              back: _back,
              onTap: _openPart,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildList(
      BuildContext context, List<BodyRegion> regions, bool isUrdu) {
    final colors = context.colors;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: regions.length,
      itemBuilder: (context, i) {
        final r = regions[i];
        final m = _marked[r.id];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: m == null
                  ? colors.primaryContainer
                  : _markColor(m, colors.primary),
              child: Icon(
                m == null ? Icons.accessibility_new : Icons.check,
                color: m == null ? colors.onPrimaryContainer : Colors.white,
              ),
            ),
            title: Text(
              regionLabel(r, isUrdu),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openPart(r),
          ),
        );
      },
    );
  }
}

// =====================================================================
// Diagram banane aur dabane wala hissa
// =====================================================================
class _BodyCanvas extends StatelessWidget {
  final List<BodyRegion> regions;
  final Map<String, int> marked;
  final String? selectedId;
  final bool back;
  final ValueChanged<BodyRegion> onTap;

  const _BodyCanvas({
    required this.regions,
    required this.marked,
    required this.selectedId,
    required this.back,
    required this.onTap,
  });

  BodyRegion? _hit(Offset p) {
    for (final r in regions) {
      if (r.path.contains(p)) return r;
    }
    // Ungli thodi door lagi ho to sabse qareeb hissa chun lo
    BodyRegion? best;
    double bestDist = double.infinity;
    for (final r in regions) {
      final b = r.path.getBounds().inflate(8);
      if (!b.contains(p)) continue;
      final d = (b.center - p).distance;
      if (d < bestDist) {
        bestDist = d;
        best = r;
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, box) {
        final scale = math.min(box.maxWidth / 200, box.maxHeight / 440);
        final offset = Offset(
          (box.maxWidth - 200 * scale) / 2,
          (box.maxHeight - 440 * scale) / 2,
        );

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) {
            final p = (details.localPosition - offset) / scale;
            final hit = _hit(p);
            if (hit != null) onTap(hit);
          },
          child: CustomPaint(
            size: Size(box.maxWidth, box.maxHeight),
            painter: _BodyPainter(
              regions: regions,
              marked: marked,
              selectedId: selectedId,
              back: back,
              fill: colors.primaryContainer,
              outline: colors.primary,
              accent: colors.primary,
            ),
          ),
        );
      },
    );
  }
}

class _BodyPainter extends CustomPainter {
  final List<BodyRegion> regions;
  final Map<String, int> marked;
  final String? selectedId;
  final bool back;
  final Color fill;
  final Color outline;
  final Color accent;

  _BodyPainter({
    required this.regions,
    required this.marked,
    required this.selectedId,
    required this.back,
    required this.fill,
    required this.outline,
    required this.accent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 200, size.height / 440);
    canvas.translate(
      (size.width - 200 * scale) / 2,
      (size.height - 440 * scale) / 2,
    );
    canvas.scale(scale);

    for (final r in regions) {
      final m = marked[r.id];
      final selected = r.id == selectedId;

      Color color = fill;
      if (m != null) color = _markColor(m, accent).withAlpha(210);
      if (selected) color = accent.withAlpha(170);

      canvas.drawPath(
        r.path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = color,
      );
      canvas.drawPath(
        r.path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 3 : 1.5
          ..color = selected ? accent : outline,
      );
    }

    // Saadi nishaniyan: samne se aankhen aur naaf, pichay se reerh ki lakeer
    final dot = Paint()..color = outline;
    if (back) {
      canvas.drawLine(
        const Offset(100, 84),
        const Offset(100, 188),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = outline.withAlpha(140),
      );
    } else {
      canvas.drawCircle(const Offset(92, 32), 2, dot);
      canvas.drawCircle(const Offset(108, 32), 2, dot);
      canvas.drawCircle(const Offset(100, 168), 2.2, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _BodyPainter oldDelegate) => true;
}

// =====================================================================
// Neeche se khulne wali sheet: kya mehsoos ho raha hai, shiddat, kab se
// =====================================================================
class _PartSheet extends StatefulWidget {
  final BodyRegion region;
  final String model;
  final bool isUrdu;

  const _PartSheet({
    required this.region,
    required this.model,
    required this.isUrdu,
  });

  @override
  State<_PartSheet> createState() => _PartSheetState();
}

class _PartSheetState extends State<_PartSheet> {
  final Set<String> _subs = {};
  int? _intensity;
  String? _durationId;

  List<SubPart> get _options => subsFor(widget.region.part, widget.model);

  DurationOption? get _duration {
    final id = _durationId;
    if (id == null) return null;
    return durationOptions.firstWhere((o) => o.id == id);
  }

  List<String> _lines(String sep) {
    final isUrdu = widget.isUrdu;
    final label = regionLabel(widget.region, isUrdu);
    final dur = _duration;
    final out = <String>[];

    for (final o in _options) {
      if (!_subs.contains(o.id)) continue;
      final parts = <String>['$label: ${o.text(isUrdu)}'];
      if (_intensity != null) {
        parts.add(isUrdu
            ? 'شدت: 10 میں سے $_intensity'
            : 'severity $_intensity out of 10');
      }
      if (dur != null) {
        parts.add(isUrdu ? 'شروع ہوا: ${dur.ur}' : 'started ${dur.en}');
      }
      out.add(parts.join(sep));
    }
    return out;
  }

  void _speak() {
    final text = _lines(', ').join('. ');
    if (text.isEmpty) return;
    speakItem(context, text);
  }

  void _save() {
    for (final line in _lines(' — ')) {
      ConsultationManager.addItem('Body & Pain', line);
    }
    Navigator.pop(context, _intensity ?? -1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isUrdu = widget.isUrdu;

    String severity(int v) {
      if (v <= 3) return l10n.symMild;
      if (v <= 6) return l10n.symModerate;
      if (v <= 9) return l10n.symSevere;
      return l10n.symWorst;
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                regionLabel(widget.region, isUrdu),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(l10n.bodyWhatFeel,
                  style: context.text.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final o in _options)
                    FilterChip(
                      label: Text(o.text(isUrdu)),
                      selected: _subs.contains(o.id),
                      onSelected: (on) => setState(() {
                        if (on) {
                          _subs.add(o.id);
                        } else {
                          _subs.remove(o.id);
                        }
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(l10n.symHowStrong,
                  style: context.text.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant)),
              const SizedBox(height: 8),
              ScaleRow(
                value: _intensity,
                onChanged: (v) => setState(() => _intensity = v),
              ),
              if (_intensity != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    severity(_intensity!),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          Color.lerp(Colors.green, Colors.red, _intensity! / 10),
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              Text(l10n.symWhenStart,
                  style: context.text.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final d in durationOptions)
                    ChoiceChip(
                      label: Text(capitalize(d.text(isUrdu))),
                      selected: _durationId == d.id,
                      onSelected: (on) =>
                          setState(() => _durationId = on ? d.id : null),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _subs.isEmpty ? null : _speak,
                    icon: const Icon(Icons.volume_up),
                    label: Text(l10n.typeSpeak),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _subs.isEmpty ? null : _save,
                      icon: const Icon(Icons.assignment_add),
                      label: Text(l10n.cardsAddSummary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}