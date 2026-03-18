import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/detox_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

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
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildStatusCard(DetoxProvider provider) {
    return GlassCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: provider.isVpnActive
            ? [
                AppColors.success.withValues(alpha: 0.2),
                AppColors.successLight.withValues(alpha: 0.1),
              ]
            : [
                AppColors.primaryPurple.withValues(alpha: 0.2),
                AppColors.primaryCyan.withValues(alpha: 0.1),
              ],
      ),
      border: Border.all(
        color: provider.isVpnActive
            ? AppColors.success.withValues(alpha: 0.3)
            : AppColors.primaryPurple.withValues(alpha: 0.3),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: provider.isVpnActive
                  ? const LinearGradient(
                      colors: [AppColors.success, AppColors.successLight],
                    )
                  : const LinearGradient(
                      colors: [AppColors.primaryPurple, AppColors.primaryCyan],
                    ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              provider.isVpnActive
                  ? Icons.shield_rounded
                  : Icons.shield_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.isVpnActive ? 'Protection Active' : 'Protection Off',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: provider.isVpnActive
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.isVpnActive
                      ? 'Blocking ${provider.blockedAppsCount} apps'
                      : 'Tap power button to start',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: provider.isVpnActive ? AppColors.success : AppColors.textTertiary,
              boxShadow: provider.isVpnActive
                  ? [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.5),
                        blurRadius: 8,
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
                  icon: Icons.apps_rounded,
                  value: '${provider.blockedAppsCount}',
                  label: 'Blocked Apps',
                  colors: const [AppColors.primaryPurple, AppColors.primaryPurpleLight],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  icon: Icons.smartphone_rounded,
                  value: '${provider.installedApps.length}',
                  label: 'Total Apps',
                  colors: const [AppColors.primaryCyan, AppColors.primaryBlue],
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
                  colors: provider.isVpnActive
                      ? const [AppColors.success, AppColors.successLight]
                      : const [Color(0xFF636E72), Color(0xFF95A5A6)],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  icon: Icons.trending_up_rounded,
                  value: '100%',
                  label: 'Focus Rate',
                  colors: const [AppColors.warning, Color(0xFFFFBE76)],
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            children: [
              _ActivityItem(
                icon: Icons.play_circle_outline_rounded,
                title: 'Session Started',
                subtitle: 'Protection enabled',
                time: 'Now',
                isActive: true,
              ),
              Divider(
                color: Colors.white.withValues(alpha: 0.1),
                height: 24,
              ),
              _ActivityItem(
                icon: Icons.add_circle_outline_rounded,
                title: 'Apps Selected',
                subtitle: 'Added apps to block list',
                time: 'Today',
              ),
              Divider(
                color: Colors.white.withValues(alpha: 0.1),
                height: 24,
              ),
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _TipCard(
                icon: Icons.notifications_off_rounded,
                title: 'Disable Notifications',
                gradient: const [AppColors.primaryPurple, AppColors.primaryCyan],
              ),
              _TipCard(
                icon: Icons.schedule_rounded,
                title: 'Set a Schedule',
                gradient: const [AppColors.success, AppColors.successLight],
              ),
              _TipCard(
                icon: Icons.psychology_rounded,
                title: 'Take Breaks',
                gradient: const [AppColors.warning, Color(0xFFFFBE76)],
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
  final List<Color> colors;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
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
                ? AppColors.success.withValues(alpha: 0.2)
                : AppColors.surfaceGlass,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isActive ? AppColors.success : AppColors.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppColors.success : AppColors.textTertiary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Color> gradient;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradient[0].withValues(alpha: 0.3),
            gradient[1].withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gradient[0].withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
