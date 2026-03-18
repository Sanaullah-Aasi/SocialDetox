import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Gradient Colors
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color primaryPurpleLight = Color(0xFFA29BFE);
  static const Color primaryCyan = Color(0xFF00D2D3);
  static const Color primaryBlue = Color(0xFF54A0FF);

  // Background Colors
  static const Color backgroundDark = Color(0xFF0A0E27);
  static const Color backgroundDarkSecondary = Color(0xFF1A1F3D);
  static const Color backgroundDarkTertiary = Color(0xFF252B4A);

  // Surface Colors (Glass effect)
  static const Color surfaceGlass = Color(0x1AFFFFFF);
  static const Color surfaceGlassLight = Color(0x33FFFFFF);
  static const Color surfaceGlassDark = Color(0x0DFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF);
  static const Color textTertiary = Color(0x66FFFFFF);
  static const Color textMuted = Color(0x4DFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color successLight = Color(0xFF55EFC4);
  static const Color error = Color(0xFFFF6B6B);
  static const Color errorLight = Color(0xFFFF8E8E);
  static const Color warning = Color(0xFFFDAA5E);
  static const Color info = Color(0xFF74B9FF);

  // Button/Active States
  static const Color activeGreen = Color(0xFF00B894);
  static const Color inactiveGray = Color(0xFF636E72);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryCyan],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundDark, backgroundDarkSecondary],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryPurpleLight],
  );

  static const LinearGradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryCyan, primaryBlue],
  );

  static LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withValues(alpha: 0.15),
      Colors.white.withValues(alpha: 0.05),
    ],
  );

  // Power Button States
  static const LinearGradient powerButtonActive = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF00CEC9)],
  );

  static const LinearGradient powerButtonInactive = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryCyan],
  );

  // Glow Colors
  static Color glowPurple = primaryPurple.withValues(alpha: 0.5);
  static Color glowCyan = primaryCyan.withValues(alpha: 0.5);
  static Color glowGreen = success.withValues(alpha: 0.5);
}
