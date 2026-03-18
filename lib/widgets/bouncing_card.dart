import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Project Zenith - BouncingCard
/// A tactile, spring-physics card with haptic feedback
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
    this.borderRadius = 16,
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
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.elevatedSurface,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
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
    this.borderRadius = 16,
    this.isHighlighted = false,
    this.highlightColor = AppColors.bioluminescentMint,
    this.onTap,
  });

  @override
  State<BouncingCardHighlight> createState() => _BouncingCardHighlightState();
}

class _BouncingCardHighlightState extends State<BouncingCardHighlight> {
  bool _isPressed = false;

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: widget.margin ?? const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          padding: widget.padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.elevatedSurface,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.isHighlighted
                  ? widget.highlightColor.withValues(alpha: 0.5)
                  : AppColors.cardBorder,
              width: widget.isHighlighted ? 1.5 : 1,
            ),
            boxShadow: widget.isHighlighted
                ? [
                    BoxShadow(
                      color: widget.highlightColor.withValues(alpha: 0.15),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
