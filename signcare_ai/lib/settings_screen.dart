import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';
import 'app_settings.dart';
import 'app_theme.dart';
import 'consultation_manager.dart';
import 'l10n_ext.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

const String _supportEmail = 'aiisshaaa24@gmail.com';
const String _portfolioUrl = 'https://musaqureshi.pythonanywhere.com';

// pubspec.yaml ke version se match rakho. Baad mein package_info_plus lagayenge.
const String _appVersion = '1.0.0 (1)';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.instance;

    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        final l10n = context.l10n;
        final colors = context.colors;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.settings)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
                            // ---------------- Profile ----------------
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_outline, color: colors.primary),
                  title: Text(
                    l10n.profileTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(l10n.profileEditHint),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colors.onSurfaceVariant,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                ),
              ),
              // ---------------- Language ----------------
              _SectionTitle(l10n.setLanguageSection),
              Card(
                child: Column(
                  children: [
                    _ChoiceTile(
                      title: 'English',
                      selected: !settings.isUrdu,
                      onTap: () => _changeLanguage('English'),
                    ),
                    const Divider(height: 1),
                    _ChoiceTile(
                      title: 'اردو',
                      selected: settings.isUrdu,
                      onTap: () => _changeLanguage('Urdu'),
                    ),
                  ],
                ),
              ),

              // ---------------- Appearance ----------------
              _SectionTitle(l10n.setAppearanceSection),
              Card(
                child: Column(
                  children: [
                    _ChoiceTile(
                      title: l10n.setThemeSystem,
                      selected: settings.themeMode == ThemeMode.system,
                      onTap: () => _changeTheme(ThemeMode.system),
                    ),
                    const Divider(height: 1),
                    _ChoiceTile(
                      title: l10n.setThemeLight,
                      selected: settings.themeMode == ThemeMode.light,
                      onTap: () => _changeTheme(ThemeMode.light),
                    ),
                    const Divider(height: 1),
                    _ChoiceTile(
                      title: l10n.setThemeDark,
                      selected: settings.themeMode == ThemeMode.dark,
                      onTap: () => _changeTheme(ThemeMode.dark),
                    ),
                  ],
                ),
              ),

              // ---------------- Home layout ----------------
              _SectionTitle(l10n.setLayoutSection),
              Card(
                child: Column(
                  children: [
                    _ChoiceTile(
                      title: l10n.setLayoutList,
                      selected: settings.homeLayout == 'List',
                      onTap: () => _changeLayout('List'),
                    ),
                    const Divider(height: 1),
                    _ChoiceTile(
                      title: l10n.setLayoutGrid,
                      selected: settings.homeLayout == 'Grid',
                      onTap: () => _changeLayout('Grid'),
                    ),
                  ],
                ),
              ),

              // ---------------- Account ----------------
              _SectionTitle(l10n.setAccountSection),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.orange),
                      title: Text(
                        l10n.setLogout,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(l10n.setLogoutSubtitle),
                      onTap: () => _confirmLogout(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.delete_forever, color: colors.error),
                      title: Text(
                        l10n.setDeleteAccount,
                        style: TextStyle(
                          color: colors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(l10n.setDeleteSubtitle),
                      onTap: () => _confirmDelete(context),
                    ),
                  ],
                ),
              ),

              // ---------------- About & support ----------------
              _SectionTitle(l10n.setAboutSection),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.email_outlined, color: colors.primary),
                      title: Text(l10n.setContactTitle),
                      subtitle: const Text(_supportEmail),
                      onTap: () => _showContactDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.language, color: colors.primary),
                      title: Text(l10n.setPortfolioTitle),
                      subtitle: const Text(''),
                      onTap: () => _showPortfolioDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.info_outline, color: colors.primary),
                      title: Text(l10n.setVersion),
                      subtitle: const Text(_appVersion),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                color: colors.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.health_and_safety_outlined,
                          color: colors.onPrimaryContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.setNoteTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.setNoteBody,
                              style: TextStyle(
                                color: colors.onPrimaryContainer,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // ---------------- Badlav (turant apply) ----------------
  Future<void> _changeLanguage(String name) async {
    await AppSettings.instance.setLanguageName(name);
    unawaited(_syncToBackend());
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    await AppSettings.instance.setThemeMode(mode);
    unawaited(_syncToBackend());
  }

  Future<void> _changeLayout(String layout) async {
    await AppSettings.instance.setHomeLayout(layout);
    unawaited(_syncToBackend());
  }

  static String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }

  /// Server par settings bhejta hai. Server ka purana data khali string se
  /// overwrite NAHI hone deta (doosre device wala bug).
  Future<void> _syncToBackend() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('logged_phone') ?? '';
    if (phone.isEmpty) return;

    // Server se parh ne mein fail ho to sync mat karo (warna khali data likh dega)
    final server = await ApiService.getPreferences(phone);
    if (server == null) return;

    Future<String> pick(String localKey, String serverKey) async {
      final local = prefs.getString(localKey) ?? '';
      if (local.isNotEmpty) return local;
      final fromServer = server[serverKey]?.toString() ?? '';
      if (fromServer.isNotEmpty) {
        await prefs.setString(localKey, fromServer); // is device pe bhi save
      }
      return fromServer;
    }

    final settings = AppSettings.instance;
    await ApiService.savePreferences(
      phone,
      await pick('reg_name_$phone', 'name'),
      await pick('reg_age_$phone', 'age'),
      await pick('reg_gender_$phone', 'gender'),
      await pick('reg_pass_$phone', 'password'),
      settings.languageName,
      _themeName(settings.themeMode),
      settings.homeLayout,
    );
  }

  // ---------------- Logout ----------------
  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = context.l10n;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.setLogoutConfirmTitle),
        content: Text(l10n.setLogoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.setLogout,
              style: TextStyle(color: dialogContext.colors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('logged_phone');
    await prefs.remove('logged_name');
    ConsultationManager.clear(); // agla user pichle ka data na dekhe

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // ---------------- Delete (sirf is device ka data) ----------------
  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.setDeleteConfirmTitle),
        content: Text(l10n.setDeleteConfirmMessage),
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
    if (confirmed != true) return;

    final prefs = await SharedPreferences.getInstance();
    // Language / theme / layout bacha ke baqi sab user data hata do
    const keep = {'app_language', 'app_theme', 'home_layout'};
    for (final key in prefs.getKeys().toList()) {
      if (!keep.contains(key)) {
        await prefs.remove(key);
      }
    }
    ConsultationManager.clear();

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // ---------------- Contact dialog ----------------
  void _showContactDialog(BuildContext context) {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.setContactTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.setContactMessage),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: dialogContext.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SelectableText(
                _supportEmail,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.close),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await Clipboard.setData(const ClipboardData(text: _supportEmail));
              if (dialogContext.mounted) Navigator.pop(dialogContext);
              messenger.showSnackBar(
                SnackBar(content: Text(l10n.setEmailCopied)),
              );
            },
            icon: const Icon(Icons.copy, size: 18),
            label: Text(l10n.setCopyEmail),
          ),
        ],
      ),
    );
  }

  // ---------------- Portfolio dialog ----------------
  void _showPortfolioDialog(BuildContext context) {
    final l10n = context.l10n;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.setPortfolioTitle),
        content: Text(l10n.setPortfolioMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final uri = Uri.parse(_portfolioUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.open_in_new, size: 18),
            label: Text(l10n.setVisitWebsite),
          ),
        ],
      ),
    );
  }
}

/// Section ka heading (Language, Appearance, ...)
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4, top: 20, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: context.colors.primary,
        ),
      ),
    );
  }
}

/// Ek option jo select ho sakta hai (tick ke saath)
class _ChoiceTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      selected: selected,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Icon(
        selected ? Icons.check_circle : Icons.radio_button_unchecked,
        color: selected ? colors.primary : colors.outline,
      ),
      onTap: onTap,
    );
  }
}