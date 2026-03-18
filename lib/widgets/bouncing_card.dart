import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Project Zenith V2 - BouncingCard
/// A tactile, spring-physics card with squircle shape and glass bevel
class BouncingCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool enabled;

  const BouncingCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 32,
    this.backgroundColor,
    this.onTap,
    this.enabled = true,
  });

  @override
  State<BouncingCard> createState() => _BouncingCardState();
}

class _BouncingCardState extends State<BouncingCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    setState(() => _isPressed = false);
    if (widget.onTap != null) {
      HapticFeedback.mediumImpact();
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    if (!widget.enabled) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          begin: 1.0,
          end: _isPressed ? 0.97 : 1.0,
        ),
        duration: Duration(milliseconds: _isPressed ? 150 : 300),
        curve: _isPressed ? Curves.easeOutBack : Curves.elasticOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          margin: widget.margin ?? const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          padding: widget.padding ?? const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              side: BorderSide(
                color: AppColors.zinc800,
                width: 1,
              ),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.backgroundColor ?? AppColors.elevatedSurface,
                (widget.backgroundColor ?? AppColors.elevatedSurface)
                    .withValues(alpha: 0.95),
              ],
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Inner bevel
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius * 0.75),
                  child: CustomPaint(
                    painter: _CardBevelPainter(),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Inner bevel painter
class _CardBevelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top-left highlight
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.04),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.35],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.5, size.height * 0.5),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A variant with gradient border for highlighted states
class BouncingCardHighlight extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final bool isHighlighted;
  final Color highlightColor;
  final VoidCallback? onTap;

  const BouncingCardHighlight({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 32,
    this.isHighlighted = false,
    this.highlightColor = AppColors.bioluminescentMint,
    this.onTap,
  });

  @override
  State<BouncingCardHighlight> createState() => _BouncingCardHighlightState();
}

class _BouncingCardHighlightState extends State<BouncingCardHighlight>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _glowAnimation = Tween<double>(begin: 0.15, end: 0.35).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOutSine),
    );
    if (widget.isHighlighted) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(BouncingCardHighlight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted && !oldWidget.isHighlighted) {
      _glowController.repeat(reverse: true);
    } else if (!widget.isHighlighted && oldWidget.isHighlighted) {
      _glowController.stop();
      _glowController.reset();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    if (widget.onTap != null) {
      HapticFeedback.mediumImpact();
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          begin: 1.0,
          end: _isPressed ? 0.97 : 1.0,
        ),
        duration: Duration(milliseconds: _isPressed ? 150 : 300),
        curve: _isPressed ? Curves.easeOutBack : Curves.elasticOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              margin: widget.margin ?? const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              padding: widget.padding ?? const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  side: BorderSide(
                    color: widget.isHighlighted
                        ? widget.highlightColor.withValues(alpha: 0.5)
                        : AppColors.zinc800,
                    width: widget.isHighlighted ? 1.5 : 1,
                  ),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.elevatedSurface,
                    AppColors.elevatedSurface.withValues(alpha: 0.95),
                  ],
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  if (widget.isHighlighted)
                    BoxShadow(
                      color: widget.highlightColor.withValues(
                        alpha: _glowAnimation.value,
                      ),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
