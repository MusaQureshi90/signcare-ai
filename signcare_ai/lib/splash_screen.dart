import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'auth_session.dart';
import 'home_screen.dart';
import 'l10n_ext.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    final session = AuthSession.instance;
    final Widget next = session.isLoggedIn
        ? HomeScreen(userName: session.name)
        : const LoginScreen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medical_services_rounded,
                size: 80,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.appName,
              style: context.text.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tagline,
              style: context.text.titleMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 36),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
