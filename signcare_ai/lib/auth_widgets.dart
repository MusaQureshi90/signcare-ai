import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api_client.dart';
import 'app_settings.dart';
import 'app_theme.dart';
import 'l10n/app_localizations.dart';
import 'l10n_ext.dart';

final RegExp _phonePattern = RegExp(r'^03\d{9}$');

bool isValidPhone(String value) => _phonePattern.hasMatch(value);

String authThemeName(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.system:
      return 'system';
    case ThemeMode.light:
      return 'light';
  }
}

/// Server ke error ko user ki zubaan mein message banata hai.
String authErrorText(AppLocalizations l10n, ApiError error) {
  switch (error) {
    case ApiError.network:
      return l10n.errNetwork;
    case ApiError.timeout:
      return l10n.errTimeout;
    case ApiError.server:
      return l10n.errServer;
    case ApiError.unauthorized:
      return l10n.errSessionExpired;
    case ApiError.invalidCredentials:
      return l10n.errInvalidCredentials;
    case ApiError.phoneExists:
      return l10n.errPhoneExists;
    case ApiError.locked:
      return l10n.errLocked;
    case ApiError.throttled:
      return l10n.errThrottled;
    case ApiError.validation:
      return l10n.errValidation;
    case ApiError.wrongPassword:
      return l10n.errWrongPassword;
    case ApiError.invalidRecovery:
      return l10n.errInvalidRecovery;
    case ApiError.unknown:
      return l10n.errUnknown;
  }
}

/// English | اردو badla jane wala switch (login se pehle bhi chalta hai).
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) {
        final current = AppSettings.instance.isUrdu ? 'Urdu' : 'English';
        return SegmentedButton<String>(
          showSelectedIcon: false,
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          segments: const [
            ButtonSegment<String>(value: 'English', label: Text('English')),
            ButtonSegment<String>(value: 'Urdu', label: Text('اردو')),
          ],
          selected: {current},
          onSelectionChanged: (selection) {
            AppSettings.instance.setLanguageName(selection.first);
          },
        );
      },
    );
  }
}

/// Login / Register / Reset teeno ka common dhancha.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.showBack = false,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBack,
        actions: const [
          LanguageToggle(),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.medical_services_rounded,
                        size: 44,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: context.text.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Phone number: sirf 11 digits, hamesha left-to-right.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      textDirection: TextDirection.ltr,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: context.l10n.authPhone,
        hintText: '03XXXXXXXXX',
        prefixIcon: const Icon(Icons.phone_outlined),
        errorText: errorText,
      ),
    );
  }
}

/// Password: dikhane/chhupane ka button ke sath.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      textDirection: TextDirection.ltr,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        errorText: widget.errorText,
        suffixIcon: IconButton(
          tooltip: _obscure ? l10n.authShowPassword : l10n.authHidePassword,
          icon: Icon(
            _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

/// Server ya form ka error, lal dabbe mein.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: colors.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bara button, loading par spinner.
class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Text(label),
      ),
    );
  }
}

/// Loading ke dauran halka sa note (Render ko jagne mein waqt lagta hai).
class ConnectingNote extends StatelessWidget {
  const ConnectingNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        context.l10n.authConnecting,
        textAlign: TextAlign.center,
        style: context.text.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
