import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../models/app_info.dart';

/// Project Zenith - App Tile with greyscale filter and lock icon
class AppTile extends StatefulWidget {
  final AppInfo app;
  final VoidCallback onTap;
  final bool showToggle;

  const AppTile({
    super.key,
    required this.app,
    required this.onTap,
    this.showToggle = true,
  });

  @override
  State<AppTile> createState() => _AppTileState();
}

class _AppTileState extends State<AppTile> with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isBlocked = widget.app.isSelected;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          begin: 1.0,
          end: _isPressed ? 0.97 : 1.0,
        ),
        duration: Duration(milliseconds: _isPressed ? 100 : 200),
        curve: Curves.easeOutCubic,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.elevatedSurface,
            border: Border.all(
              color: isBlocked
                  ? AppColors.coralWarning.withValues(alpha: 0.4)
                  : AppColors.cardBorder,
              width: isBlocked ? 1.5 : 1,
            ),
            boxShadow: isBlocked
                ? [
                    BoxShadow(
                      color: AppColors.coralWarning.withValues(alpha: 0.1),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // App Icon with greyscale filter when blocked
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.zinc800,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.app.icon != null
                        ? Image.memory(widget.app.icon!, fit: BoxFit.cover)
                        : const Icon(
                            Icons.android_rounded,
                            color: AppColors.textSecondary,
                            size: 26,
                          ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // App Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.app.appName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isBlocked
                            ? AppColors.textSecondary
                            : AppColors.stardust,
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
              ),

              // Sliding lock icon / checkbox
              if (widget.showToggle) ...[
                const SizedBox(width: 8),
                _BlockIndicator(isBlocked: isBlocked),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated block indicator with sliding lock icon
class _BlockIndicator extends StatelessWidget {
  final bool isBlocked;

  const _BlockIndicator({required this.isBlocked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      width: 44,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isBlocked
            ? AppColors.coralWarning.withValues(alpha: 0.2)
            : AppColors.zinc700,
        border: Border.all(
          color: isBlocked
              ? AppColors.coralWarning.withValues(alpha: 0.5)
              : AppColors.zinc600,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            left: isBlocked ? 18 : 2,
            top: 2,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isBlocked ? AppColors.coralWarning : AppColors.zinc500,
                boxShadow: isBlocked
                    ? [
                        BoxShadow(
                          color: AppColors.coralWarning.withValues(alpha: 0.4),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.elevatedSurface,
          border: Border.all(
            color: isBlocked
                ? AppColors.coralWarning.withValues(alpha: 0.3)
                : AppColors.cardBorder,
          ),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                  color: isBlocked ? AppColors.textSecondary : AppColors.stardust,
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
