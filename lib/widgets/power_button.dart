import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Project Zenith - Liquid Core Power Button
/// A breathing, organic blob with 80px blur shadow
class PowerButton extends StatefulWidget {
  final bool isActive;
  final bool isLoading;
  final VoidCallback? onTap;
  final double size;

  const PowerButton({
    super.key,
    required this.isActive,
    this.isLoading = false,
    this.onTap,
    this.size = 200,
  });

  @override
  State<PowerButton> createState() => _PowerButtonState();
}

class _PowerButtonState extends State<PowerButton>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _morphController;
  late AnimationController _tapController;
  late Animation<double> _breathAnimation;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();

    // Breathing animation - slow organic pulse
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _breathAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Morph animation for blob effect
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Tap scale animation
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _tapAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _tapController,
        curve: Curves.easeOutCubic,
      ),
    );

    _breathController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _morphController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _tapController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _tapController.reverse();
    if (!widget.isLoading && widget.onTap != null) {
      HapticFeedback.heavyImpact();
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    _tapController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.size * 0.65;
    final glowColor = widget.isActive
        ? AppColors.bioluminescentMint
        : AppColors.electricIndigo;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 80px blur shadow layer
          AnimatedBuilder(
            animation: _breathAnimation,
            builder: (context, child) {
              return Container(
                width: buttonSize * _breathAnimation.value,
                height: buttonSize * _breathAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: widget.isActive ? 0.6 : 0.4),
                      blurRadius: 80,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              );
            },
          ),

          // Liquid blob outer ring
          AnimatedBuilder(
            animation: Listenable.merge([_morphController, _breathAnimation]),
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _LiquidBlobPainter(
                  morphValue: _morphController.value,
                  scaleValue: _breathAnimation.value,
                  color: glowColor.withValues(alpha: 0.15),
                  isActive: widget.isActive,
                ),
              );
            },
          ),

          // Inner liquid ring
          AnimatedBuilder(
            animation: Listenable.merge([_morphController, _breathAnimation]),
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size * 0.85, widget.size * 0.85),
                painter: _LiquidBlobPainter(
                  morphValue: _morphController.value + 0.25,
                  scaleValue: _breathAnimation.value * 0.98,
                  color: glowColor.withValues(alpha: 0.1),
                  isActive: widget.isActive,
                  invert: true,
                ),
              );
            },
          ),

          // Main button
          GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: AnimatedBuilder(
              animation: Listenable.merge([_breathAnimation, _tapAnimation]),
              builder: (context, child) {
                final scale = _breathAnimation.value * _tapAnimation.value;
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.3, -0.3),
                    radius: 1.0,
                    colors: widget.isActive
                        ? [
                            AppColors.bioluminescentMint,
                            AppColors.bioluminescentMint.withValues(alpha: 0.8),
                            const Color(0xFF059669),
                          ]
                        : [
                            AppColors.electricIndigo,
                            AppColors.electricIndigo.withValues(alpha: 0.85),
                            const Color(0xFF3730A3),
                          ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.3),
                      blurRadius: 60,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: buttonSize * 0.3,
                          height: buttonSize * 0.3,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          Icons.power_settings_new_rounded,
                          size: buttonSize * 0.4,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for liquid blob effect
class _LiquidBlobPainter extends CustomPainter {
  final double morphValue;
  final double scaleValue;
  final Color color;
  final bool isActive;
  final bool invert;

  _LiquidBlobPainter({
    required this.morphValue,
    required this.scaleValue,
    required this.color,
    required this.isActive,
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
    const points = 120;
    final direction = invert ? -1.0 : 1.0;

    for (int i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * math.pi;
      
      // Multiple sine waves for organic feel
      final wave1 = math.sin(angle * 3 + morphValue * 2 * math.pi * direction) * 4;
      final wave2 = math.sin(angle * 5 - morphValue * 2 * math.pi * 0.7 * direction) * 2;
      final wave3 = math.cos(angle * 2 + morphValue * 2 * math.pi * 0.5 * direction) * 3;
      
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
        color != oldDelegate.color ||
        isActive != oldDelegate.isActive;
  }
}
