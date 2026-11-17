import 'package:flutter/material.dart';

import 'auth_session.dart';
import 'auth_widgets.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'l10n_ext.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _remember = true;
  bool _loading = false;
  String? _phoneError;
  String? _passwordError;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final phone = _phone.text.trim();
    final password = _password.text;

    final phoneError = isValidPhone(phone) ? null : l10n.authPhoneError;
    final passwordError = password.isEmpty ? l10n.authPasswordEmpty : null;
    if (phoneError != null || passwordError != null) {
      setState(() {
        _phoneError = phoneError;
        _passwordError = passwordError;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _phoneError = null;
      _passwordError = null;
      _error = null;
    });

    final res = await AuthSession.instance.login(
      phone: phone,
      password: password,
      remember: _remember,
    );
    if (!mounted) return;

    if (res.ok) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: AuthSession.instance.name),
        ),
        (route) => false,
      );
      return;
    }
    setState(() {
      _loading = false;
      _error = authErrorText(l10n, res.error!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScaffold(
      title: l10n.authLoginTitle,
      subtitle: l10n.authLoginSubtitle,
      children: [
        PhoneField(
          controller: _phone,
          errorText: _phoneError,
          enabled: !_loading,
        ),
        const SizedBox(height: 14),
        PasswordField(
          controller: _password,
          label: l10n.authPassword,
          errorText: _passwordError,
          enabled: !_loading,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 4),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(l10n.authRememberMe),
          value: _remember,
          onChanged: _loading
              ? null
              : (value) => setState(() => _remember = value ?? true),
        ),
        if (_error != null) ...[
          const SizedBox(height: 4),
          ErrorBanner(_error!),
          const SizedBox(height: 12),
        ],
        AuthButton(label: l10n.authLogin, onPressed: _submit, loading: _loading),
        if (_loading) const ConnectingNote(),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _loading
              ? null
              : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
          child: Text(l10n.authForgot),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(l10n.authNoAccount),
            TextButton(
              onPressed: _loading
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
              child: Text(l10n.authRegisterNow),
            ),
          ],
        ),
      ],
    );
  }
}
