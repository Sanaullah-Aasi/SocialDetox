import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/detox_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/quantum_power_button.dart';
import '../widgets/bouncing_card.dart';

/// Project Zenith V2 - Home Screen with Quantum Power Button
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetoxProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Header
                _buildHeader(context),

                const SizedBox(height: 48),

                // Power Button
                _buildPowerSection(context, provider),

                const SizedBox(height: 40),

                // Quick Stats
                _buildStatsSection(context, provider),

                const SizedBox(height: 20),

                // Error Banner
                if (provider.errorMessage != null)
                  _buildErrorBanner(context, provider),

                // Blocked Apps Preview
                if (provider.blockedAppsCount > 0)
                  _buildBlockedAppsPreview(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.electricIndigo, AppColors.bioluminescentMint],
              ),
            ),
            child: const Icon(
              Icons.shield_rounded,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'SocialDetox',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.stardust,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerSection(BuildContext context, DetoxProvider provider) {
    return Column(
      children: [
        // Quantum Power Button
        QuantumPowerButton(
          isActive: provider.isVpnActive,
          isLoading: provider.isLoading,
          size: 220,
          onTap: provider.blockedAppsCount == 0
              ? null
              : () {
                  if (provider.isVpnActive) {
                    provider.stopDetox();
                  } else {
                    provider.startDetox();
                  }
                },
        ),

        const SizedBox(height: 28),

        // Status Pill
        _StatusPill(isActive: provider.isVpnActive),

        const SizedBox(height: 12),

        Text(
          provider.isVpnActive
              ? '${provider.blockedAppsCount} apps are being blocked'
              : provider.blockedAppsCount > 0
                  ? '${provider.blockedAppsCount} apps ready to block'
                  : 'Select apps to get started',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, DetoxProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.block_rounded,
              value: '${provider.blockedAppsCount}',
              label: 'Blocked Apps',
              color: AppColors.coralWarning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.verified_user_rounded,
              value: provider.isVpnActive ? 'Active' : 'Ready',
              label: 'Status',
              color: provider.isVpnActive
                  ? AppColors.bioluminescentMint
                  : AppColors.electricIndigo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, DetoxProvider provider) {
    return BouncingCard(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(14),
      backgroundColor: AppColors.coralWarning.withValues(alpha: 0.1),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.coralWarning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.coralWarning,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              provider.errorMessage!,
              style: const TextStyle(
                color: AppColors.coralWarning,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          GestureDetector(
            onTap: provider.clearError,
            child: const Icon(
              Icons.close_rounded,
              size: 20,
              color: AppColors.coralWarning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedAppsPreview(BuildContext context, DetoxProvider provider) {
    final appsToShow = provider.blockedApps.take(3).toList();

    return BouncingCard(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Blocked Apps',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.stardust,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bioluminescentMint.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.bioluminescentMint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...appsToShow.map((app) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.zinc800,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.zinc700,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: app.icon != null
                                ? Image.memory(app.icon!, fit: BoxFit.cover)
                                : const Icon(
                                    Icons.android_rounded,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          app.appName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.stardust,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )),
              if (provider.blockedAppsCount > 3)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.electricIndigo.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.electricIndigo.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    '+${provider.blockedAppsCount - 3}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.electricIndigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Status pill showing protection state
class _StatusPill extends StatelessWidget {
  final bool isActive;

  const _StatusPill({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.bioluminescentMint.withValues(alpha: 0.15)
            : AppColors.zinc800,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: isActive
              ? AppColors.bioluminescentMint.withValues(alpha: 0.4)
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.bioluminescentMint : AppColors.textTertiary,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.bioluminescentMint.withValues(alpha: 0.6),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            isActive ? 'Protection Active' : 'Tap to Protect',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.bioluminescentMint : AppColors.stardust,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.stardust,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
