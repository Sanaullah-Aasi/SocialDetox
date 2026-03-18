import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/detox_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SocialDetoxApp());
}

class SocialDetoxApp extends StatelessWidget {
  const SocialDetoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetoxProvider(),
      child: MaterialApp(
        title: 'SocialDetox',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark, // Enforce dark mode for the "cool/neon" vibe
        // Modern Light Theme (Glass & Gradient)
        theme: _buildTheme(Brightness.light),

        // Cyber/Neon Dark Theme
        darkTheme: _buildTheme(Brightness.dark),

        home: const SplashScreen(),
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Core Colors
    final seedColor = const Color(0xFF0D9488); // Teal
    final primary = isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488);
    final secondary =
        isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
    final background =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF0FDFA);
    final surface = isDark ? const Color(0xFF1E293B) : Colors.white;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,

      // Typography
      textTheme: GoogleFonts.interTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ).apply(
        bodyColor: isDark ? Colors.white : const Color(0xFF0F172A),
        displayColor: isDark ? Colors.white : const Color(0xFF0F172A),
      ),

      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        surface: surface,
        onError: Colors.white,
        error: const Color(0xFFEF4444),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          letterSpacing: 1.0,
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),

      // Cards (Glass effect base)
      cardTheme: CardTheme(
        color: surface.withValues(alpha: isDark ? 0.6 : 0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color:
                isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color:
                isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(20),
        hintStyle: GoogleFonts.inter(
          color: isDark ? Colors.white38 : Colors.black38,
        ),
      ),
    );
  }
}
