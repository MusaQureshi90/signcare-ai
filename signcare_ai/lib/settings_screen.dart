import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_client.dart';
import 'app_settings.dart';
import 'app_theme.dart';
import 'auth_session.dart';
import 'auth_widgets.dart';
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
                      leading: Icon(Icons.lock_outline, color: colors.primary),
                      title: Text(
                        l10n.setChangePassword,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(l10n.setChangePasswordSubtitle),
                      onTap: () => _changePassword(context),
                    ),
                    const Divider(height: 1),
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
                      leading: Icon(
                        Icons.email_outlined,
                        color: colors.primary,
                      ),
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
                      Icon(
                        Icons.health_and_safety_outlined,
                        color: colors.onPrimaryContainer,
                      ),
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

  // ---------------- Badlav (phone par turant, server par background mein) ----------------
  Future<void> _changeLanguage(String name) async {
    await AppSettings.instance.setLanguageName(name);
    unawaited(AuthSession.instance.syncSettings());
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    await AppSettings.instance.setThemeMode(mode);
    unawaited(AuthSession.instance.syncSettings());
  }

  Future<void> _changeLayout(String layout) async {
    await AppSettings.instance.setHomeLayout(layout);
    unawaited(AuthSession.instance.syncSettings());
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

    await AuthSession.instance.logout();

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // ---------------- Change password ----------------
  Future<void> _changePassword(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ChangePasswordDialog(),
    );
    if (ok == true) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.setPasswordChanged)));
    }
  }

  // ---------------- Delete account (server + is phone ka data) ----------------
  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _DeleteAccountDialog(),
    );
    if (ok != true) return;
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

/// Password badalne ka dialog (purana + naya + dobara naya)
class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _old = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  String? _oldError;
  String? _newError;
  String? _confirmError;
  String? _bannerError;
  bool _busy = false;

  @override
  void dispose() {
    _old.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final oldPw = _old.text;
    final newPw = _new.text;

    final oldErr = oldPw.isEmpty ? l10n.authPasswordEmpty : null;
    final newErr = newPw.length < 6 ? l10n.authPasswordError : null;
    final confirmErr = _confirm.text != newPw ? l10n.authPasswordMismatch : null;
    if (oldErr != null || newErr != null || confirmErr != null) {
      setState(() {
        _oldError = oldErr;
        _newError = newErr;
        _confirmError = confirmErr;
      });
      return;
    }

    setState(() {
      _busy = true;
      _bannerError = null;
    });
    final res = await AuthSession.instance.changePassword(
      oldPassword: oldPw,
      newPassword: newPw,
    );
    if (!mounted) return;
    if (res.ok) {
      Navigator.pop(context, true);
      return;
    }
    final error = res.error;
    setState(() {
      _busy = false;
      _bannerError =
          error == null ? l10n.errUnknown : authErrorText(l10n, error);
    });
    // Session khatam ho gaya to login par bhej do
    if (error == ApiError.unauthorized) {
      Navigator.pop(context, false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.setChangePassword),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_bannerError != null) ...[
              ErrorBanner(_bannerError!),
              const SizedBox(height: 12),
            ],
            PasswordField(
              controller: _old,
              label: l10n.setCurrentPassword,
              errorText: _oldError,
              enabled: !_busy,
              onChanged: (_) => setState(() => _oldError = null),
            ),
            const SizedBox(height: 12),
            PasswordField(
              controller: _new,
              label: l10n.authNewPassword,
              errorText: _newError,
              enabled: !_busy,
              onChanged: (_) => setState(() => _newError = null),
            ),
            const SizedBox(height: 12),
            PasswordField(
              controller: _confirm,
              label: l10n.authConfirmPassword,
              errorText: _confirmError,
              enabled: !_busy,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() => _confirmError = null),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: _busy
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(l10n.setChangePassword),
        ),
      ],
    );
  }
}

/// Account delete: password dekar tasdeeq
class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _password = TextEditingController();
  String? _fieldError;
  String? _bannerError;
  bool _busy = false;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (_password.text.isEmpty) {
      setState(() => _fieldError = l10n.authPasswordEmpty);
      return;
    }
    setState(() {
      _busy = true;
      _bannerError = null;
    });
    final res = await AuthSession.instance.deleteAccount(
      password: _password.text,
    );
    if (!mounted) return;
    if (res.ok || res.error == ApiError.unauthorized) {
      // Ya account gaya, ya session pehle hi khatam: dono mein bahar
      Navigator.pop(context, true);
      return;
    }
    final error = res.error;
    setState(() {
      _busy = false;
      _bannerError =
          error == null ? l10n.errUnknown : authErrorText(l10n, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return AlertDialog(
      title: Text(l10n.setDeleteConfirmTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.setDeleteConfirmMessage),
            const SizedBox(height: 16),
            if (_bannerError != null) ...[
              ErrorBanner(_bannerError!),
              const SizedBox(height: 12),
            ],
            PasswordField(
              controller: _password,
              label: l10n.authPassword,
              errorText: _fieldError,
              enabled: !_busy,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() => _fieldError = null),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _busy ? null : _submit,
          child: _busy
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(l10n.delete, style: TextStyle(color: colors.error)),
        ),
      ],
    );
  }
}
