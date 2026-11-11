import 'package:flutter/material.dart';
import 'app_settings.dart';
import 'app_theme.dart';
import 'l10n/app_localizations.dart';
import 'splash_screen.dart';

// Purani files (splash / login / otp) HomeScreen ko 'main.dart' se import karti hain.
// Jab tak wo files rewrite nahi hotin, ye line unhe chalati rakhti hai.
export 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.instance.load();
  runApp(const SignCareApp());
}

class SignCareApp extends StatelessWidget {
  const SignCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Jab bhi AppSettings badlegi (language/theme), poori app khud rebuild hogi.
    return ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) {
        final settings = AppSettings.instance;
        return MaterialApp(
          title: 'SignCare AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          locale: settings.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SplashScreen(
            currentLang: settings.languageName,
            onLocaleChange: (locale, langName) {
              settings.setLanguageName(langName);
            },
          ),
        );
      },
    );
  }
}