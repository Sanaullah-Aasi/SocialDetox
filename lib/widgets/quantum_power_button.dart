import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Project Zenith V2 - Quantum Core Power Button
/// Morphing liquid blob with sine/cosine vertex displacement
class QuantumPowerButton extends StatefulWidget {
  final bool isActive;
  final bool isLoading;
  final VoidCallback? onTap;
  final double size;

  const QuantumPowerButton({
    super.key,
    required this.isActive,
    this.isLoading = false,
    this.onTap,
    this.size = 200,
  });

  @override
  State<QuantumPowerButton> createState() => _QuantumPowerButtonState();
}

class _QuantumPowerButtonState extends State<QuantumPowerButton>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _breathController;
  late AnimationController _tapController;
  late Animation<double> _tapAnimation;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();

    // Morph animation for liquid blob vertices
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Breathing pulse
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOutSine),
    );

    // Tap scale with spring
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _tapAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.85)
            .chain(CurveTween(curve: Curves.easeOutExpo)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.08)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30,
      ),
    ]).animate(_tapController);
  }

  @override
  void dispose() {
    _morphController.dispose();
    _breathController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isLoading) return;
    HapticFeedback.heavyImpact();
    _tapController.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.size * 0.6;
    final glowColor = widget.isActive
        ? AppColors.bioluminescentMint
        : AppColors.electricIndigo;

    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _morphController,
            _breathAnimation,
            _tapAnimation,
          ]),
          builder: (context, child) {
            final scale = _breathAnimation.value *
                (_tapController.isAnimating ? _tapAnimation.value : 1.0);

            return Transform.scale(
              scale: scale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Multi-layered glow shadows (80, 40, 20 blur)
                  _buildGlowLayer(buttonSize, glowColor, 80, 0.25),
                  _buildGlowLayer(buttonSize, glowColor, 40, 0.35),
                  _buildGlowLayer(buttonSize, glowColor, 20, 0.45),

                  // Main quantum button
                  CustomPaint(
                    size: Size(buttonSize, buttonSize),
                    painter: _QuantumBlobPainter(
                      morphValue: _morphController.value,
                      isActive: widget.isActive,
                      glowColor: glowColor,
                    ),
                  ),

                  // Icon overlay
                  widget.isLoading
                      ? SizedBox(
                          width: buttonSize * 0.35,
                          height: buttonSize * 0.35,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.white.withValues(alpha: 0.85),
                            ],
                          ).createShader(bounds),
                          child: Icon(
                            Icons.power_settings_new_rounded,
                            size: buttonSize * 0.38,
                            color: Colors.white,
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGlowLayer(double size, Color color, double blur, double alpha) {
    return Container(
      width: size * 0.9,
      height: size * 0.9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: alpha),
            blurRadius: blur,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the morphing quantum blob
class _QuantumBlobPainter extends CustomPainter {
  final double morphValue;
  final bool isActive;
  final Color glowColor;

  _QuantumBlobPainter({
    required this.morphValue,
    required this.isActive,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 - 4;

    // Create the blob path
    final path = _createBlobPath(center, baseRadius);

    // Gradient fill
    final gradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 1.2,
      colors: isActive
          ? [
              AppColors.bioluminescentMint,
              AppColors.bioluminescentMint.withValues(alpha: 0.85),
              const Color(0xFF059669),
            ]
          : [
              AppColors.electricIndigo,
              AppColors.electricIndigo.withValues(alpha: 0.9),
              const Color(0xFF3730A3),
            ],
      stops: const [0.0, 0.6, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: baseRadius),
      );

    canvas.drawPath(path, paint);

    // Inner bevel highlight (top-left)
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Draw partial arc for highlight
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: baseRadius - 3),
      -math.pi * 0.75,
      math.pi * 0.5,
      false,
      highlightPaint,
    );

    // Inner shadow (bottom-right)
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: baseRadius - 3),
      math.pi * 0.25,
      math.pi * 0.5,
      false,
      shadowPaint,
    );
  }

  Path _createBlobPath(Offset center, double baseRadius) {
    final path = Path();
    const points = 64;
    final phase = morphValue * 2 * math.pi;

    // Morph intensity based on active state
    final morphIntensity = isActive ? 8.0 : 3.0;

    for (int i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * math.pi;

      // Multiple wave frequencies for organic blob shape
      double radiusOffset = 0;
      if (isActive) {
        radiusOffset += math.sin(angle * 3 + phase) * morphIntensity;
        radiusOffset += math.sin(angle * 5 - phase * 0.7) * (morphIntensity * 0.5);
        radiusOffset += math.cos(angle * 2 + phase * 0.5) * (morphIntensity * 0.3);
        radiusOffset += math.sin(angle * 7 + phase * 1.2) * (morphIntensity * 0.2);
      } else {
        // Subtle breathing for inactive state
        radiusOffset = math.sin(angle * 4 + phase * 0.3) * morphIntensity;
      }

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
    return path;
  }

  @override
  bool shouldRepaint(covariant _QuantumBlobPainter oldDelegate) {
    return morphValue != oldDelegate.morphValue ||
        isActive != oldDelegate.isActive;
  }
}
