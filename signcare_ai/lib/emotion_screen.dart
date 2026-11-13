import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'cards_store.dart';
import 'consultation_manager.dart';
import 'l10n_ext.dart';
import 'summary_labels.dart';

class _Emotion {
  final String id;
  final String emoji;
  final String labelEn;
  final String labelUr;
  final String sentenceEn;
  final String sentenceUr;
  const _Emotion(
    this.id,
    this.emoji,
    this.labelEn,
    this.labelUr,
    this.sentenceEn,
    this.sentenceUr,
  );

  String label(bool isUrdu) => isUrdu ? labelUr : labelEn;
  String sentence(bool isUrdu) => isUrdu ? sentenceUr : sentenceEn;
}

const List<_Emotion> _emotions = [
  _Emotion('happy', '😊', 'Happy', 'خوش', 'I feel happy', 'میں خوش ہوں'),
  _Emotion('calm', '😌', 'Calm', 'پرسکون', 'I feel calm', 'میں پرسکون ہوں'),
  _Emotion('sad', '😢', 'Sad', 'اداس', 'I feel sad', 'میں اداس ہوں'),
  _Emotion(
    'anxious',
    '😟',
    'Anxious',
    'گھبراہٹ',
    'I feel anxious',
    'مجھے گھبراہٹ ہو رہی ہے',
  ),
  _Emotion('angry', '😠', 'Angry', 'غصہ', 'I feel angry', 'مجھے غصہ آ رہا ہے'),
  _Emotion(
    'frustrated',
    '😤',
    'Frustrated',
    'جھنجھلاہٹ',
    'I feel frustrated',
    'مجھے جھنجھلاہٹ ہو رہی ہے',
  ),
  _Emotion(
    'tired',
    '😴',
    'Tired',
    'تھکن',
    'I feel tired',
    'مجھے تھکن محسوس ہو رہی ہے',
  ),
  _Emotion(
    'scared',
    '😨',
    'Scared',
    'ڈر',
    'I feel scared',
    'مجھے ڈر لگ رہا ہے',
  ),
  _Emotion(
    'lonely',
    '🥺',
    'Lonely',
    'تنہائی',
    'I feel lonely',
    'مجھے تنہائی محسوس ہو رہی ہے',
  ),
  _Emotion(
    'confused',
    '😕',
    'Confused',
    'الجھن',
    'I feel confused',
    'مجھے الجھن ہو رہی ہے',
  ),
  _Emotion(
    'worried',
    '🏥',
    'Health worry',
    'صحت کی فکر',
    'I am worried about my health',
    'مجھے اپنی صحت کی فکر ہے',
  ),
  _Emotion(
    'talk',
    '🤗',
    'Need to talk',
    'بات کرنی ہے',
    'I need someone to talk to',
    'مجھے کسی سے بات کرنی ہے',
  ),
];

class _Level {
  final String en;
  final String ur;
  const _Level(this.en, this.ur);
  String text(bool isUrdu) => isUrdu ? ur : en;
}

const List<_Level> _levels = [
  _Level('a little', 'تھوڑا'),
  _Level('quite a bit', 'کافی'),
  _Level('very much', 'بہت زیادہ'),
];

class EmotionScreen extends StatefulWidget {
  const EmotionScreen({super.key});

  @override
  State<EmotionScreen> createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  final CardsStore _settings = CardsStore.instance;
  _Emotion? _selected;
  int? _level;

  @override
  void initState() {
    super.initState();
    _settings.ensureLoaded();
  }

  String _fullText(bool isUrdu) {
    final e = _selected!;
    final base = e.sentence(isUrdu);
    if (_level == null) return base;
    return '$base, ${_levels[_level!].text(isUrdu)}';
  }

  void _onTap(_Emotion e, bool isUrdu) {
    HapticFeedback.lightImpact();
    setState(() {
      _selected = e;
      _level = null;
    });
    if (_settings.speakOnTap) speakItem(context, e.sentence(isUrdu));
  }

  void _add(bool isUrdu) {
    final l10n = context.l10n;
    ConsultationManager.addItem('Emotions', _fullText(isUrdu));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.typeAdded)));
  }

  Future<void> _toggleSpeak() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final next = !_settings.speakOnTap;
    await _settings.setSpeakOnTap(next);
    messenger.showSnackBar(
      SnackBar(content: Text(next ? l10n.cardsSpeakOn : l10n.cardsSpeakOff)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';

    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.emoTitle),
            actions: [
              IconButton(
                tooltip: l10n.cardsSpeakTooltip,
                icon: Icon(
                  _settings.speakOnTap ? Icons.volume_up : Icons.volume_off,
                ),
                onPressed: _toggleSpeak,
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  l10n.emoQuestion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 180,
                    mainAxisExtent: 128,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _emotions.length,
                  itemBuilder: (context, i) =>
                      _buildCard(context, _emotions[i], isUrdu),
                ),
              ),
              if (_selected != null) _buildPanel(context, isUrdu),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, _Emotion e, bool isUrdu) {
    final colors = context.colors;
    final selected = _selected?.id == e.id;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: selected ? colors.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? colors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _onTap(e, isUrdu),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child: Column(
            children: [
              Text(e.emoji, style: const TextStyle(fontSize: 44)),
              const SizedBox(height: 4),
              Expanded(
                child: Center(
                  child: Text(
                    e.label(isUrdu),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: selected ? colors.onPrimaryContainer : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanel(BuildContext context, bool isUrdu) {
    final l10n = context.l10n;
    final colors = context.colors;
    final e = _selected!;

    return Material(
      color: colors.surfaceContainerHighest,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 4, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(e.emoji, style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _fullText(isUrdu),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() {
                      _selected = null;
                      _level = null;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.emoHowMuch,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: [
                        for (int i = 0; i < _levels.length; i++)
                          ChoiceChip(
                            label: Text(_levels[i].text(isUrdu)),
                            selected: _level == i,
                            onSelected: (on) =>
                                setState(() => _level = on ? i : null),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.typeSpeak,
                    icon: Icon(Icons.volume_up, color: colors.primary),
                    onPressed: () => speakItem(context, _fullText(isUrdu)),
                  ),
                  IconButton(
                    tooltip: l10n.cardsAddSummary,
                    icon: Icon(Icons.assignment_add, color: colors.primary),
                    onPressed: () => _add(isUrdu),
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
