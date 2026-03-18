import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';
import 'main_screen.dart';

/// Project Zenith - Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _morphController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();

    // Set system UI
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.obsidianBase,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _breathAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOutSine),
    );

    _fadeController.forward();

    // Navigate to Main after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    _morphController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidianBase,
      body: Stack(
        children: [
          // Ambient Glows
          Positioned(
            top: -180,
            right: -120,
            child: _buildGlowOrb(
              color: AppColors.electricIndigo,
              size: 400,
            ),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: _buildGlowOrb(
              color: AppColors.bioluminescentMint,
              size: 320,
            ),
          ),

          // Central Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    _buildAnimatedLogo(),

                    const SizedBox(height: 40),

                    // App Name
                    const Text(
                      'SocialDetox',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.stardust,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tagline
                    const Text(
                      'Focus on what matters',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom loading indicator
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: _buildLoadingDots(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb({required Color color, required double size}) {
    return AnimatedBuilder(
      animation: _breathController,
      builder: (context, child) {
        return Container(
          width: size * _breathAnimation.value,
          height: size * _breathAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.25),
                color.withValues(alpha: 0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _breathController,
          builder: (context, child) {
            final offset = (index * 0.3) % 1.0;
            final value = math.sin((_breathController.value + offset) * math.pi);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bioluminescentMint.withValues(
                  alpha: 0.3 + (value * 0.5).clamp(0.0, 0.7),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildAnimatedLogo() {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 80px blur glow
          AnimatedBuilder(
            animation: _breathAnimation,
            builder: (context, child) {
              return Container(
                width: 100 * _breathAnimation.value,
                height: 100 * _breathAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.electricIndigo.withValues(alpha: 0.5),
                      blurRadius: 80,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              );
            },
          ),

          // Outer liquid ring
          AnimatedBuilder(
            animation: Listenable.merge([_morphController, _breathAnimation]),
            builder: (context, child) {
              return CustomPaint(
                size: const Size(160, 160),
                painter: _LiquidBlobPainter(
                  morphValue: _morphController.value,
                  scaleValue: _breathAnimation.value,
                  color: AppColors.electricIndigo.withValues(alpha: 0.15),
                ),
              );
            },
          ),

          // Inner liquid ring
          AnimatedBuilder(
            animation: Listenable.merge([_morphController, _breathAnimation]),
            builder: (context, child) {
              return CustomPaint(
                size: const Size(140, 140),
                painter: _LiquidBlobPainter(
                  morphValue: _morphController.value + 0.3,
                  scaleValue: _breathAnimation.value * 0.95,
                  color: AppColors.bioluminescentMint.withValues(alpha: 0.1),
                  invert: true,
                ),
              );
            },
          ),

          // Main logo container
          AnimatedBuilder(
            animation: _breathAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _breathAnimation.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: const Alignment(-0.3, -0.3),
                      radius: 1.0,
                      colors: [
                        AppColors.electricIndigo,
                        AppColors.electricIndigo.withValues(alpha: 0.85),
                        const Color(0xFF3730A3),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricIndigo.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: AppColors.electricIndigo.withValues(alpha: 0.3),
                        blurRadius: 60,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shield_rounded,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LiquidBlobPainter extends CustomPainter {
  final double morphValue;
  final double scaleValue;
  final Color color;
  final bool invert;

  _LiquidBlobPainter({
    required this.morphValue,
    required this.scaleValue,
    required this.color,
    this.invert = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = (size.width / 2) * scaleValue;

    final path = Path();
    const points = 100;
    final direction = invert ? -1.0 : 1.0;

    for (int i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * math.pi;
      
      final wave1 = math.sin(angle * 3 + morphValue * 2 * math.pi * direction) * 3;
      final wave2 = math.sin(angle * 5 - morphValue * 2 * math.pi * 0.7 * direction) * 2;
      final wave3 = math.cos(angle * 2 + morphValue * 2 * math.pi * 0.5 * direction) * 2;
      
      final radiusOffset = wave1 + wave2 + wave3;
      final radius = baseRadius + radiusOffset;

      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidBlobPainter oldDelegate) {
    return morphValue != oldDelegate.morphValue ||
        scaleValue != oldDelegate.scaleValue ||
        color != oldDelegate.color;
  }
}
