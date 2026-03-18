import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Project Zenith V2 - Premium App Tile
/// ContinuousRectangleBorder squircle with glass-bevel and animated glow
class PremiumAppTile extends StatefulWidget {
  final String appName;
  final IconData icon;
  final bool isBlocked;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PremiumAppTile({
    super.key,
    required this.appName,
    required this.icon,
    this.isBlocked = false,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<PremiumAppTile> createState() => _PremiumAppTileState();
}

class _PremiumAppTileState extends State<PremiumAppTile>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pressController;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Glow pulse for selected state
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _glowAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOutSine),
    );

    if (widget.isSelected) {
      _glowController.repeat(reverse: true);
    }

    // Press animation
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(PremiumAppTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _glowController.repeat(reverse: true);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _glowController.stop();
      _glowController.reset();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _pressController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildTile(),
        );
      },
    );
  }

  Widget _buildTile() {
    final borderColor = widget.isSelected
        ? AppColors.bioluminescentMint
        : widget.isBlocked
            ? AppColors.coralWarning.withValues(alpha: 0.5)
            : AppColors.zinc800;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        widget.onLongPress?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(
              color: borderColor,
              width: widget.isSelected ? 1.5 : 1,
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
            // Main shadow
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            // Selected glow
            if (widget.isSelected)
              BoxShadow(
                color: AppColors.bioluminescentMint
                    .withValues(alpha: _glowAnimation.value * 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Stack(
          children: [
            // Inner bevel layers
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CustomPaint(
                  painter: _InnerBevelPainter(),
                ),
              ),
            ),

            // Main content
            Row(
              children: [
                // Icon with gradient mask
                _buildIcon(),
                const SizedBox(width: 14),

                // App name
                Expanded(
                  child: Text(
                    widget.appName,
                    style: TextStyle(
                      color: widget.isBlocked
                          ? AppColors.zinc500
                          : AppColors.stardust,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Status indicator
                _buildStatusIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: ShapeDecoration(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        gradient: widget.isBlocked
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.isSelected
                    ? [
                        AppColors.bioluminescentMint.withValues(alpha: 0.2),
                        AppColors.bioluminescentMint.withValues(alpha: 0.1),
                      ]
                    : [
                        AppColors.electricIndigo.withValues(alpha: 0.2),
                        AppColors.electricIndigo.withValues(alpha: 0.1),
                      ],
              ),
        color: widget.isBlocked ? AppColors.zinc800 : null,
      ),
      child: Center(
        child: ColorFiltered(
          colorFilter: widget.isBlocked
              ? const ColorFilter.mode(
                  AppColors.zinc500,
                  BlendMode.srcIn,
                )
              : const ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.dst,
                ),
          child: ShaderMask(
            shaderCallback: widget.isBlocked
                ? (bounds) => LinearGradient(
                      colors: [AppColors.zinc500, AppColors.zinc500],
                    ).createShader(bounds)
                : (bounds) => LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isSelected
                          ? [
                              AppColors.bioluminescentMint,
                              const Color(0xFF059669),
                            ]
                          : [
                              AppColors.electricIndigo,
                              const Color(0xFF818CF8),
                            ],
                    ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Icon(
              widget.icon,
              size: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    if (widget.isBlocked) {
      // Animated lock pill
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        tween: Tween(begin: 0, end: 1),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: ShapeDecoration(
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.coralWarning.withValues(alpha: 0.2),
                    AppColors.coralWarning.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 14,
                    color: AppColors.coralWarning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Blocked',
                    style: TextStyle(
                      color: AppColors.coralWarning,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    if (widget.isSelected) {
      // Glowing selection indicator
      return AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.bioluminescentMint,
                  const Color(0xFF059669),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.bioluminescentMint
                      .withValues(alpha: _glowAnimation.value * 0.5),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 16,
              color: Colors.white,
            ),
          );
        },
      );
    }

    // Default: empty toggle area
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.zinc700,
          width: 2,
        ),
      ),
    );
  }
}

/// Draws subtle inner bevel highlights
class _InnerBevelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top-left highlight
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.06),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * 0.5, size.height * 0.5),
      highlightPaint,
    );

    // Bottom-right shadow
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.black.withValues(alpha: 0.0),
          Colors.black.withValues(alpha: 0.08),
        ],
        stops: const [0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(
          size.width * 0.5, size.height * 0.5, size.width * 0.5, size.height * 0.5),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
