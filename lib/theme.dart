import 'package:flutter/material.dart';

abstract final class RetroTheme {
  // --- Win91 / Frutiger Aero palette ---
  static const Color bg = Color(0xFFECE9D8);
  static const Color panel = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF222222);
  static const Color muted = Color(0xFF808080);
  static const Color border = Color(0xFFACA899);
  static const Color link = Color(0xFF0066CC);
  static const Color danger = Color(0xFFCC0000);
  static const Color accentBg = Color(0xFFF0F0F0);
  static const Color accentBlue = Color(0xFF316AC5);
  static const Color accentPink = Color(0xFFD4A0C8);
  static const Color accentYellow = Color(0xFFFFCC00);
  static const Color accentCyan = Color(0xFF4AA8D8);
  static const Color win98Gray = Color(0xFFD4D0C8);
  static const Color win98Light = Color(0xFFFFFFFF);
  static const Color win98Dark = Color(0xFF808080);
  static const Color win98Darkest = Color(0xFF404040);
  static const Color titleBar = Color(0xFF0054E3);
  static const Color titleBarEnd = Color(0xFF2A8AD4);
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
      seedColor: RetroTheme.accentBlue,
      brightness: Brightness.light,
      surface: RetroTheme.panel,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: RetroTheme.titleBar,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontFamily: 'monospace',
        letterSpacing: 0.5,
        shadows: [
          Shadow(
              offset: Offset(1, 1), color: Color(0x66000000), blurRadius: 0),
        ],
      ),
    ),
    dividerTheme:
        const DividerThemeData(color: RetroTheme.border, thickness: 1),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF316AC5),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: RetroTheme.bg,
      titleTextStyle: const TextStyle(
        color: RetroTheme.text,
        fontWeight: FontWeight.w700,
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      contentTextStyle: const TextStyle(
        color: RetroTheme.text,
        fontFamily: 'monospace',
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: RetroTheme.border, width: 1),
        borderRadius: BorderRadius.circular(3),
      ),
    ),
  );
}

PreferredSizeWidget retroAppBarBottomBorder() {
  return const PreferredSize(
    preferredSize: Size.fromHeight(2),
    child: _WinBorder(height: 2),
  );
}

AppBar retroAppBar(String title, {bool automaticallyImplyLeading = true}) {
  return AppBar(
    automaticallyImplyLeading: automaticallyImplyLeading,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [RetroTheme.titleBar, RetroTheme.titleBarEnd],
        ),
      ),
    ),
    title: Row(
      children: [
        const Icon(Icons.window, size: 16, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
            letterSpacing: 0.5,
            fontSize: 14,
            color: Colors.white,
            shadows: [
              Shadow(
                  offset: Offset(1, 1),
                  color: Color(0x66000000),
                  blurRadius: 0),
            ],
          ),
        ),
      ],
    ),
    bottom: retroAppBarBottomBorder(),
  );
}

class _WinBorder extends StatelessWidget {
  const _WinBorder({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: RetroTheme.border,
    );
  }
}
