import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/app_info.dart';

class AppTile extends StatelessWidget {
  final AppInfo app;
  final VoidCallback onTap;
  final bool showToggle;

  const AppTile({
    super.key,
    required this.app,
    required this.onTap,
    this.showToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: app.isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryPurple.withValues(alpha: 0.2),
                    AppColors.primaryCyan.withValues(alpha: 0.1),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                ),
          border: Border.all(
            color: app.isSelected
                ? AppColors.primaryPurple.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
            width: app.isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // App Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: app.isSelected
                    ? const LinearGradient(
                        colors: [AppColors.primaryPurple, AppColors.primaryCyan],
                      )
                    : null,
                color: app.isSelected ? null : AppColors.surfaceGlass,
              ),
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.backgroundDarkSecondary,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: app.icon != null
                      ? Image.memory(app.icon!, fit: BoxFit.cover)
                      : const Icon(
                          Icons.android_rounded,
                          color: AppColors.textSecondary,
                          size: 28,
                        ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // App Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.appName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    app.packageName,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Toggle/Checkbox
            if (showToggle)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: app.isSelected
                      ? const LinearGradient(
                          colors: [AppColors.primaryPurple, AppColors.primaryCyan],
                        )
                      : null,
                  border: app.isSelected
                      ? null
                      : Border.all(
                          color: AppColors.textTertiary,
                          width: 2,
                        ),
                ),
                child: app.isSelected
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
    );
  }
}

class AppTileCompact extends StatelessWidget {
  final AppInfo app;
  final VoidCallback onTap;

  const AppTileCompact({
    super.key,
    required this.app,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surfaceGlass,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.backgroundDarkSecondary,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: app.icon != null
                    ? Image.memory(app.icon!, fit: BoxFit.cover)
                    : const Icon(
                        Icons.android_rounded,
                        color: AppColors.textSecondary,
                        size: 22,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                app.appName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Switch(
              value: app.isSelected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primaryCyan,
            ),
          ],
        ),
      ),
    );
  }
}
