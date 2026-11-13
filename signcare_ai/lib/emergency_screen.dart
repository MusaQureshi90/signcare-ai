import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'emergency_alert_screen.dart';
import 'emergency_contacts_store.dart';
import 'l10n_ext.dart';
import 'phone_actions.dart';
import 'summary_labels.dart';
import 'summary_store.dart';
import 'user_profile.dart';

class _Phrase {
  final String en;
  final String ur;
  final IconData icon;
  const _Phrase(this.en, this.ur, this.icon);
}

const List<_Phrase> _phrases = [
  _Phrase('I need an ambulance', 'مجھے ایمبولینس چاہیے', Icons.local_hospital),
  _Phrase('I cannot breathe', 'مجھے سانس لینے میں دشواری ہو رہی ہے', Icons.air),
  _Phrase(
    'I have severe chest pain',
    'مجھے سینے میں شدید درد ہے',
    Icons.favorite_border,
  ),
  _Phrase(
    'I am bleeding badly',
    'میرا بہت خون بہہ رہا ہے',
    Icons.water_drop_outlined,
  ),
  _Phrase('I feel very dizzy', 'مجھے شدید چکر آ رہے ہیں', Icons.rotate_right),
  _Phrase('I am having a seizure', 'مجھے دورہ پڑ رہا ہے', Icons.bolt),
  _Phrase(
    'I am having a severe allergic reaction',
    'مجھے شدید الرجی کا ردعمل ہو رہا ہے',
    Icons.warning_amber_rounded,
  ),
  _Phrase(
    'Please call my family',
    'براہ کرم میرے گھر والوں کو فون کریں',
    Icons.family_restroom,
  ),
];

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final EmergencyContactsStore _store = EmergencyContactsStore.instance;
  final UserProfile _profile = UserProfile.instance;

  @override
  void initState() {
    super.initState();
    _store.ensureLoaded();
    _profile.load();
  }

  // ---------------- Actions ----------------
  Future<void> _call(String number) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await openDialer(number);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.emCallFailed)));
    }
  }

  String _alertBody() {
    final l10n = context.l10n;
    final name = _profile.name;
    return name.isEmpty ? l10n.emSmsBodyNoName : l10n.emSmsBody(name);
  }

  Future<void> _sms(EmergencyContact contact) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await openSms(contact.number, _alertBody());
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.emAppFailed)));
    }
  }

  Future<void> _whatsapp(EmergencyContact contact) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await openWhatsApp(contact.number, _alertBody());
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.emAppFailed)));
    }
  }

  Future<void> _editContact([EmergencyContact? existing]) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    if (existing == null &&
        _store.contacts.length >= EmergencyContactsStore.maxContacts) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.emMaxContacts)));
      return;
    }

    final result = await showDialog<_ContactInput>(
      context: context,
      builder: (_) => _ContactDialog(initial: existing),
    );
    if (result == null) return;

    if (existing == null) {
      await _store.add(result.name, result.number, result.relation);
    } else {
      await _store.update(
        EmergencyContact(
          id: existing.id,
          name: result.name.trim(),
          number: result.number.trim(),
          relation: result.relation.trim(),
        ),
      );
    }
  }

  Future<void> _confirmDelete(EmergencyContact contact) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.emDeleteContactTitle),
        content: Text(l10n.emDeleteContactBody(contact.name)),
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
    if (confirmed == true) await _store.remove(contact.id);
  }

  Future<void> _addPhraseToSummary(String text) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    await SummaryStore.instance.add(SummaryCategory.emergency, text);
    messenger.showSnackBar(SnackBar(content: Text(l10n.typeAdded)));
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isUrdu = Localizations.localeOf(context).languageCode == 'ur';

    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final contacts = _store.contacts;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.emTitle)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---------- Bada help button ----------
              Material(
                color: colors.error,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmergencyAlertScreen(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 48,
                          color: colors.onError,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.emHelpButton,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onError,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.emHelpHint,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colors.onError,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: colors.onError,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ---------- Meri contacts ----------
              _SectionHeader(
                title: l10n.emContactsSection,
                trailing: TextButton.icon(
                  onPressed: () => _editContact(),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text(l10n.emAddContact),
                ),
              ),
              if (contacts.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      l10n.emNoContacts,
                      style: context.text.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                for (final c in contacts) _buildContactTile(context, c),

              // ---------- Emergency numbers ----------
              _SectionHeader(title: l10n.emNumbersSection),
              Row(
                children: [
                  Expanded(
                    child: _numberCard(
                      '1122',
                      l10n.emRescue,
                      Icons.local_hospital,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _numberCard(
                      '15',
                      l10n.emPolice,
                      Icons.local_police,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _numberCard(
                      '16',
                      l10n.emFire,
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.emNumbersNote,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              // ---------- Foran bolne wale jumle ----------
              _SectionHeader(title: l10n.emPhrasesSection),
              for (final p in _phrases)
                _buildPhraseTile(context, isUrdu ? p.ur : p.en, p.icon),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactTile(BuildContext context, EmergencyContact c) {
    final l10n = context.l10n;
    final colors = context.colors;
    final initial = c.name.isEmpty
        ? '?'
        : c.name.characters.first.toUpperCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Upar wala hissa: tap karne par seedha dialer
          InkWell(
            onTap: () => _call(c.number),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 4, 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colors.primaryContainer,
                    child: Text(
                      initial,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(c.number),
                        ),
                        if (c.relation.isNotEmpty)
                          Text(
                            c.relation,
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') _editContact(c);
                      if (value == 'delete') _confirmDelete(c);
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(l10n.emEdit),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Neeche: Call / SMS / WhatsApp
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: _actionButton(
                    Icons.call,
                    l10n.emCall,
                    Colors.green,
                    () => _call(c.number),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionButton(
                    Icons.sms_outlined,
                    l10n.emSms,
                    colors.primary,
                    () => _sms(c),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionButton(
                    Icons.chat_bubble_outline,
                    l10n.emWhatsApp,
                    const Color(0xFF25D366),
                    () => _whatsapp(c),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withAlpha(120)),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      ),
      icon: Icon(icon, size: 18),
      label: FittedBox(fit: BoxFit.scaleDown, child: Text(label)),
    );
  }

  Widget _numberCard(String number, String label, IconData icon, Color color) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _call(number),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withAlpha(40),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                number,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhraseTile(BuildContext context, String text, IconData icon) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => speakItem(context, text),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 4, 8),
          child: Row(
            children: [
              Icon(icon, color: colors.error),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.typeSpeak,
                icon: Icon(Icons.volume_up, color: colors.primary),
                onPressed: () => speakItem(context, text),
              ),
              IconButton(
                tooltip: l10n.emAddToSummary,
                icon: Icon(Icons.assignment_add, color: colors.primary),
                onPressed: () => _addPhraseToSummary(text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 24, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _ContactInput {
  final String name;
  final String number;
  final String relation;
  const _ContactInput(this.name, this.number, this.relation);
}

/// Contact add/edit ka dialog (controllers apne aap sambhalta hai)
class _ContactDialog extends StatefulWidget {
  final EmergencyContact? initial;
  const _ContactDialog({this.initial});

  @override
  State<_ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<_ContactDialog> {
  late final TextEditingController _name = TextEditingController(
    text: widget.initial?.name ?? '',
  );
  late final TextEditingController _number = TextEditingController(
    text: widget.initial?.number ?? '',
  );
  late final TextEditingController _relation = TextEditingController(
    text: widget.initial?.relation ?? '',
  );

  String? _nameError;
  String? _numberError;

  @override
  void dispose() {
    _name.dispose();
    _number.dispose();
    _relation.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = context.l10n;
    final nameOk = _name.text.trim().isNotEmpty;
    final numberOk = EmergencyContactsStore.isValidNumber(_number.text);
    if (!nameOk || !numberOk) {
      setState(() {
        _nameError = nameOk ? null : l10n.emNameError;
        _numberError = numberOk ? null : l10n.emPhoneError;
      });
      return;
    }
    Navigator.pop(
      context,
      _ContactInput(_name.text, _number.text, _relation.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.initial == null ? l10n.emAddTitle : l10n.emEditTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [LengthLimitingTextInputFormatter(40)],
              decoration: InputDecoration(
                labelText: l10n.emContactName,
                errorText: _nameError,
              ),
              onChanged: (_) => setState(() => _nameError = null),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _number,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
                LengthLimitingTextInputFormatter(20),
              ],
              decoration: InputDecoration(
                labelText: l10n.emContactPhone,
                errorText: _numberError,
              ),
              onChanged: (_) => setState(() => _numberError = null),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _relation,
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              decoration: InputDecoration(labelText: l10n.emContactRelation),
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
