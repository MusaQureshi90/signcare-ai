import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'dob_picker.dart';
import 'l10n_ext.dart';
import 'user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfile profile = UserProfile.instance;
  late final TextEditingController _nameController;
  DateTime? _dob;
  String _gender = '';

  String? _nameError;
  String? _dobError;
  String? _genderError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: profile.name);
    _dob = profile.dateOfBirth;
    _gender = profile.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
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

  Future<void> _save() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final name = _nameController.text.trim();

    final String? nameError =
        name.length < 2 ? l10n.profileNameError : null;
    final String? dobError = _dob == null ? l10n.profileDobError : null;
    final String? genderError =
        _gender.isEmpty ? l10n.profileGenderError : null;

    if (nameError != null || dobError != null || genderError != null) {
      setState(() {
        _nameError = nameError;
        _dobError = dobError;
        _genderError = genderError;
      });
      return;
    }

    setState(() => _saving = true);
    await profile.save(
      newName: name,
      dob: _dob!,
      newGender: _gender,
    );
    if (!mounted) return;
    setState(() => _saving = false);

    messenger.showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currentName = _nameController.text.trim();
    final initial =
        currentName.isEmpty ? '?' : currentName.characters.first.toUpperCase();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: colors.primaryContainer,
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Directionality(
              textDirection: TextDirection.ltr, // phone number hamesha left-to-right
              child: Text(
                profile.phone,
                style: context.text.titleMedium
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              l10n.profilePhoneNote,
              style: context.text.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 24),

          // ---------- Naam ----------
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: l10n.profileName,
              prefixIcon: const Icon(Icons.person_outline),
              errorText: _nameError,
            ),
            onChanged: (_) => setState(() => _nameError = null),
          ),
          const SizedBox(height: 8),

          // ---------- Date of birth ----------
          InkWell(
            onTap: _pickDob,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.profileDob,
                prefixIcon: const Icon(Icons.cake_outlined),
                suffixIcon: const Icon(Icons.calendar_today_outlined),
                errorText: _dobError,
              ),
              child: Text(
                _dob == null
                    ? l10n.profileDobHint
                    : '${_formatDate(_dob!)}   •   ${l10n.profileAge(UserProfile.ageFromDate(_dob!))}',
                style: TextStyle(
                  fontSize: 16,
                  color: _dob == null
                      ? colors.onSurfaceVariant
                      : colors.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ---------- Gender ----------
          Text(
            l10n.profileGender,
            style: context.text.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            segments: [
              ButtonSegment<String>(
                value: 'Male',
                label: Text(l10n.genderMale),
              ),
              ButtonSegment<String>(
                value: 'Female',
                label: Text(l10n.genderFemale),
              ),
              ButtonSegment<String>(
                value: 'Other',
                label: Text(l10n.genderOther),
              ),
            ],
            selected: _gender.isEmpty ? <String>{} : <String>{_gender},
            onSelectionChanged: (selection) {
              setState(() {
                _gender = selection.isEmpty ? '' : selection.first;
                _genderError = null;
              });
            },
          ),
          if (_genderError != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _genderError!,
                style: TextStyle(color: colors.error, fontSize: 12),
              ),
            ),
          const SizedBox(height: 6),
          Text(
            l10n.profileGenderNote,
            style: context.text.bodySmall
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 28),

          // ---------- Save ----------
          ElevatedButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Text(l10n.profileSave),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}