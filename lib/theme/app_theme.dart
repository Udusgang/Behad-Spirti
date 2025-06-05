import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Spiritual-inspired color palette
  static const Color primaryPurple = Color(0xFF6B46C1);
  static const Color secondaryGreen = Color(0xFF059669);
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color deepRed = Color(0xDC2626);
  static const Color softViolet = Color(0xFF7C3AED);
  
  // Neutral colors
  static const Color darkGray = Color(0xFF1F2937);
  static const Color mediumGray = Color(0xFF6B7280);
  static const Color lightGray = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
  
  // Background gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, softViolet],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryGreen, Color(0xFF10B981)],
  );

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkGray,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkGray,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkGray,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: darkGray,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkGray,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkGray,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkGray,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: darkGray,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: mediumGray,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: darkGray,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkGray,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: mediumGray,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkGray,
        ),
        iconTheme: const IconThemeData(color: darkGray),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: white,
          elevation: 2,
          shadowColor: primaryPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          side: const BorderSide(color: primaryPurple, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryPurple,
        unselectedItemColor: mediumGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mediumGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: deepRed),
        ),
        filled: true,
        fillColor: lightGray,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: GoogleFonts.inter(
          color: mediumGray,
          fontSize: 14,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryPurple,
        linearTrackColor: lightGray,
      ),
    );
  }

  // Dark theme (for future implementation)
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF111827),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1F2937),
      ),
    );
  }

  // Custom decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get gradientDecoration => const BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  // Custom text styles
  static TextStyle get categoryTitle => GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: white,
  );

  static TextStyle get courseTitle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: darkGray,
  );

  static TextStyle get courseSubtitle => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: mediumGray,
  );

  static TextStyle get videoTitle => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: darkGray,
  );

  static TextStyle get videoDuration => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: mediumGray,
  );

  // Helper method to safely get Google Fonts with fallback
  static TextStyle safeGoogleFont({
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    try {
      if (fontFamily == 'playfair') {
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      } else {
        return GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      }
    } catch (e) {
      // Fallback to system fonts
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily == 'playfair' ? 'serif' : 'sans-serif',
      );
    }
  }
}
