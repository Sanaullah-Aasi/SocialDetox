import 'package:flutter/material.dart';
import '../widgets/liquid_background.dart';
import '../widgets/magnetic_nav.dart';
import 'home_screen.dart';
import 'apps_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

/// Project Zenith V2 - Main Screen with Liquid Background & Magnetic Nav
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AppsScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: LiquidBackground(
        child: Stack(
          children: [
            // Screen content
            IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),

            // Magnetic Navigation
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MagneticNav(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  MagneticNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                  ),
                  MagneticNavItem(
                    icon: Icons.apps_outlined,
                    activeIcon: Icons.apps_rounded,
                    label: 'Apps',
                  ),
                  MagneticNavItem(
                    icon: Icons.bar_chart_outlined,
                    activeIcon: Icons.bar_chart_rounded,
                    label: 'Stats',
                  ),
                  MagneticNavItem(
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings_rounded,
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
