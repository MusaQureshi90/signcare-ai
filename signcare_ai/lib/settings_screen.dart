import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'api_service.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale, String) onLocaleChange;
  final Function(ThemeMode) onThemeChange;
  final String currentLanguage;
  final ThemeMode currentThemeMode;

  const SettingsScreen({
    super.key,
    required this.onLocaleChange,
    required this.onThemeChange,
    required this.currentLanguage,
    required this.currentThemeMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String selectedLanguage;
  late String initialLanguage;
  String selectedLayout = 'List';
  late ThemeMode selectedTheme;
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.currentLanguage;
    initialLanguage = widget.currentLanguage;
    selectedTheme = widget.currentThemeMode;
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLayout = prefs.getString('home_layout') ?? 'List';
      userPhone = prefs.getString('logged_phone') ?? '';
    });

    if (userPhone.isNotEmpty) {
      final backendPrefs = await ApiService.getPreferences(userPhone);
      if (backendPrefs != null) {
        setState(() {
          if (backendPrefs['home_layout'] != null) {
            selectedLayout = backendPrefs['home_layout'];
          }
        });
      }
    }
  }

  Future<void> _syncToBackend() async {
    if (userPhone.isEmpty) return;
    String themeStr = selectedTheme == ThemeMode.dark ? 'dark' : (selectedTheme == ThemeMode.light ? 'light' : 'system');
    
    await ApiService.savePreferences(
      userPhone,
      selectedLanguage,
      themeStr,
      selectedLayout,
    );
  }

  Future<void> _saveLayoutPreference(String layout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('home_layout', layout);
    setState(() {
      selectedLayout = layout;
    });
    await _syncToBackend();
  }

  Future<void> _saveThemePreference(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeStr = themeMode == ThemeMode.dark ? 'dark' : (themeMode == ThemeMode.light ? 'light' : 'system');
    await prefs.setString('app_theme', themeStr);
    setState(() {
      selectedTheme = themeMode;
    });
    widget.onThemeChange(themeMode);
    await _syncToBackend();
  }

  Future<bool> _onWillPop() async {
    if (selectedLanguage != initialLanguage) {
      bool? shouldSave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text('Do you want to save language changes or discard them?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Discard', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      );

      if (shouldSave == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('app_language', selectedLanguage);

        if (selectedLanguage == 'Urdu') {
          widget.onLocaleChange(const Locale('ur', 'PK'), 'Urdu');
        } else {
          widget.onLocaleChange(const Locale('en', 'US'), 'English');
        }
        await _syncToBackend();
      } else {
        selectedLanguage = initialLanguage;
      }
    }
    return true;
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to logout from your account?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('is_logged_in', false);
              await prefs.remove('logged_phone');
              await prefs.remove('logged_name');
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account Data'),
        content: const Text('Do you really want to delete your data and account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isUrdu = selectedLanguage == 'Urdu';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onWillPop();
        if (context.mounted) {
          Navigator.pop(context, selectedLanguage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUrdu ? 'ایپ کی سیٹنگز' : 'App Settings'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _onWillPop();
              if (context.mounted) {
                Navigator.pop(context, selectedLanguage);
              }
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(isUrdu ? 'زبان کی ترجیحات' : 'Language Preferences', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('English'),
                    subtitle: const Text('Default app language'),
                    value: 'English',
                    groupValue: selectedLanguage,
                    onChanged: (val) {
                      setState(() => selectedLanguage = val!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Urdu (اردو)'),
                    subtitle: const Text('Switch app to Urdu'),
                    value: 'Urdu',
                    groupValue: selectedLanguage,
                    onChanged: (val) {
                      setState(() => selectedLanguage = val!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Appearance (Theme Mode)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('Light Mode'),
                    subtitle: const Text('Bright and clean interface'),
                    value: ThemeMode.light,
                    groupValue: selectedTheme,
                    onChanged: (val) {
                      _saveThemePreference(val!);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Easy on the eyes in low light'),
                    value: ThemeMode.dark,
                    groupValue: selectedTheme,
                    onChanged: (val) {
                      _saveThemePreference(val!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Home Screen Layout Style', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Vertical List Cards'),
                    subtitle: const Text('Standard clean list layout'),
                    value: 'List',
                    groupValue: selectedLayout,
                    onChanged: (val) {
                      _saveLayoutPreference(val!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Grid Boxes'),
                    subtitle: const Text('Modern 2-column box layout'),
                    value: 'Grid',
                    groupValue: selectedLayout,
                    onChanged: (val) {
                      _saveLayoutPreference(val!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(isUrdu ? 'اکاؤنٹ کی کارروائیاں' : 'Account Actions', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.orange),
                    title: Text(isUrdu ? 'لاگ آؤٹ' : 'Logout', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(isUrdu ? 'اس ڈیوائس سے سائن آؤٹ کریں' : 'Sign out from this device'),
                    onTap: () => _confirmLogout(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: Text(isUrdu ? 'اکاؤنٹ اور ڈیٹا حذف کریں' : 'Delete Account & Data', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    subtitle: Text(isUrdu ? 'اپنا مقامی اکاؤنٹ ڈیٹا مستقل طور پر ہٹائیں' : 'Permanently remove your local account data'),
                    onTap: () => _confirmDeleteAccount(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(isUrdu ? 'ایپ کی معلومات' : 'App Information', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.info, color: Colors.teal),
                title: Text(isUrdu ? 'سائن کیئر اے آئی ورژن' : 'SignCare AI Version'),
                subtitle: const Text('1.0.0+1 (Production Ready)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}