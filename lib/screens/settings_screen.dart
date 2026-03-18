import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/detox_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/bouncing_card.dart';

/// Project Zenith - Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

            // Profile Card
            _buildProfileCard(),

            const SizedBox(height: 24),

            // Data Section
            _buildSectionTitle('Data Management'),
            _buildDataSection(context),

            const SizedBox(height: 24),

            // About Section
            _buildSectionTitle('About'),
            _buildAboutSection(context),

            const SizedBox(height: 24),

            // Testing Section
            _buildSectionTitle('Testing'),
            _buildTestingSection(context),

            const SizedBox(height: 24),

            // Disclaimer
            _buildDisclaimer(),

            const SizedBox(height: 24),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Settings',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.stardust,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return BouncingCard(
      backgroundColor: AppColors.electricIndigo.withValues(alpha: 0.15),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.electricIndigo, AppColors.bioluminescentMint],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SocialDetox User',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.stardust,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Premium Features Unlocked',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bioluminescentMint.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.bioluminescentMint.withValues(alpha: 0.4),
              ),
            ),
            child: const Text(
              'PRO',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.bioluminescentMint,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return BouncingCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Consumer<DetoxProvider>(
            builder: (context, provider, _) {
              return _SettingsTile(
                icon: Icons.delete_outline_rounded,
                iconColor: AppColors.coralWarning,
                title: 'Clear all selections',
                subtitle: '${provider.blockedAppsCount} apps blocked',
                onTap: () => _showClearConfirmation(context, provider),
              );
            },
          ),
          Divider(color: AppColors.cardBorder, height: 1, indent: 56),
          _SettingsTile(
            icon: Icons.refresh_rounded,
            iconColor: AppColors.bioluminescentMint,
            title: 'Reload apps',
            subtitle: 'Re-scan installed applications',
            onTap: () async {
              HapticFeedback.mediumImpact();
              final provider = context.read<DetoxProvider>();
              await provider.loadInstalledApps();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.bioluminescentMint.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: AppColors.bioluminescentMint,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('App list refreshed'),
                      ],
                    ),
                    backgroundColor: AppColors.zinc800,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return BouncingCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.tag_rounded,
            iconColor: AppColors.electricIndigo,
            title: 'Version',
            subtitle: '1.0.0',
          ),
          Divider(color: AppColors.cardBorder, height: 1, indent: 56),
          _SettingsTile(
            icon: Icons.shield_outlined,
            iconColor: AppColors.bioluminescentMint,
            title: 'How it works',
            subtitle: 'Learn about VPN-based blocking',
            onTap: () => _showHowItWorksDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTestingSection(BuildContext context) {
    return BouncingCard(
      padding: EdgeInsets.zero,
      child: _SettingsTile(
        icon: Icons.bug_report_outlined,
        iconColor: AppColors.amber,
        title: 'Test blocking',
        subtitle: 'Verify functionality',
        onTap: () => _showTestInstructions(context),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return BouncingCard(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      backgroundColor: AppColors.electricIndigo.withValues(alpha: 0.08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.electricIndigo.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: AppColors.electricIndigo,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'This app uses Android VPN API to block traffic locally. No data is sent to external servers.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Made with ',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          const Icon(
            Icons.favorite,
            size: 14,
            color: AppColors.coralWarning,
          ),
          const Text(
            ' for your focus',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _showHowItWorksDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.zinc800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.cardBorder),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.electricIndigo, AppColors.bioluminescentMint],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            const Text(
              'How It Works',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.stardust,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStepItem('1', 'Creates a local VPN interface'),
            _buildStepItem('2', 'Routes blocked app traffic to VPN'),
            _buildStepItem('3', 'Drops packets from blocked apps'),
            _buildStepItem('4', 'Other apps bypass the filter'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bioluminescentMint.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.bioluminescentMint.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, color: AppColors.bioluminescentMint, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'All blocking happens locally.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.bioluminescentMint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.electricIndigo.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.electricIndigo,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTestInstructions(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.zinc800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.cardBorder),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.science, color: AppColors.amber, size: 18),
            ),
            const SizedBox(width: 12),
            const Text(
              'Test Blocking',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.stardust,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStepItem('1', 'Select an app to block'),
            _buildStepItem('2', 'Start detox mode'),
            _buildStepItem('3', 'Open the blocked app'),
            _buildStepItem('4', 'Verify it can\'t load content'),
            _buildStepItem('5', 'Check non-blocked apps work'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.bioluminescentMint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context, DetoxProvider provider) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.zinc800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.cardBorder),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.coralWarning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.coralWarning,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Clear All?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.stardust,
              ),
            ),
          ],
        ),
        content: Text(
          'This will unblock all ${provider.blockedAppsCount} apps from your block list.',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textTertiary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              provider.clearAllSelections();
              Navigator.pop(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.bioluminescentMint.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: AppColors.bioluminescentMint,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('All apps unblocked'),
                      ],
                    ),
                    backgroundColor: AppColors.zinc800,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coralWarning,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Clear All',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onTap!();
            }
          : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _isPressed ? AppColors.zinc700.withValues(alpha: 0.5) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.stardust,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
