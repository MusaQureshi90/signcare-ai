import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_session.dart';
import 'auth_widgets.dart';
import 'l10n_ext.dart';
import 'login_screen.dart';
import 'recovery_code_screen.dart';

/// Password bhoolne par: phone number + register ke waqt mila recovery code.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  bool _loading = false;
  String? _phoneError;
  String? _codeError;
  String? _passwordError;
  String? _confirmError;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final phone = _phone.text.trim();
    final code = _code.text.trim();
    final password = _password.text;

    // Code mein harf/ankon ke ilawa jo bhi (jaise '-') ho, ginti mein nahi.
    final codeLength = code.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').length;

    final phoneError = isValidPhone(phone) ? null : l10n.authPhoneError;
    final codeError = codeLength == 12 ? null : l10n.authRecoveryError;
    final passwordError =
        password.length < 6 ? l10n.authPasswordError : null;
    final confirmError =
        _confirm.text != password ? l10n.authPasswordMismatch : null;

    if (phoneError != null ||
        codeError != null ||
        passwordError != null ||
        confirmError != null) {
      setState(() {
        _phoneError = phoneError;
        _codeError = codeError;
        _passwordError = passwordError;
        _confirmError = confirmError;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _phoneError = null;
      _codeError = null;
      _passwordError = null;
      _confirmError = null;
      _error = null;
    });

    final res = await AuthSession.instance.resetPassword(
      phone: phone,
      recoveryCode: code,
      newPassword: password,
    );
    if (!mounted) return;

    if (!res.ok) {
      setState(() {
        _loading = false;
        _error = authErrorText(l10n, res.error!);
      });
      return;
    }

    final newCode = res.recoveryCode;
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => newCode == null
            ? const LoginScreen()
            : RecoveryCodeScreen(
                code: newCode,
                nextBuilder: () => const LoginScreen(),
              ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthScaffold(
      showBack: true,
      title: l10n.authForgotTitle,
      subtitle: l10n.authForgotSubtitle,
      children: [
        PhoneField(
          controller: _phone,
          errorText: _phoneError,
          enabled: !_loading,
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _code,
          enabled: !_loading,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.characters,
          textDirection: TextDirection.ltr,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\- ]')),
            LengthLimitingTextInputFormatter(20),
          ],
          decoration: InputDecoration(
            labelText: l10n.authRecoveryCode,
            hintText: 'XXXX-XXXX-XXXX',
            prefixIcon: const Icon(Icons.key_outlined),
            errorText: _codeError,
          ),
        ),
        const SizedBox(height: 14),
        PasswordField(
          controller: _password,
          label: l10n.authNewPassword,
          errorText: _passwordError,
          enabled: !_loading,
        ),
        const SizedBox(height: 14),
        PasswordField(
          controller: _confirm,
          label: l10n.authConfirmPassword,
          errorText: _confirmError,
          enabled: !_loading,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 18),
        if (_error != null) ...[
          ErrorBanner(_error!),
          const SizedBox(height: 12),
        ],
        AuthButton(
          label: l10n.authReset,
          onPressed: _submit,
          loading: _loading,
        ),
        if (_loading) const ConnectingNote(),
      ],
    );
  }
}
