import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'package:social_detox_core/social_detox_core.dart';

/// Project Zenith V2 - App Tile with squircle, glass-bevel, and animated glow
class AppTile extends StatefulWidget {
  final AppInfo app;
  final VoidCallback onTap;
  final bool showToggle;
  final int index;

  const AppTile({
    super.key,
    required this.app,
    required this.onTap,
    this.showToggle = true,
    this.index = 0,
  });

  @override
  State<AppTile> createState() => _AppTileState();
}

class _AppTileState extends State<AppTile> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOutSine),
    );

    if (widget.app.isSelected) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AppTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.app.isSelected && !oldWidget.app.isSelected) {
      _glowController.repeat(reverse: true);
    } else if (!widget.app.isSelected && oldWidget.app.isSelected) {
      _glowController.stop();
      _glowController.reset();
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _pressController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isBlocked = widget.app.isSelected;

    // Staggered entrance animation
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (widget.index * 50).clamp(0, 300)),
      curve: Curves.elasticOut,
      builder: (context, entranceValue, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - entranceValue)),
          child: Opacity(
            opacity: entranceValue.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                padding: const EdgeInsets.all(14),
                decoration: ShapeDecoration(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                    side: BorderSide(
                      color: isBlocked
                          ? AppColors.coralWarning.withValues(alpha: 0.5)
                          : AppColors.zinc800,
                      width: isBlocked ? 1.5 : 1,
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
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    if (isBlocked)
                      BoxShadow(
                        color: AppColors.coralWarning.withValues(
                          alpha: _glowAnimation.value * 0.25,
                        ),
                        blurRadius: 16,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Inner bevel
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CustomPaint(
                          painter: _InnerBevelPainter(),
                        ),
                      ),
                    ),
                    // Content
                    Row(
                      children: [
                        _buildAppIcon(isBlocked),
                        const SizedBox(width: 14),
                        _buildAppInfo(isBlocked),
                        if (widget.showToggle) ...[
                          const SizedBox(width: 8),
                          _BlockIndicator(isBlocked: isBlocked),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppIcon(bool isBlocked) {
    return ColorFiltered(
      colorFilter: isBlocked
          ? const ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0, 0, 0, 1, 0,
            ])
          : const ColorFilter.mode(
              Colors.transparent,
              BlendMode.multiply,
            ),
      child: Container(
        width: 48,
        height: 48,
        decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: AppColors.zinc800,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: widget.app.icon != null
              ? Image.memory(widget.app.icon!, fit: BoxFit.cover)
              : const Icon(
                  Icons.android_rounded,
                  color: AppColors.textSecondary,
                  size: 26,
                ),
        ),
      ),
    );
  }

  Widget _buildAppInfo(bool isBlocked) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.app.appName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isBlocked ? AppColors.zinc500 : AppColors.stardust,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            widget.app.packageName,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Inner bevel painter for glass effect
class _InnerBevelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top-left highlight
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.4],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.6, size.height * 0.6),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Animated block indicator with sliding lock icon and glow
class _BlockIndicator extends StatelessWidget {
  final bool isBlocked;

  const _BlockIndicator({required this.isBlocked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      width: 48,
      height: 28,
      decoration: ShapeDecoration(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isBlocked
                ? AppColors.coralWarning.withValues(alpha: 0.5)
                : AppColors.zinc700,
            width: 1,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isBlocked
              ? [
                  AppColors.coralWarning.withValues(alpha: 0.2),
                  AppColors.coralWarning.withValues(alpha: 0.1),
                ]
              : [
                  AppColors.zinc800,
                  AppColors.zinc800.withValues(alpha: 0.9),
                ],
        ),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            left: isBlocked ? 20 : 2,
            top: 2,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isBlocked
                      ? [AppColors.coralWarning, const Color(0xFFDC2626)]
                      : [AppColors.zinc600, AppColors.zinc700],
                ),
                boxShadow: isBlocked
                    ? [
                        BoxShadow(
                          color: AppColors.coralWarning.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isBlocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppTileCompact extends StatelessWidget {
  final AppInfo app;
  final VoidCallback onTap;

  const AppTileCompact({
    super.key,
    required this.app,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBlocked = app.isSelected;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: isBlocked
                  ? AppColors.coralWarning.withValues(alpha: 0.3)
                  : AppColors.zinc800,
            ),
          ),
          color: AppColors.elevatedSurface,
        ),
        child: Row(
          children: [
            ColorFiltered(
              colorFilter: isBlocked
                  ? const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0, 0, 0, 1, 0,
                    ])
                  : const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.multiply,
                    ),
              child: Container(
                width: 40,
                height: 40,
                decoration: ShapeDecoration(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: AppColors.zinc800,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: app.icon != null
                      ? Image.memory(app.icon!, fit: BoxFit.cover)
                      : const Icon(
                          Icons.android_rounded,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                app.appName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isBlocked ? AppColors.zinc500 : AppColors.stardust,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              isBlocked ? Icons.lock_rounded : Icons.lock_open_rounded,
              size: 18,
              color: isBlocked ? AppColors.coralWarning : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
