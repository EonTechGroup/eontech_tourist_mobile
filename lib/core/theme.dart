import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //  Brand Palette──
  static const Color oceanBlue   = Color(0xFF006994);
  static const Color deepTeal    = Color(0xFF00897B);
  static const Color goldenSun   = Color(0xFFFFB300);
  static const Color coralRed    = Color(0xFFE53935);
  static const Color forestGreen = Color(0xFF2E7D32);
  static const Color sunsetOrange = Color(0xFFFF7043);
  static const Color darkInk     = Color(0xFF1A1A2E);
  static const Color softGrey    = Color(0xFFF1F5F9);
  static const Color mutedText   = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  //  Category color helper 
  static Color categoryColor(String category) {
    switch (category) {
      case 'beach':     return const Color(0xFF0288D1);
      case 'heritage':  return const Color(0xFF7B1FA2);
      case 'wildlife':  return const Color(0xFF2E7D32);
      case 'temple':    return const Color(0xFFE64A19);
      case 'food':      return const Color(0xFFF57F17);
      case 'adventure': return const Color(0xFF00838F);
      default:          return oceanBlue;
    }
  }

  // Light Theme─
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: oceanBlue,
        secondary: deepTeal,
        brightness: Brightness.light,
      ).copyWith(tertiary: goldenSun),
      scaffoldBackgroundColor: softGrey,
    );

    return base.copyWith(
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32, fontWeight: FontWeight.w700, color: darkInk,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 26, fontWeight: FontWeight.w700, color: darkInk,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 22, fontWeight: FontWeight.w600, color: darkInk,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 20, fontWeight: FontWeight.w700, color: darkInk,
        ),
        headlineSmall: GoogleFonts.nunito(
          fontSize: 18, fontWeight: FontWeight.w700, color: darkInk,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w600, color: darkInk,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w600, color: darkInk,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w400, color: darkInk,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w400, color: mutedText,
        ),
        bodySmall: GoogleFonts.nunito(
          fontSize: 12, fontWeight: FontWeight.w400, color: mutedText,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20, fontWeight: FontWeight.w700, color: darkInk,
        ),
        iconTheme: const IconThemeData(color: darkInk),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: oceanBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16, fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: oceanBlue,
          side: const BorderSide(color: oceanBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16, fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.nunito(color: mutedText, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: oceanBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: coralRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: softGrey,
        selectedColor: const Color(0x1F006994), 
        labelStyle: GoogleFonts.nunito(
          fontSize: 13, fontWeight: FontWeight.w600,
        ),
        side: const BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: oceanBlue,
        unselectedItemColor: mutedText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 11, fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 11, fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  //  Dark Theme
  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: oceanBlue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0D1117),
    );

    return base.copyWith(
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,
        ),
        headlineSmall: GoogleFonts.nunito(
          fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14, color: Colors.white70,
        ),
        bodySmall: GoogleFonts.nunito(
          fontSize: 12, color: Colors.white70,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}