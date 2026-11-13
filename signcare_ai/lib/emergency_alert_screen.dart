import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'emergency_contacts_store.dart';
import 'l10n_ext.dart';
import 'phone_actions.dart';
import 'tts_service.dart';
import 'user_profile.dart';

const String _fallbackEnglish =
    'I need urgent medical help. I cannot speak. Please help me.';

/// Poori screen laal, chamakti hai, bolti hai. Roknay ka button neeche hai.
class EmergencyAlertScreen extends StatefulWidget {
  const EmergencyAlertScreen({super.key});

  @override
  State<EmergencyAlertScreen> createState() => _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState extends State<EmergencyAlertScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..repeat(reverse: true);

  Timer? _speechTimer;
  Timer? _hapticTimer;
  String _speech = '';

  @override
  void initState() {
    super.initState();
    EmergencyContactsStore.instance.ensureLoaded();
    UserProfile.instance.load();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    if (!mounted) return;
    final l10n = context.l10n;
    final female = UserProfile.instance.gender == 'Female';
    _speech = female ? l10n.emAlertSpeechFemale : l10n.emAlertSpeech;

    _speak();
    _speechTimer =
        Timer.periodic(const Duration(seconds: 6), (_) => _speak());
    _hapticTimer = Timer.periodic(
      const Duration(milliseconds: 1000),
      (_) => HapticFeedback.heavyImpact(),
    );
  }

  Future<void> _speak() async {
    final result = await TtsService.instance.speak(_speech);
    // Urdu voice phone mein na ho to English mein bol do
    if (result == SpeakResult.languageMissing) {
      await TtsService.instance.speak(_fallbackEnglish);
    }
  }

  Future<void> _call(String number) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await openDialer(number);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.emCallFailed)));
    }
  }

  @override
  void dispose() {
    _speechTimer?.cancel();
    _hapticTimer?.cancel();
    _blink.dispose();
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = UserProfile.instance;
    final store = EmergencyContactsStore.instance;
    final female = profile.gender == 'Female';

    // Emergency screen ke rang hamesha laal/safed (theme se alag, jaan boojh kar)
    const Color alertDark = Color(0xFFB71C1C);
    const Color alertLight = Color(0xFFFF1744);

    final content = SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ListenableBuilder(
            listenable: Listenable.merge([store, profile]),
            builder: (context, _) {
              final contacts = store.contacts.take(2).toList();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 96, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    l10n.emAlertHeadline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    female ? l10n.emAlertSubFemale : l10n.emAlertSub,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  if (profile.name.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: alertDark,
                    ),
                    onPressed: () => _call('1122'),
                    icon: const Icon(Icons.call),
                    label: Text(l10n.emCallRescue),
                  ),
                  for (final c in contacts) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: alertDark,
                      ),
                      onPressed: () => _call(c.number),
                      icon: const Icon(Icons.call),
                      label: Text(c.name, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: Text(l10n.emStopAlert),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _blink,
      child: content,
      builder: (context, child) {
        final bg = Color.lerp(alertDark, alertLight, _blink.value)!;
        return Scaffold(backgroundColor: bg, body: child);
      },
    );
  }
}