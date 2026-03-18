import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Project Zenith V2 - Breathing Liquid Background
/// Creates a dynamic mesh gradient with oscillating blurred orbs
class LiquidBackground extends StatefulWidget {
  final Widget child;

  const LiquidBackground({
    super.key,
    required this.child,
  });

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Obsidian base
        Container(color: AppColors.obsidianBase),
        
        // Animated liquid orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _LiquidOrbsPainter(
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // Child content
        widget.child,
      ],
    );
  }
}

/// Custom painter that draws massive, blurred, oscillating orbs
class _LiquidOrbsPainter extends CustomPainter {
  final double animationValue;

  _LiquidOrbsPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Orb 1 - Electric Indigo (top-right)
    _drawOrb(
      canvas: canvas,
      size: size,
      baseX: size.width * 0.85,
      baseY: size.height * 0.15,
      radius: size.width * 0.6,
      color: AppColors.electricIndigo,
      alpha: 0.12,
      phaseOffset: 0,
      blurSigma: 120,
    );

    // Orb 2 - Bioluminescent Mint (bottom-left)
    _drawOrb(
      canvas: canvas,
      size: size,
      baseX: size.width * 0.1,
      baseY: size.height * 0.75,
      radius: size.width * 0.5,
      color: AppColors.bioluminescentMint,
      alpha: 0.10,
      phaseOffset: math.pi * 0.67,
      blurSigma: 100,
    );

    // Orb 3 - Coral accent (center)
    _drawOrb(
      canvas: canvas,
      size: size,
      baseX: size.width * 0.5,
      baseY: size.height * 0.45,
      radius: size.width * 0.35,
      color: AppColors.coralWarning,
      alpha: 0.06,
      phaseOffset: math.pi * 1.33,
      blurSigma: 140,
    );
  }

  void _drawOrb({
    required Canvas canvas,
    required Size size,
    required double baseX,
    required double baseY,
    required double radius,
    required Color color,
    required double alpha,
    required double phaseOffset,
    required double blurSigma,
  }) {
    // Calculate oscillating position
    final phase = animationValue * 2 * math.pi + phaseOffset;
    final offsetX = math.sin(phase) * (size.width * 0.08);
    final offsetY = math.cos(phase * 0.7) * (size.height * 0.05);
    
    // Secondary oscillation for more organic movement
    final phase2 = animationValue * 2 * math.pi * 1.3 + phaseOffset;
    final offsetX2 = math.cos(phase2) * (size.width * 0.03);
    final offsetY2 = math.sin(phase2 * 0.8) * (size.height * 0.02);

    final center = Offset(
      baseX + offsetX + offsetX2,
      baseY + offsetY + offsetY2,
    );

    // Breathing radius effect
    final breathingRadius = radius * (1.0 + math.sin(phase * 0.5) * 0.1);

    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

    canvas.drawCircle(center, breathingRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidOrbsPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}

/// A lighter version for performance-sensitive screens
class LiquidBackgroundLite extends StatefulWidget {
  final Widget child;

  const LiquidBackgroundLite({
    super.key,
    required this.child,
  });

  @override
  State<LiquidBackgroundLite> createState() => _LiquidBackgroundLiteState();
}

class _LiquidBackgroundLiteState extends State<LiquidBackgroundLite>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.obsidianBase),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _LiquidOrbsLitePainter(
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _LiquidOrbsLitePainter extends CustomPainter {
  final double animationValue;

  _LiquidOrbsLitePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final phase = animationValue * 2 * math.pi;

    // Single large indigo orb
    final paint = Paint()
      ..color = AppColors.electricIndigo.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 150);

    final offsetX = math.sin(phase) * (size.width * 0.05);
    final offsetY = math.cos(phase * 0.6) * (size.height * 0.03);

    canvas.drawCircle(
      Offset(size.width * 0.7 + offsetX, size.height * 0.2 + offsetY),
      size.width * 0.5,
      paint,
    );

    // Single mint orb
    paint.color = AppColors.bioluminescentMint.withValues(alpha: 0.06);
    
    final offsetX2 = math.cos(phase * 0.8) * (size.width * 0.04);
    final offsetY2 = math.sin(phase * 0.5) * (size.height * 0.025);

    canvas.drawCircle(
      Offset(size.width * 0.2 + offsetX2, size.height * 0.7 + offsetY2),
      size.width * 0.4,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LiquidOrbsLitePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}
