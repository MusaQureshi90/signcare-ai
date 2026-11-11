import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_screen.dart';
import 'common_needs_screen.dart';
import 'symptoms_screen.dart';
import 'emergency_screen.dart';
import 'custom_message_screen.dart';
import 'consultation_summary_screen.dart';
import 'doctor_response_screen.dart';
import 'speech_to_text_screen.dart';
import 'body_diagram_screen.dart';
import 'emotion_screen.dart';
import 'settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String savedLang = prefs.getString('app_language') ?? 'English';
  String savedTheme = prefs.getString('app_theme') ?? 'light';
  
  ThemeMode initialTheme = ThemeMode.light;
  if (savedTheme == 'dark') {
    initialTheme = ThemeMode.dark;
  }

  runApp(SignCareApp(initialLang: savedLang, initialTheme: initialTheme));
}

class SignCareApp extends StatefulWidget {
  final String initialLang;
  final ThemeMode initialTheme;
  const SignCareApp({super.key, required this.initialLang, required this.initialTheme});

  @override
  State<SignCareApp> createState() => _SignCareAppState();
}

class _SignCareAppState extends State<SignCareApp> {
  late Locale _locale;
  late String _currentLangName;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _currentLangName = widget.initialLang;
    _locale = _currentLangName == 'Urdu' ? const Locale('ur', 'PK') : const Locale('en', 'US');
    _themeMode = widget.initialTheme;
  }

  void setLocale(Locale locale, String langName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', langName);
    setState(() {
      _locale = locale;
      _currentLangName = langName;
    });
  }

  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignCare AI',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      locale: _locale,
      home: SplashScreen(
        currentLang: _currentLangName,
        onLocaleChange: setLocale,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userName;
  final Function(Locale, String) onLocaleChange;
  final String currentLang;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.onLocaleChange,
    required this.currentLang,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String activeLang;
  String currentLayout = 'List';
  ThemeMode currentTheme = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    activeLang = widget.currentLang;
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String themeStr = prefs.getString('app_theme') ?? 'light';
    setState(() {
      currentLayout = prefs.getString('home_layout') ?? 'List';
      currentTheme = themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitConfirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit SignCare AI?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              SystemNavigator.pop();
            },
            child: const Text('Exit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return exitConfirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    bool isUrdu = activeLang == 'Urdu';
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List menuItems = [
      {
        'title': isUrdu ? 'مواصلاتی کارڈز' : 'Communication Cards',
        'subtitle': isUrdu ? 'پیغام بنانے کے لیے کارڈز منتخب کریں' : 'Select cards to create a message',
        'icon': Icons.note_add_outlined,
        'color': Colors.teal,
        'screen': const CommonNeedsScreen(),
      },
      {
        'title': isUrdu ? 'پیغام لکھیں' : 'Type Message',
        'subtitle': isUrdu ? 'اپنا پیغام لکھیں اور بلند آواز میں بولیں' : 'Write your message and speak aloud',
        'icon': Icons.keyboard_outlined,
        'color': Colors.blue,
        'screen': const CustomMessageScreen(),
      },
      {
        'title': isUrdu ? 'علامات اور درد' : 'Symptoms & Body Pain',
        'subtitle': isUrdu ? 'اپنی علامات اور درد کی شدت بتائیں' : 'Tell us about your symptoms and pain level',
        'icon': Icons.sick_outlined,
        'color': Colors.orange,
        'screen': const SymptomsScreen(),
      },
      {
        'title': isUrdu ? 'جذبات اور احساسات' : 'Emotions & Feelings',
        'subtitle': isUrdu ? 'اپنے جذبات کا اظہار کریں' : 'Share how you feel emotionally',
        'icon': Icons.sentiment_satisfied_alt,
        'color': Colors.purple,
        'screen': const EmotionScreen(),
      },
      {
        'title': isUrdu ? 'ڈاکٹر کی ہدایات' : 'Doctor Instructions & Response',
        'subtitle': isUrdu ? 'ڈاکٹر کے جوابات اور ہدایات پڑھیں' : 'Read responses and instructions from doctor',
        'icon': Icons.announcement_outlined,
        'color': Colors.indigo,
        'screen': const DoctorResponseScreen(),
      },
      {
        'title': isUrdu ? 'رپورٹ کا خلاصہ دیکھیں' : 'View Report Summary',
        'subtitle': isUrdu ? 'طبی خلاصہ کا جائزہ لیں اور جمع کروائیں' : 'Review and submit compiled medical summary',
        'icon': Icons.assignment_outlined,
        'color': Colors.green,
        'screen': const ConsultationSummaryScreen(),
      },
      {
        'title': isUrdu ? 'ہنگامی مدد' : 'Emergency Help',
        'subtitle': isUrdu ? 'فوری طبی امداد کے لیے الرٹ' : 'Instant alert for urgent medical assistance',
        'icon': Icons.warning_amber_rounded,
        'color': Colors.red,
        'screen': const EmergencyScreen(),
      },
      {
        'title': isUrdu ? 'آواز سے تحریر' : 'Speech to Text',
        'subtitle': isUrdu ? 'آواز کو تحریر میں تبدیل کریں' : 'Convert speech into text',
        'icon': Icons.mic,
        'color': Colors.cyan,
        'screen': const SpeechToTextScreen(),
      },
      {
        'title': isUrdu ? 'جسم کا نقشہ' : 'Body Diagram',
        'subtitle': isUrdu ? 'جسم کے حصوں پر درد کی نشاندہی کریں' : 'Pinpoint pain on body parts',
        'icon': Icons.accessibility,
        'color': Colors.pink,
        'screen': const BodyDiagramScreen(),
      },
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isUrdu ? 'سائن کیئر اے آئی' : 'SignCare AI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.tealAccent : Colors.teal)),
              Text(isUrdu ? 'خوش آمدید, ${widget.userName}' : 'Welcome, ${widget.userName}', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey[700])),
            ],
          ),
          elevation: 1,
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: isDark ? Colors.tealAccent : Colors.teal),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      currentLanguage: activeLang,
                      currentThemeMode: currentTheme,
                      onLocaleChange: (locale, langName) {
                        widget.onLocaleChange(locale, langName);
                      },
                      onThemeChange: (themeMode) {
                        final appState = context.findAncestorStateOfType<_SignCareAppState>();
                        appState?.setThemeMode(themeMode);
                      },
                    ),
                  ),
                );

                final prefs = await SharedPreferences.getInstance();
                String savedLang = prefs.getString('app_language') ?? 'English';
                String savedLayout = prefs.getString('home_layout') ?? 'List';
                String themeStr = prefs.getString('app_theme') ?? 'light';
                setState(() {
                  activeLang = savedLang;
                  currentLayout = savedLayout;
                  currentTheme = themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUrdu ? 'ہیلو, ${widget.userName} 👋' : 'Hello, ${widget.userName} 👋',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                isUrdu ? 'آج ہم آپ کی کیا مدد کر سکتے ہیں؟' : 'How can we help you today?',
                style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: currentLayout == 'Grid'
                    ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          return InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => item['screen'])),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.withAlpha(50)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: (item['color'] as Color).withAlpha(25),
                                    radius: 24,
                                    child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 26),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item['title'] as String,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: (item['color'] as Color).withAlpha(25),
                                child: Icon(item['icon'] as IconData, color: item['color'] as Color),
                              ),
                              title: Text(item['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                              subtitle: Text(item['subtitle'] as String, style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey)),
                              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white70 : Colors.grey),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => item['screen'])),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}