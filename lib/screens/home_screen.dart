import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/detox_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/power_button.dart';
import '../widgets/glass_card.dart';

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

                const SizedBox(height: 40),

                // Power Button
                _buildPowerSection(context, provider),

                const SizedBox(height: 40),

                // Quick Stats
                _buildStatsSection(context, provider),

                const SizedBox(height: 24),

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
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.primaryPurple, AppColors.primaryCyan],
            ).createShader(bounds),
            child: const Icon(
              Icons.shield_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'SocialDetox',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerSection(BuildContext context, DetoxProvider provider) {
    return Column(
      children: [
        // Power Button
        PowerButton(
          isActive: provider.isVpnActive,
          isLoading: provider.isLoading,
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

        const SizedBox(height: 24),

        // Status Text
        Text(
          provider.isVpnActive ? 'Protection Active' : 'Tap to Protect',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: provider.isVpnActive
                ? AppColors.success
                : AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          provider.isVpnActive
              ? '${provider.blockedAppsCount} apps are being blocked'
              : provider.blockedAppsCount > 0
                  ? '${provider.blockedAppsCount} apps ready to block'
                  : 'Select apps to get started',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
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
              icon: Icons.apps_rounded,
              value: '${provider.blockedAppsCount}',
              label: 'Blocked Apps',
              gradient: const [AppColors.primaryPurple, AppColors.primaryPurpleLight],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.access_time_rounded,
              value: provider.isVpnActive ? 'Active' : 'Ready',
              label: 'Status',
              gradient: provider.isVpnActive
                  ? const [AppColors.success, AppColors.successLight]
                  : const [AppColors.primaryCyan, AppColors.primaryBlue],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, DetoxProvider provider) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      border: Border.all(
        color: AppColors.error.withValues(alpha: 0.3),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              provider.errorMessage!,
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: AppColors.error),
            onPressed: provider.clearError,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedAppsPreview(BuildContext context, DetoxProvider provider) {
    final appsToShow = provider.blockedApps.take(3).toList();

    return GlassCard(
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'View all →',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryCyan,
                  fontWeight: FontWeight.w500,
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
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlass,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.backgroundDarkSecondary,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: app.icon != null
                                ? Image.memory(app.icon!, fit: BoxFit.cover)
                                : const Icon(
                                    Icons.android_rounded,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          app.appName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  )),
              if (provider.blockedAppsCount > 3)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryPurple, AppColors.primaryCyan],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${provider.blockedAppsCount - 3} more',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final List<Color> gradient;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
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
