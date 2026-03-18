import 'package:flutter/material.dart';

/// Project Zenith - Cybernetic Design System
class AppColors {
  AppColors._();

  // ============================================
  // ZENITH CORE PALETTE
  // ============================================

  // Background - Obsidian Base
  static const Color obsidianBase = Color(0xFF09090B);
  static const Color elevatedSurface = Color(0xFF18181B);
  static const Color zinc900 = Color(0xFF18181B);
  static const Color zinc800 = Color(0xFF27272A);
  static const Color zinc700 = Color(0xFF3F3F46);
  static const Color zinc600 = Color(0xFF52525B);
  static const Color zinc500 = Color(0xFF71717A);
  static const Color zinc400 = Color(0xFFA1A1AA);

  // Primary States
  static const Color electricIndigo = Color(0xFF4F46E5);
  static const Color electricIndigoLight = Color(0xFF6366F1);
  static const Color bioluminescentMint = Color(0xFF10B981);
  static const Color bioluminescentMintLight = Color(0xFF34D399);

  // Warning/Error/Amber
  static const Color coralWarning = Color(0xFFF43F5E);
  static const Color coralWarningLight = Color(0xFFFB7185);
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFBBF24);

  // Text - Stardust System
  static const Color stardust = Color(0xFFFAFAFA);
  static const Color textPrimary = stardust;
  static const Color textSecondary = Color(0x99FFFFFF); // 60% white
  static const Color textTertiary = Color(0x66FFFFFF);  // 40% white
  static const Color textMuted = Color(0x40FFFFFF);     // 25% white

  // Borders
  static const Color cardBorder = Color(0x0AFFFFFF);    // 4% white
  static const Color subtleBorder = Color(0x14FFFFFF);  // 8% white

  // ============================================
  // LEGACY ALIASES (for backward compatibility)
  // ============================================
  static const Color primaryPurple = electricIndigo;
  static const Color primaryPurpleLight = electricIndigoLight;
  static const Color primaryCyan = bioluminescentMint;
  static const Color primaryBlue = Color(0xFF3B82F6);

  static const Color backgroundDark = obsidianBase;
  static const Color backgroundDarkSecondary = elevatedSurface;
  static const Color backgroundDarkTertiary = zinc800;

  static const Color surfaceGlass = Color(0x0AFFFFFF);
  static const Color surfaceGlassLight = Color(0x14FFFFFF);
  static const Color surfaceGlassDark = Color(0x06FFFFFF);

  static const Color success = bioluminescentMint;
  static const Color successLight = bioluminescentMintLight;
  static const Color error = coralWarning;
  static const Color errorLight = coralWarningLight;
  static const Color warning = amber;
  static const Color info = Color(0xFF3B82F6);

  static const Color activeGreen = bioluminescentMint;
  static const Color inactiveGray = zinc700;

  // ============================================
  // ZENITH GRADIENTS
  // ============================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricIndigo, bioluminescentMint],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [obsidianBase, Color(0xFF0C0C0E)],
  );

  static const LinearGradient indigoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricIndigo, electricIndigoLight],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bioluminescentMint, bioluminescentMintLight],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [elevatedSurface, zinc900],
  );

  // Legacy gradient aliases
  static const LinearGradient purpleGradient = indigoGradient;
  static const LinearGradient cyanGradient = mintGradient;
  static const LinearGradient glassGradient = surfaceGradient;

  static const LinearGradient powerButtonActive = mintGradient;
  static const LinearGradient powerButtonInactive = indigoGradient;

  // ============================================
  // ZENITH GLOW SYSTEM
  // ============================================

  static const Color glowIndigo = Color(0x334F46E5);    // 20% electricIndigo
  static const Color glowMint = Color(0x3310B981);      // 20% bioluminescentMint
  static const Color glowCoral = Color(0x33F43F5E);     // 20% coralWarning

  // Legacy glow aliases
  static const Color glowPurple = glowIndigo;
  static const Color glowCyan = glowMint;
  static const Color glowGreen = glowMint;
}
