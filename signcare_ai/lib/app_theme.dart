import 'package:flutter/material.dart';

/// Ye SignCare AI ke SAARE rang aur component styles ek jagah rakhta hai.
///
/// RULE: screens mein kabhi Colors.white / Colors.black / Colors.grey[100]
/// jaise rang hardcode nahi karne. Hamesha ye use karo:
///     Theme.of(context).colorScheme.surface
///     ya chhota rasta:  context.colors.surface
class AppTheme {
  AppTheme._();

  // ---------------- LIGHT MODE ----------------
  static final ColorScheme _lightScheme = ColorScheme.light(
    primary: const Color(0xFF00796B), // teal
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFB2DFDB),
    onPrimaryContainer: const Color(0xFF00302B),
    secondary: const Color(0xFF1677E8), // blue
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFD6E8FF),
    onSecondaryContainer: const Color(0xFF0B2E5C),
    error: const Color(0xFFB3261E),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: const Color(0xFF1B2B2B),
    onSurfaceVariant: const Color(0xFF4A5E5E),
    surfaceContainerHighest: const Color(0xFFE3EDED),
    outline: const Color(0xFF7A9090),
    outlineVariant: const Color(0xFFCADADA),
  );

  // ---------------- DARK MODE ----------------
  static final ColorScheme _darkScheme = ColorScheme.dark(
    primary: const Color(0xFF4DB6AC), // halka teal (dark pe nazar aaye)
    onPrimary: const Color(0xFF00201D),
    primaryContainer: const Color(0xFF00504A),
    onPrimaryContainer: const Color(0xFFB2EBE4),
    secondary: const Color(0xFF7AB8FF),
    onSecondary: const Color(0xFF00315C),
    secondaryContainer: const Color(0xFF0F4A8A),
    onSecondaryContainer: const Color(0xFFD6E8FF),
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
    surface: const Color(0xFF1E1E1E),
    onSurface: const Color(0xFFE6EDED),
    onSurfaceVariant: const Color(0xFFB0C4C4),
    surfaceContainerHighest: const Color(0xFF2B3232),
    outline: const Color(0xFF8AA0A0),
    outlineVariant: const Color(0xFF3F4A4A),
  );

  static ThemeData get light => _build(_lightScheme, const Color(0xFFF5FAFC));
  static ThemeData get dark => _build(_darkScheme, const Color(0xFF121212));

  static ThemeData _build(ColorScheme scheme, Color scaffoldBg) {
    final bool isDark = scheme.brightness == Brightness.dark;

    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
    );

    return base.copyWith(
      // Text ka rang theme se khud aayega (light = gehra, dark = safed)
      textTheme: base.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(64, 52), // bade touch targets
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(64, 52),
          side: BorderSide(color: scheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withAlpha(120),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isDark ? const Color(0xFF3A4444) : const Color(0xFF263535),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
    );
  }
}

/// Chhote rastay: Theme.of(context).colorScheme ki jagah  context.colors
extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}