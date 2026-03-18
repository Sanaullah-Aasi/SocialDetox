import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_info.dart';

class AppListTile extends StatelessWidget {
  final AppInfo app;
  final VoidCallback onTap;

  const AppListTile({super.key, required this.app, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  app.isSelected
                      ? primaryColor.withValues(alpha: isDark ? 0.15 : 0.08)
                      : theme.cardTheme.color,
              border: Border.all(
                color:
                    app.isSelected
                        ? primaryColor.withValues(alpha: 0.5)
                        : isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                width: app.isSelected ? 1.5 : 1,
              ),
              boxShadow: [
                if (!isDark && !app.isSelected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: Row(
              children: [
                // App icon with gradient border when selected
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient:
                        app.isSelected
                            ? LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            )
                            : null,
                    color:
                        app.isSelected
                            ? null
                            : (isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFF1F5F9)),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child:
                          app.icon != null
                              ? Image.memory(app.icon!, fit: BoxFit.cover)
                              : Icon(
                                Icons.android,
                                size: 28,
                                color: primaryColor,
                              ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // App info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.appName,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        app.packageName,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color:
                              isDark
                                  ? Colors.white.withValues(alpha: 0.45)
                                  : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Custom checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient:
                        app.isSelected
                            ? LinearGradient(
                              colors: [primaryColor, secondaryColor],
                            )
                            : null,
                    border:
                        app.isSelected
                            ? null
                            : Border.all(
                              color:
                                  isDark
                                      ? Colors.white.withValues(alpha: 0.25)
                                      : const Color(0xFFCBD5E1),
                              width: 2,
                            ),
                  ),
                  child:
                      app.isSelected
                          ? const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                          : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
