import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/detox_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/bouncing_card.dart';

/// Project Zenith - Stats Screen
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetoxProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header
                _buildHeader(),

                const SizedBox(height: 24),

                // Status Card
                _buildStatusCard(provider),

                const SizedBox(height: 20),

                // Stats Grid
                _buildStatsGrid(provider),

                const SizedBox(height: 24),

                // Activity Section
                _buildActivitySection(),

                const SizedBox(height: 24),

                // Tips Section
                _buildTipsSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Statistics',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.stardust,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildStatusCard(DetoxProvider provider) {
    return BouncingCard(
      backgroundColor: provider.isVpnActive
          ? AppColors.bioluminescentMint.withValues(alpha: 0.1)
          : AppColors.electricIndigo.withValues(alpha: 0.1),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: provider.isVpnActive
                  ? AppColors.bioluminescentMint.withValues(alpha: 0.2)
                  : AppColors.electricIndigo.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              provider.isVpnActive
                  ? Icons.shield_rounded
                  : Icons.shield_outlined,
              color: provider.isVpnActive
                  ? AppColors.bioluminescentMint
                  : AppColors.electricIndigo,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.isVpnActive ? 'Protection Active' : 'Protection Off',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: provider.isVpnActive
                        ? AppColors.bioluminescentMint
                        : AppColors.stardust,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.isVpnActive
                      ? 'Blocking ${provider.blockedAppsCount} apps'
                      : 'Tap power button to start',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: provider.isVpnActive
                  ? AppColors.bioluminescentMint
                  : AppColors.textTertiary,
              boxShadow: provider.isVpnActive
                  ? [
                      BoxShadow(
                        color: AppColors.bioluminescentMint.withValues(alpha: 0.6),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(DetoxProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.block_rounded,
                  value: '${provider.blockedAppsCount}',
                  label: 'Blocked Apps',
                  color: AppColors.coralWarning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  icon: Icons.smartphone_rounded,
                  value: '${provider.installedApps.length}',
                  label: 'Total Apps',
                  color: AppColors.electricIndigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.timer_rounded,
                  value: provider.isVpnActive ? 'Active' : 'Idle',
                  label: 'Current Status',
                  color: provider.isVpnActive
                      ? AppColors.bioluminescentMint
                      : AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  icon: Icons.trending_up_rounded,
                  value: '100%',
                  label: 'Focus Rate',
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.stardust,
            ),
          ),
        ),
        const SizedBox(height: 12),
        BouncingCard(
          child: Column(
            children: [
              _ActivityItem(
                icon: Icons.play_circle_outline_rounded,
                title: 'Session Started',
                subtitle: 'Protection enabled',
                time: 'Now',
                isActive: true,
              ),
              Divider(color: AppColors.cardBorder, height: 20),
              _ActivityItem(
                icon: Icons.add_circle_outline_rounded,
                title: 'Apps Selected',
                subtitle: 'Added apps to block list',
                time: 'Today',
              ),
              Divider(color: AppColors.cardBorder, height: 20),
              _ActivityItem(
                icon: Icons.download_rounded,
                title: 'App Installed',
                subtitle: 'SocialDetox setup complete',
                time: 'Today',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Focus Tips',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.stardust,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _TipCard(
                icon: Icons.notifications_off_rounded,
                title: 'Disable Notifications',
                color: AppColors.electricIndigo,
              ),
              _TipCard(
                icon: Icons.schedule_rounded,
                title: 'Set a Schedule',
                color: AppColors.bioluminescentMint,
              ),
              _TipCard(
                icon: Icons.psychology_rounded,
                title: 'Take Breaks',
                color: AppColors.amber,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatBox({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
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
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isActive;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.bioluminescentMint.withValues(alpha: 0.15)
                : AppColors.zinc800,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isActive ? AppColors.bioluminescentMint : AppColors.textSecondary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.stardust,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.bioluminescentMint.withValues(alpha: 0.15)
                : AppColors.zinc800,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? AppColors.bioluminescentMint : AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.stardust,
            ),
          ),
        ],
      ),
    );
  }
}
