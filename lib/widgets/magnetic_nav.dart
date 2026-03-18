import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../theme/app_colors.dart';

/// Project Zenith V2 - Magnetic Navigation Bar
/// Floating squircle capsule with sliding glow indicator and spring physics
class MagneticNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<MagneticNavItem> items;

  const MagneticNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<MagneticNav> createState() => _MagneticNavState();
}

class _MagneticNavState extends State<MagneticNav>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  int _lastIndex = 0;

  @override
  void initState() {
    super.initState();
    _lastIndex = widget.currentIndex;

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.05)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 20,
      ),
    ]).animate(_bounceController);
  }

  @override
  void didUpdateWidget(MagneticNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _lastIndex) {
      _bounceController.forward(from: 0);
      _lastIndex = widget.currentIndex;
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            height: 72,
            decoration: ShapeDecoration(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(56),
                side: BorderSide(
                  color: AppColors.zinc800.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.elevatedSurface.withValues(alpha: 0.85),
                  AppColors.obsidianBase.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Inner bevel effect
                Positioned.fill(
                  child: CustomPaint(
                    painter: _NavBevelPainter(),
                  ),
                ),

                // Sliding glow indicator
                AnimatedAlign(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  alignment: _getIndicatorAlignment(),
                  child: _buildIndicator(),
                ),

                // Nav items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    widget.items.length,
                    (index) => _buildNavItem(index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Alignment _getIndicatorAlignment() {
    final itemCount = widget.items.length;
    final position = (widget.currentIndex / (itemCount - 1)) * 2 - 1;
    return Alignment(position * 0.85, 0);
  }

  Widget _buildIndicator() {
    return Container(
      width: 56,
      height: 40,
      decoration: ShapeDecoration(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bioluminescentMint.withValues(alpha: 0.25),
            AppColors.bioluminescentMint.withValues(alpha: 0.1),
          ],
        ),
        shadows: [
          BoxShadow(
            color: AppColors.bioluminescentMint.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = index == widget.currentIndex;
    final item = widget.items[index];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!isSelected) {
          HapticFeedback.lightImpact();
          widget.onTap(index);
        }
      },
      child: SizedBox(
        width: 64,
        height: 72,
        child: Center(
          child: AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              final scale = isSelected && _bounceController.isAnimating
                  ? _bounceAnimation.value
                  : 1.0;

              return Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon with gradient mask
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isSelected
                            ? [
                                AppColors.bioluminescentMint,
                                const Color(0xFF34D399),
                              ]
                            : [
                                AppColors.zinc500,
                                AppColors.zinc600,
                              ],
                      ).createShader(bounds),
                      child: Icon(
                        isSelected ? item.activeIcon : item.icon,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Label
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.bioluminescentMint
                            : AppColors.zinc500,
                        letterSpacing: 0.3,
                      ),
                      child: Text(item.label),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Nav item data class
class MagneticNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const MagneticNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Inner bevel effect painter
class _NavBevelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top highlight line
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 1));

    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, 1, size.width * 0.8, 1),
      highlightPaint,
    );

    // Bottom shadow line
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.black.withValues(alpha: 0.0),
          Colors.black.withValues(alpha: 0.15),
          Colors.black.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, size.height - 2, size.width, 1));

    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height - 2, size.width * 0.8, 1),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
