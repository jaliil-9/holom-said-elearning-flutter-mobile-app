import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/colors.dart';

class JTextTheme {
  JTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    // Display styles for main headlines
    displayLarge: GoogleFonts.tajawal(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
    ),
    displayMedium: GoogleFonts.tajawal(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
    ),
    displaySmall: GoogleFonts.tajawal(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
    ),

    // Headline styles for section headers
    headlineLarge: GoogleFonts.tajawal(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryLight,
    ),
    headlineMedium: GoogleFonts.tajawal(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),
    headlineSmall: GoogleFonts.tajawal(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),

    // Title styles for card titles and subheaders
    titleLarge: GoogleFonts.tajawal(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    titleMedium: GoogleFonts.tajawal(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),
    titleSmall: GoogleFonts.tajawal(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
    ),

    // Body styles for regular text
    bodyLarge: GoogleFonts.tajawal(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimaryLight,
    ),
    bodyMedium: GoogleFonts.tajawal(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryLight,
    ),
    bodySmall: GoogleFonts.tajawal(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryLight,
    ),

    // Label styles for buttons and small text
    labelLarge: GoogleFonts.tajawal(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.primaryLight,
    ),
    labelMedium: GoogleFonts.tajawal(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.primaryLight,
    ),
    labelSmall: GoogleFonts.tajawal(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.primaryLight,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.tajawal(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
    ),
    displayMedium: GoogleFonts.tajawal(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
    ),
    displaySmall: GoogleFonts.tajawal(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
    ),
    headlineLarge: GoogleFonts.tajawal(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryDark,
    ),
    headlineMedium: GoogleFonts.tajawal(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryDark,
    ),
    headlineSmall: GoogleFonts.tajawal(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryDark,
    ),
    titleLarge: GoogleFonts.tajawal(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    titleMedium: GoogleFonts.tajawal(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
    ),
    titleSmall: GoogleFonts.tajawal(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
    ),
    bodyLarge: GoogleFonts.tajawal(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimaryDark,
    ),
    bodyMedium: GoogleFonts.tajawal(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryDark,
    ),
    bodySmall: GoogleFonts.tajawal(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryDark,
    ),
    labelLarge: GoogleFonts.tajawal(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.primaryDark,
    ),
    labelMedium: GoogleFonts.tajawal(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.primaryDark,
    ),
    labelSmall: GoogleFonts.tajawal(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.primaryDark,
    ),
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    secondaryHeaderColor: AppColors.secondaryLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.surfaceLight,
    textTheme: JTextTheme.lightTextTheme,

    // Enhanced theme properties
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      tertiary: AppColors.accentLight,
      surface: AppColors.surfaceLight,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryLight,
      onError: Colors.white,
    ),

    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.tajawal(
        color: AppColors.textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: AppColors.primaryLight,
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textSecondaryLight,
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 22),
      selectedLabelStyle: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentLight,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryLight,
      unselectedLabelColor: AppColors.textSecondaryLight,
      indicatorColor: AppColors.primaryLight,
      labelStyle: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.textSecondaryLight.withValues(alpha: 0.2),
      thickness: 1,
      space: 24,
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: AppColors.textSecondaryLight.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: AppColors.textSecondaryLight.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      labelStyle: GoogleFonts.tajawal(
        color: AppColors.textPrimaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.tajawal(
        color: AppColors.textSecondaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.tajawal(
        color: AppColors.error,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: AppColors.textSecondaryLight,
      suffixIconColor: AppColors.textSecondaryLight,
      isDense: true,
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: BorderSide(color: AppColors.primaryLight, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.tajawal(
        color: AppColors.textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: GoogleFonts.tajawal(
        color: AppColors.textPrimaryLight,
        fontSize: 16,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    secondaryHeaderColor: AppColors.secondaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.surfaceDark,
    textTheme: JTextTheme.darkTextTheme,

    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      tertiary: AppColors.accentDark,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryDark,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.tajawal(
        color: AppColors.textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: AppColors.primaryDark,
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.textSecondaryDark,
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 22),
      selectedLabelStyle: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryDark,
      unselectedLabelColor: AppColors.textSecondaryDark,
      indicatorColor: AppColors.primaryDark,
      labelStyle: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.textSecondaryDark.withValues(alpha: 0.2),
      thickness: 1,
      space: 24,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: AppColors.textSecondaryDark.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: AppColors.textSecondaryDark.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      labelStyle: GoogleFonts.tajawal(
        color: AppColors.textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.tajawal(
        color: AppColors.textSecondaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.tajawal(
        color: AppColors.error,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: AppColors.textSecondaryDark,
      suffixIconColor: AppColors.textSecondaryDark,
      isDense: true,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        side: BorderSide(color: AppColors.primaryDark, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.tajawal(
        color: AppColors.textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: GoogleFonts.tajawal(
        color: AppColors.textPrimaryDark,
        fontSize: 16,
      ),
    ),
  );
}
