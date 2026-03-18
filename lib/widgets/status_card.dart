import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class StatusCard extends StatefulWidget {
  final bool isActive;
  final int blockedAppsCount;

  const StatusCard({
    super.key,
    required this.isActive,
    required this.blockedAppsCount,
  });

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(begin: 2.0, end: 15.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dynamic Colors based on State
    final activeColor = const Color(0xFFEF4444); // Red/Orange for Active
    final activeGradient = [const Color(0xFFEF4444), const Color(0xFFF97316)];

    final inactiveColor = const Color(0xFF0D9488); // Teal used in main theme
    final inactiveGradient = [const Color(0xFF2DD4BF), const Color(0xFF06B6D4)];

    final currentColor = widget.isActive ? activeColor : inactiveColor;
    final currentGradient = widget.isActive ? activeGradient : inactiveGradient;

    return Container(
      margin: const EdgeInsets.all(24),
      constraints: const BoxConstraints(minHeight: 260),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Ambient Glow / Aura
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      currentColor.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.2, 1.0],
                  ),
                ),
              );
            },
          ),

          // 2. Rotating Rings (Cybernetic feel)
          AnimatedBuilder(
            animation: _rotateController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: currentColor.withValues(alpha: 0.1),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 110,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: currentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: currentColor, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // 3. Main Glass Card
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.surface.withValues(alpha: 0.4),
                      theme.colorScheme.surface.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Container with Pulse
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors:
                                  currentGradient
                                      .map((c) => c.withValues(alpha: 0.2))
                                      .toList(),
                            ),
                            border: Border.all(
                              color: currentColor.withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: currentColor.withValues(alpha: 0.3),
                                blurRadius: _glowAnimation.value,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.isActive
                                ? Icons.lock_outline_rounded
                                : Icons.shield_outlined,
                            size: 40,
                            color: isDark ? Colors.white : currentColor,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Status Text
                    Text(
                      widget.isActive ? 'DETOX ACTIVE' : 'PROTECTION READY',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Detail Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: currentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: currentColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        widget.isActive
                            ? '${widget.blockedAppsCount} Apps Blocked'
                            : 'Tap to start session',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? Colors.white70 : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
