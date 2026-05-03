import 'package:flutter/material.dart';

/// Port of [src/theme.ts](retro-energy-shop/src/theme.ts)
abstract final class RetroTheme {
  static const Color bg = Color(0xFFD4D7FF);
  static const Color panel = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF000000);
  static const Color muted = Color(0xFF2E2E58);
  static const Color border = Color(0xFF000000);
  static const Color link = Color(0xFF0000CC);
  static const Color danger = Color(0xFFAD0000);
  static const Color accentBg = Color(0xFFFFF2A8);
  static const Color accentBlue = Color(0xFF9CC2FF);
  static const Color accentPink = Color(0xFFFFC6E6);
}

abstract final class RetroSpacing {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
}

ThemeData buildRetroMaterialTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: RetroTheme.text,
      brightness: Brightness.light,
      surface: RetroTheme.panel,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: RetroTheme.accentBg,
      foregroundColor: RetroTheme.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: RetroTheme.text,
        fontSize: 18,
        fontWeight: FontWeight.w900,
        decoration: TextDecoration.underline,
        letterSpacing: 0.8,
      ),
    ),
    dividerTheme:
        const DividerThemeData(color: RetroTheme.border, thickness: 2),
  );
}

/// Stack header underline + thick bottom border like RN stack.
PreferredSizeWidget retroAppBarBottomBorder() {
  return const PreferredSize(
    preferredSize: Size.fromHeight(3),
    child: Divider(height: 3, thickness: 3, color: RetroTheme.border),
  );
}

/// Stack-style header (yellow + thick underline + bottom border).
AppBar retroAppBar(String title, {bool automaticallyImplyLeading = true}) {
  return AppBar(
    backgroundColor: RetroTheme.accentBg,
    foregroundColor: RetroTheme.text,
    automaticallyImplyLeading: automaticallyImplyLeading,
    title: Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        decoration: TextDecoration.underline,
      ),
    ),
    bottom: retroAppBarBottomBorder(),
  );
}
