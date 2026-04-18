import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color red = Color(0xFFE53935);
  static const Color amber = Color(0xFFFF8F00);
  static const Color blue = Color(0xFF1565C0);
  static const Color green = Color(0xFF2E7D32);
  static const Color bg = Color(0xFF0D0D0F);
  static const Color surface = Color(0xFF18181C);
  static const Color surface2 = Color(0xFF22222A);
  static const Color border = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color text = Color(0xFFF5F4F0);
  static const Color muted = Color(0x80F5F4F0);

  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      primaryColor: red,
      colorScheme: const ColorScheme.dark(
        primary: red,
        surface: surface,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(
        baseTextTheme.copyWith(
          displayLarge: GoogleFonts.sora(color: text),
          displayMedium: GoogleFonts.sora(color: text),
          displaySmall: GoogleFonts.sora(color: text),
          headlineLarge: GoogleFonts.sora(color: text, fontWeight: FontWeight.w700),
          headlineMedium: GoogleFonts.sora(color: text, fontWeight: FontWeight.w600),
          headlineSmall: GoogleFonts.sora(color: text),
          titleLarge: GoogleFonts.sora(color: text, fontWeight: FontWeight.w600),
          titleMedium: GoogleFonts.sora(color: text),
          titleSmall: GoogleFonts.sora(color: text),
          bodyLarge: const TextStyle(color: text),
          bodyMedium: const TextStyle(color: text),
          bodySmall: const TextStyle(color: muted),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: red,
        unselectedItemColor: muted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
