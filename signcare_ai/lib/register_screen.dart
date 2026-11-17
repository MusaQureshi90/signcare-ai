import 'package:flutter/material.dart';

import 'app_settings.dart';
import 'app_theme.dart';
import 'auth_session.dart';
import 'auth_widgets.dart';
import 'dob_picker.dart';
import 'home_screen.dart';
import 'l10n_ext.dart';
import 'recovery_code_screen.dart';
import 'user_profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  DateTime? _dob;
  String _gender = '';

  bool _loading = false;
  String? _nameError;
  String? _phoneError;
  String? _dobError;
  String? _genderError;
  String? _passwordError;
  String? _confirmError;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  Future<void> _pickDob() async {
    final picked = await showDobPicker(context, initial: _dob);
    if (picked != null && mounted) {
      setState(() {
        _dob = picked;
        _dobError = null;
      });
    }
  }

  Future<void> _submit() async {
    if (_loading) return;
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    final password = _password.text;

    final nameError = name.length < 2 ? l10n.profileNameError : null;
    final phoneError = isValidPhone(phone) ? null : l10n.authPhoneError;
    final dobError = _dob == null ? l10n.profileDobError : null;
    final genderError = _gender.isEmpty ? l10n.profileGenderError : null;
    final passwordError =
        password.length < 6 ? l10n.authPasswordError : null;
    final confirmError =
        _confirm.text != password ? l10n.authPasswordMismatch : null;

    if (nameError != null ||
        phoneError != null ||
        dobError != null ||
        genderError != null ||
        passwordError != null ||
        confirmError != null) {
      setState(() {
        _nameError = nameError;
        _phoneError = phoneError;
        _dobError = dobError;
        _genderError = genderError;
        _passwordError = passwordError;
        _confirmError = confirmError;
        _error = null;
      });
      return;
    }

    final dob = _dob!;
    final ageText =
        '${UserProfile.ageFromDate(dob)} years (${_formatDate(dob)})';
    final settings = AppSettings.instance;

    setState(() {
      _loading = true;
      _nameError = null;
      _phoneError = null;
      _dobError = null;
      _genderError = null;
      _passwordError = null;
      _confirmError = null;
      _error = null;
    });

    final res = await AuthSession.instance.register(
      phone: phone,
      password: password,
      name: name,
      age: ageText,
      gender: _gender,
      language: settings.languageName,
      theme: authThemeName(settings.themeMode),
      layout: settings.homeLayout,
    );
    if (!mounted) return;

    if (!res.ok) {
      setState(() {
        _loading = false;
        _error = authErrorText(l10n, res.error!);
      });
      return;
    }

    final code = res.recoveryCode;
    final userName = AuthSession.instance.name;
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => code == null
            ? HomeScreen(userName: userName)
            : RecoveryCodeScreen(
                code: code,
                nextBuilder: () => HomeScreen(userName: userName),
              ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return AuthScaffold(
      showBack: true,
      title: l10n.authRegisterTitle,
      subtitle: l10n.authRegisterSubtitle,
      children: [
        TextField(
          controller: _name,
          enabled: !_loading,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.profileName,
            prefixIcon: const Icon(Icons.person_outline),
            errorText: _nameError,
          ),
        ),
        const SizedBox(height: 14),
        PhoneField(
          controller: _phone,
          errorText: _phoneError,
          enabled: !_loading,
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: _loading ? null : _pickDob,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l10n.profileDob,
              prefixIcon: const Icon(Icons.cake_outlined),
              suffixIcon: const Icon(Icons.calendar_today_outlined),
              errorText: _dobError,
            ),
            child: Text(_dob == null ? ' ' : _formatDate(_dob!)),
          ),
        ),
        const SizedBox(height: 14),
        Text(l10n.profileGender, style: context.text.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final entry in {
              'Male': l10n.genderMale,
              'Female': l10n.genderFemale,
              'Other': l10n.genderOther,
            }.entries)
              ChoiceChip(
                label: Text(entry.value),
                selected: _gender == entry.key,
                onSelected: _loading
                    ? null
                    : (_) => setState(() {
                          _gender = entry.key;
                          _genderError = null;
                        }),
              ),
          ],
        ),
        if (_genderError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              _genderError!,
              style: context.text.bodySmall?.copyWith(color: colors.error),
            ),
          ),
        const SizedBox(height: 14),
        PasswordField(
          controller: _password,
          label: l10n.authPassword,
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
          label: l10n.authRegister,
          onPressed: _submit,
          loading: _loading,
        ),
        if (_loading) const ConnectingNote(),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(l10n.authHaveAccount),
            TextButton(
              onPressed: _loading ? null : () => Navigator.pop(context),
              child: Text(l10n.authLogin),
            ),
          ],
        ),
      ],
    );
  }
}
