import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/detox_provider.dart';
import '../widgets/app_list_tile.dart';

class AppSelectionScreen extends StatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  State<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Select Apps',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Consumer<DetoxProvider>(
            builder: (context, provider, _) {
              final selectedCount = provider.blockedAppsCount;
              final totalCount = provider.installedApps.length;
              final allSelected = selectedCount == totalCount && totalCount > 0;

              return Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) {
                    if (value == 'select_all') {
                      provider.selectAllApps();
                    } else if (value == 'deselect_all') {
                      provider.deselectAllApps();
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'select_all',
                          enabled: !allSelected,
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_box,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text('Select All', style: GoogleFonts.inter()),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'deselect_all',
                          enabled: selectedCount > 0,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_box_outline_blank,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text('Deselect All', style: GoogleFonts.inter()),
                            ],
                          ),
                        ),
                      ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Background Gradient (Same as Home)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      isDark
                          ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                          : [const Color(0xFFF0FDFA), const Color(0xFFCCFBF1)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged:
                          (value) => setState(
                            () => _searchQuery = value.toLowerCase(),
                          ),
                      decoration: InputDecoration(
                        hintText: 'Search apps...',
                        hintStyle: GoogleFonts.inter(
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                        suffixIcon:
                            _searchQuery.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                                : null,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),

                // Selection summary
                Consumer<DetoxProvider>(
                  builder: (context, provider, _) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.checklist_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${provider.blockedAppsCount} apps selected ',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '(${provider.installedApps.length} total)',
                                    style: GoogleFonts.inter(
                                      color:
                                          isDark
                                              ? Colors.white54
                                              : Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (provider.blockedAppsCount > 0)
                            TextButton(
                              onPressed: provider.deselectAllApps,
                              child: Text(
                                'Clear',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFEF4444),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Apps list
                Expanded(
                  child: Consumer<DetoxProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                        );
                      }

                      final filteredApps =
                          provider.installedApps.where((app) {
                            return app.appName.toLowerCase().contains(
                                  _searchQuery,
                                ) ||
                                app.packageName.toLowerCase().contains(
                                  _searchQuery,
                                );
                          }).toList();

                      if (filteredApps.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No apps found',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredApps.length,
                        itemBuilder: (context, index) {
                          final app = filteredApps[index];
                          return AppListTile(
                            app: app,
                            onTap:
                                () => provider.toggleAppSelection(
                                  app.packageName,
                                ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bottom Done Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Consumer<DetoxProvider>(
              builder: (context, provider, _) {
                final hasSelection = provider.blockedAppsCount > 0;
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        theme.scaffoldBackgroundColor,
                        theme.scaffoldBackgroundColor.withValues(alpha: 0),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    // Ensure button isn't obscured by gesture bar on iOS
                    child: ElevatedButton(
                      onPressed:
                          hasSelection ? () => Navigator.pop(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            hasSelection
                                ? theme.colorScheme.primary
                                : (isDark ? Colors.white10 : Colors.black12),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 22,
                        ), // Taller button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: hasSelection ? 8 : 0,
                        shadowColor: theme.colorScheme.primary.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: hasSelection ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'DONE (${provider.blockedAppsCount})',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                              color: hasSelection ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
