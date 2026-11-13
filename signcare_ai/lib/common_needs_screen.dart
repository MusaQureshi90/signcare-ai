import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'cards_data.dart';
import 'cards_store.dart';
import 'l10n_ext.dart';
import 'summary_labels.dart';
import 'summary_store.dart';
import 'tts_service.dart';

const List<String> _emojiChoices = [
  '💬', '🙂', '🍽️', '💊', '🚻', '🛏️', '📞', '❤️', '🙏', '🏠', '📖', '🚗',
];

class CommonNeedsScreen extends StatefulWidget {
  const CommonNeedsScreen({super.key});

  @override
  State<CommonNeedsScreen> createState() => _CommonNeedsScreenState();
}

class _CommonNeedsScreenState extends State<CommonNeedsScreen> {
  final CardsStore _store = CardsStore.instance;
  final TextEditingController _search = TextEditingController();

  /// 'all', 'fav', 'recent', 'custom' ya category ka code
  String _filter = 'all';
  CardItem? _selected;

  @override
  void initState() {
    super.initState();
    _store.ensureLoaded();
  }

  @override
  void dispose() {
    _search.dispose();
    TtsService.instance.stop();
    super.dispose();
  }

  // ---------------- Data ----------------
  List<CardItem> _visible() {
    final all = <CardItem>[..._store.custom, ...builtInCards];
    final query = _search.text.trim().toLowerCase();

    // Search karte waqt filter ignore, sab cards mein dhoondo
    if (query.isNotEmpty) {
      return all
          .where((c) =>
              c.en.toLowerCase().contains(query) || c.ur.contains(query))
          .toList();
    }

    switch (_filter) {
      case 'all':
        return all;
      case 'fav':
        return all.where((c) => _store.isFavourite(c.id)).toList();
      case 'recent':
        final byId = {for (final c in all) c.id: c};
        return _store.recent
            .map((id) => byId[id])
            .whereType<CardItem>()
            .toList();
      case 'custom':
        return _store.custom;
      default:
        return all.where((c) => c.category == _filter).toList();
    }
  }

  // ---------------- Actions ----------------
  Future<void> _speak(String text) async {
    await TtsService.instance.stop();
    if (!mounted) return;
    await speakItem(context, text);
  }

  void _onTap(CardItem c, bool isUrdu) {
    HapticFeedback.lightImpact();
    setState(() => _selected = c);
    if (_filter != 'recent') unawaited(_store.markUsed(c.id));
    if (_store.speakOnTap) unawaited(_speak(c.text(isUrdu)));
  }

  Future<void> _addToSummary(CardItem c) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';
    await SummaryStore.instance.add(SummaryCategory.cards, c.text(isUrdu));
    messenger.showSnackBar(SnackBar(content: Text(l10n.typeAdded)));
  }

  Future<void> _toggleSpeak() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final next = !_store.speakOnTap;
    await _store.setSpeakOnTap(next);
    messenger.showSnackBar(
      SnackBar(content: Text(next ? l10n.cardsSpeakOn : l10n.cardsSpeakOff)),
    );
  }

  Future<void> _addOwn() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    if (_store.custom.length >= CardsStore.maxCustom) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.cardsMaxCustom)));
      return;
    }

    final result = await showDialog<_NewCard>(
      context: context,
      builder: (_) => const _CardDialog(),
    );
    if (result == null) return;

    await _store.addCustom(result.emoji, result.text);
    if (!mounted) return;
    setState(() {
      _search.clear();
      _filter = 'custom';
    });
  }

  Future<void> _confirmDelete(CardItem c) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cardsDeleteTitle),
        content: Text('${c.emoji}  ${c.en}'),
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
    if (ok != true || !mounted) return;
    if (_selected?.id == c.id) setState(() => _selected = null);
    await _store.remove(c.id);
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';

    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final visible = _visible();
        final searching = _search.text.trim().isNotEmpty;

        String emptyText;
        if (searching) {
          emptyText = l10n.cardsNoResults;
        } else if (_filter == 'fav') {
          emptyText = l10n.cardsEmptyFav;
        } else if (_filter == 'recent') {
          emptyText = l10n.cardsEmptyRecent;
        } else if (_filter == 'custom') {
          emptyText = l10n.cardsEmptyMine;
        } else {
          emptyText = l10n.cardsEmpty;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.cardsTitle),
            actions: [
              IconButton(
                tooltip: l10n.cardsAddOwn,
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _addOwn,
              ),
              IconButton(
                tooltip: l10n.cardsSpeakTooltip,
                icon: Icon(
                  _store.speakOnTap ? Icons.volume_up : Icons.volume_off,
                ),
                onPressed: _toggleSpeak,
              ),
            ],
          ),
          body: Column(
            children: [
              // ---------- Search ----------
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.cardsSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _search.clear();
                              setState(() {});
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),

              // ---------- Chips ----------
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    _chip('all', l10n.cardsAll),
                    _chip('fav', l10n.cardsFavourites),
                    _chip('recent', l10n.cardsRecent),
                    _chip('custom', l10n.cardsMine),
                    for (final cat in cardCategories)
                      _chip(cat.code, isUrdu ? cat.ur : cat.en),
                  ],
                ),
              ),

              if (_filter == 'custom' && !searching && visible.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Text(
                    l10n.cardsHoldHint,
                    style: context.text.bodySmall
                        ?.copyWith(color: context.colors.onSurfaceVariant),
                  ),
                ),

              // ---------- Grid ----------
              Expanded(
                child: visible.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            emptyText,
                            textAlign: TextAlign.center,
                            style: context.text.bodyLarge?.copyWith(
                                color: context.colors.onSurfaceVariant),
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisExtent: 168,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: visible.length,
                        itemBuilder: (context, i) =>
                            _buildCard(context, visible[i], isUrdu),
                      ),
              ),

              // ---------- Chuna hua card ----------
              if (_selected != null) _buildSelectedPanel(context, _selected!, isUrdu),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String code, String label) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _filter == code,
        onSelected: (_) => setState(() => _filter = code),
      ),
    );
  }

  Widget _buildCard(BuildContext context, CardItem c, bool isUrdu) {
    final l10n = context.l10n;
    final colors = context.colors;
    final selected = _selected?.id == c.id;
    final fav = _store.isFavourite(c.id);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? colors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: InkWell(
              onTap: () => _onTap(c, isUrdu),
              onLongPress: c.custom ? () => _confirmDelete(c) : null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
                child: Column(
                  children: [
                    Text(c.emoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Center(
                        child: Text(
                          c.text(isUrdu),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 0,
            end: 0,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: l10n.cardsFavourites,
              icon: Icon(
                fav ? Icons.star : Icons.star_border,
                color: fav ? Colors.amber : colors.onSurfaceVariant,
              ),
              onPressed: () => _store.toggleFavourite(c.id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPanel(BuildContext context, CardItem c, bool isUrdu) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = c.text(isUrdu);

    return Material(
      color: colors.surfaceContainerHighest,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 4, 8),
          child: Row(
            children: [
              Text(c.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                tooltip: l10n.typeSpeak,
                icon: Icon(Icons.volume_up, color: colors.primary),
                onPressed: () => _speak(text),
              ),
              IconButton(
                tooltip: l10n.cardsAddSummary,
                icon: Icon(Icons.assignment_add, color: colors.primary),
                onPressed: () => _addToSummary(c),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _selected = null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewCard {
  final String emoji;
  final String text;
  const _NewCard(this.emoji, this.text);
}

/// Apna card banane ka dialog
class _CardDialog extends StatefulWidget {
  const _CardDialog();

  @override
  State<_CardDialog> createState() => _CardDialogState();
}

class _CardDialogState extends State<_CardDialog> {
  final TextEditingController _text = TextEditingController();
  String _emoji = _emojiChoices.first;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _save() {
    final value = _text.text.trim();
    if (value.isEmpty) {
      setState(() => _error = context.l10n.cardsTextError);
      return;
    }
    Navigator.pop(context, _NewCard(_emoji, value));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.cardsNewTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _text,
              autofocus: true,
              maxLines: 2,
              inputFormatters: [LengthLimitingTextInputFormatter(80)],
              decoration: InputDecoration(
                labelText: l10n.cardsTextLabel,
                errorText: _error,
              ),
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: 16),
            Text(l10n.cardsPickEmoji, style: context.text.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in _emojiChoices)
                  ChoiceChip(
                    label: Text(e, style: const TextStyle(fontSize: 22)),
                    showCheckmark: false,
                    selected: _emoji == e,
                    onSelected: (_) => setState(() => _emoji = e),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}