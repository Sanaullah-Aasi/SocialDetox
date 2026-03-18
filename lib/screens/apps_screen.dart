import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/detox_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_tile.dart';
import '../widgets/bouncing_card.dart';

/// Project Zenith - Apps Screen
class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Header
          _buildHeader(),

          const SizedBox(height: 20),

          // Search Bar
          _buildSearchBar(),

          const SizedBox(height: 16),

          // Selection Summary
          _buildSelectionSummary(),

          const SizedBox(height: 16),

          // Apps List
          Expanded(
            child: _buildAppsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Select Apps',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.stardust,
              letterSpacing: -0.5,
            ),
          ),
          Consumer<DetoxProvider>(
            builder: (context, provider, _) {
              return PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.stardust,
                    size: 20,
                  ),
                ),
                color: AppColors.zinc800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.cardBorder),
                ),
                onSelected: (value) {
                  HapticFeedback.mediumImpact();
                  if (value == 'select_all') {
                    provider.selectAllApps();
                  } else if (value == 'deselect_all') {
                    provider.deselectAllApps();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'select_all',
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          color: AppColors.coralWarning,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Block All',
                          style: TextStyle(color: AppColors.stardust),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'deselect_all',
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_open_rounded,
                          color: AppColors.bioluminescentMint,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Unblock All',
                          style: TextStyle(color: AppColors.stardust),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.elevatedSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
          style: const TextStyle(color: AppColors.stardust, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search apps...',
            hintStyle: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 15,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionSummary() {
    return Consumer<DetoxProvider>(
      builder: (context, provider, _) {
        return BouncingCard(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          backgroundColor: AppColors.coralWarning.withValues(alpha: 0.08),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.coralWarning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.block_rounded,
                  color: AppColors.coralWarning,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${provider.blockedAppsCount} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.stardust,
                        ),
                      ),
                      TextSpan(
                        text: 'of ${provider.installedApps.length} apps blocked',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.blockedAppsCount > 0)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    provider.deselectAllApps();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bioluminescentMint.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        color: AppColors.bioluminescentMint,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppsList() {
    return Consumer<DetoxProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: AppColors.electricIndigo,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Loading apps...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        final filteredApps = provider.installedApps.where((app) {
          return app.appName.toLowerCase().contains(_searchQuery) ||
              app.packageName.toLowerCase().contains(_searchQuery);
        }).toList();

        if (filteredApps.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.zinc800,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 40,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No apps found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.stardust,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Try a different search term',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 120),
          itemCount: filteredApps.length,
          itemBuilder: (context, index) {
            final app = filteredApps[index];
            return AppTile(
              app: app,
              index: index,
              onTap: () => provider.toggleAppSelection(app.packageName),
            );
          },
        );
      },
    );
  }
}
