import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/subscription_provider.dart';
import 'bouncing_card.dart';

/// Project Zenith - Premium Paywall Bottom Sheet
/// Displays when free users hit the 3-app limit
class ZenithPaywall extends StatelessWidget {
  const ZenithPaywall({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ZenithPaywall(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const ShapeDecoration(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(64),
            topRight: Radius.circular(64),
          ),
        ),
        color: AppColors.obsidianBase,
      ),
      child: Stack(
        children: [
          // Inner bevel
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(48),
                  topRight: Radius.circular(48),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.zinc700,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Glowing icon
                  _buildGlowingIcon(),

                  const SizedBox(height: 32),

                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.stardust,
                        AppColors.zinc400,
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'Unlock Absolute Focus',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  Text(
                    'Free users are limited to 3 apps.\nUpgrade to Pro to lock down your entire digital life.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.zinc400,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Features list
                  _buildFeaturesList(),

                  const SizedBox(height: 40),

                  // CTA Button
                  _buildUpgradeButton(context),

                  const SizedBox(height: 16),

                  // Restore purchases
                  _buildRestoreButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 100,
            height: 100,
            decoration: ShapeDecoration(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.electricIndigo,
                  AppColors.bioluminescentMint,
                ],
              ),
              shadows: [
                BoxShadow(
                  color: AppColors.bioluminescentMint.withValues(alpha: 0.4),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.electricIndigo.withValues(alpha: 0.3),
                  blurRadius: 60,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: [
        _buildFeature(Icons.apps_rounded, 'Block unlimited apps'),
        const SizedBox(height: 16),
        _buildFeature(Icons.shield_rounded, 'Premium protection'),
        const SizedBox(height: 16),
        _buildFeature(Icons.trending_up_rounded, 'Advanced analytics'),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: AppColors.bioluminescentMint.withValues(alpha: 0.1),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.bioluminescentMint,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.stardust,
            ),
          ),
        ),
        Icon(
          Icons.check_circle_rounded,
          color: AppColors.bioluminescentMint,
          size: 24,
        ),
      ],
    );
  }

  Widget _buildUpgradeButton(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subProvider, child) {
        return GestureDetector(
          onTap: () async {
            HapticFeedback.heavyImpact();
            await subProvider.purchasePro();
            if (context.mounted && subProvider.isPro) {
              Navigator.pop(context);
            }
          },
          child: BouncingCard(
            margin: EdgeInsets.zero,
            borderRadius: 40,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: ShapeDecoration(
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.bioluminescentMint,
                    Color(0xFF059669),
                  ],
                ),
                shadows: [
                  BoxShadow(
                    color: AppColors.bioluminescentMint.withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: subProvider.isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : const Text(
                      'Upgrade to Pro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRestoreButton(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subProvider, child) {
        return TextButton(
          onPressed: subProvider.isLoading
              ? null
              : () async {
                  HapticFeedback.lightImpact();
                  await subProvider.restorePurchases();
                  if (context.mounted && subProvider.isPro) {
                    Navigator.pop(context);
                  }
                },
          child: Text(
            'Restore Purchases',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.zinc500,
            ),
          ),
        );
      },
    );
  }
}
