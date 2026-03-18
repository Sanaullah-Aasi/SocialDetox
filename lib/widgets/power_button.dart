import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

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
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = AppColors.success;
    final Color inactiveColor = AppColors.primaryPurple;
    final Color currentColor = widget.isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _pulseAnimation,
          _rotateController,
          _scaleAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: widget.size + 60,
              height: widget.size + 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow effect
                  Container(
                    width: widget.size + 40,
                    height: widget.size + 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: currentColor.withValues(
                            alpha: 0.3 + (_pulseAnimation.value * 0.2),
                          ),
                          blurRadius: 40 + (_pulseAnimation.value * 20),
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),

                  // Rotating outer ring
                  Transform.rotate(
                    angle: _rotateController.value * 2 * math.pi,
                    child: CustomPaint(
                      size: Size(widget.size + 30, widget.size + 30),
                      painter: _DashedCirclePainter(
                        color: currentColor.withValues(alpha: 0.3),
                        strokeWidth: 2,
                        dashLength: 8,
                        gapLength: 12,
                      ),
                    ),
                  ),

                  // Second rotating ring (opposite direction)
                  Transform.rotate(
                    angle: -_rotateController.value * 2 * math.pi * 0.7,
                    child: CustomPaint(
                      size: Size(widget.size + 50, widget.size + 50),
                      painter: _DashedCirclePainter(
                        color: currentColor.withValues(alpha: 0.15),
                        strokeWidth: 1,
                        dashLength: 4,
                        gapLength: 8,
                      ),
                    ),
                  ),

                  // Main button
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isActive
                            ? [
                                AppColors.success,
                                AppColors.successLight,
                              ]
                            : [
                                AppColors.primaryPurple,
                                AppColors.primaryCyan,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: currentColor.withValues(alpha: 0.5),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundDark.withValues(alpha: 0.3),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: widget.isLoading
                            ? SizedBox(
                                width: widget.size * 0.3,
                                height: widget.size * 0.3,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Icon(
                                Icons.power_settings_new_rounded,
                                size: widget.size * 0.4,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),

                  // Animated dot indicators
                  if (widget.isActive) ..._buildActiveIndicators(currentColor),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildActiveIndicators(Color color) {
    return List.generate(4, (index) {
      final angle = (index * math.pi / 2) + (_rotateController.value * 2 * math.pi);
      final radius = (widget.size / 2) + 20;
      return Positioned(
        left: (widget.size + 60) / 2 + radius * math.cos(angle) - 4,
        top: (widget.size + 60) / 2 + radius * math.sin(angle) - 4,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color,
                blurRadius: 8,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashLength + gapLength)) / radius;
      final sweepAngle = dashLength / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
