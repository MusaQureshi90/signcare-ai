import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_settings.dart';
import 'app_theme.dart';
import 'l10n_ext.dart';
import 'user_profile.dart';
import 'common_needs_screen.dart';
import 'custom_message_screen.dart';
import 'symptoms_screen.dart';
import 'emotion_screen.dart';
import 'consultation_summary_screen.dart';
import 'emergency_screen.dart';
import 'speech_to_text_screen.dart';
import 'body_diagram_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  // Purani screens (splash / login / otp) ye dono abhi bhi bhejti hain.
  // Ab inki zarurat nahi (AppSettings khud sambhalti hai), isliye optional hain.
  final Function(Locale, String)? onLocaleChange;
  final String? currentLang;

  const HomeScreen({
    super.key,
    required this.userName,
    this.onLocaleChange,
    this.currentLang,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Login ke baad is user ka profile load karo
    UserProfile.instance.load();
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.instance;
    final profile = UserProfile.instance;

    // Settings ya profile badle to Home khud update ho jaye
    return ListenableBuilder(
      listenable: Listenable.merge([settings, profile]),
      builder: (context, _) {
        final l10n = context.l10n;
        final colors = context.colors;
        final items = _menuItems(context);
        final bool isGrid = settings.homeLayout == 'Grid';
        final String displayName =
            profile.name.isNotEmpty ? profile.name : widget.userName;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _confirmExit(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  Text(
                    l10n.welcomeUser(displayName),
                    style: context.text.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
              actions: [
                
                IconButton(
                  tooltip: l10n.settings,
                  icon: Icon(Icons.settings, color: colors.primary),
                  onPressed: () => _open(context, const SettingsScreen()),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.helloUser(displayName),
                    style: context.text.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeSubtitle,
                    style: context.text.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: isGrid
                        ? _buildGrid(context, items)
                        : _buildList(context, items),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- Menu ki list ----------------
  List<_MenuItem> _menuItems(BuildContext context) {
    final l10n = context.l10n;
    return [
      _MenuItem(
        title: l10n.menuCardsTitle,
        subtitle: l10n.menuCardsSubtitle,
        icon: Icons.note_add_outlined,
        color: Colors.teal,
        screen: const CommonNeedsScreen(),
      ),
      _MenuItem(
        title: l10n.menuTypeTitle,
        subtitle: l10n.menuTypeSubtitle,
        icon: Icons.keyboard_outlined,
        color: Colors.blue,
        screen: const CustomMessageScreen(),
      ),
      _MenuItem(
        title: l10n.menuSymptomsTitle,
        subtitle: l10n.menuSymptomsSubtitle,
        icon: Icons.sick_outlined,
        color: Colors.orange,
        screen: const SymptomsScreen(),
      ),
      _MenuItem(
        title: l10n.menuEmotionsTitle,
        subtitle: l10n.menuEmotionsSubtitle,
        icon: Icons.sentiment_satisfied_alt,
        color: Colors.purple,
        screen: const EmotionScreen(),
      ),
      _MenuItem(
        title: l10n.menuSummaryTitle,
        subtitle: l10n.menuSummarySubtitle,
        icon: Icons.assignment_outlined,
        color: Colors.green,
        screen: const ConsultationSummaryScreen(),
      ),
      _MenuItem(
        title: l10n.menuEmergencyTitle,
        subtitle: l10n.menuEmergencySubtitle,
        icon: Icons.warning_amber_rounded,
        color: Colors.red,
        screen: const EmergencyScreen(),
      ),
      _MenuItem(
        title: l10n.menuSpeechTitle,
        subtitle: l10n.menuSpeechSubtitle,
        icon: Icons.mic,
        color: Colors.cyan,
        screen: const SpeechToTextScreen(),
      ),
      _MenuItem(
        title: l10n.menuBodyTitle,
        subtitle: l10n.menuBodySubtitle,
        icon: Icons.accessibility_new,
        color: Colors.pink,
        screen: const BodyDiagramScreen(),
      ),
    ];
  }

  // ---------------- List layout ----------------
  Widget _buildList(BuildContext context, List<_MenuItem> items) {
    final colors = context.colors;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: item.color.withAlpha(35),
              child: Icon(item.icon, color: item.color),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              item.subtitle,
              style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colors.onSurfaceVariant,
            ),
            onTap: () => _open(context, item.screen),
          ),
        );
      },
    );
  }

  // ---------------- Grid layout ----------------
  Widget _buildGrid(BuildContext context, List<_MenuItem> items) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _open(context, item.screen),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: item.color.withAlpha(35),
                    child: Icon(item.icon, color: item.color, size: 26),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- Actions ----------------
  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _confirmExit(BuildContext context) async {
    final l10n = context.l10n;
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.exitTitle),
        content: Text(l10n.exitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.exitAction,
              style: TextStyle(color: dialogContext.colors.error),
            ),
          ),
        ],
      ),
    );
    if (shouldExit == true) {
      await SystemNavigator.pop();
    }
  }
}

class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  const _MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}