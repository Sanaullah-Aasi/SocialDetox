import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:social_detox_core/social_detox_core.dart';

class DetoxProvider with ChangeNotifier {
  final VpnService _vpnService = VpnService();

  // State
  List<AppInfo> _installedApps = [];
  bool _isLoading = false;
  bool _isVpnActive = false;
  String? _errorMessage;

  // Getters
  List<AppInfo> get installedApps => _installedApps;
  List<AppInfo> get blockedApps =>
      _installedApps.where((app) => app.isSelected).toList();
  bool get isLoading => _isLoading;
  bool get isVpnActive => _isVpnActive;
  String? get errorMessage => _errorMessage;
  int get blockedAppsCount => blockedApps.length;

  DetoxProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadInstalledApps();
    await _loadSavedSelections();
    await checkVpnStatus();
  }

  /// Load all installed apps from device using native MethodChannel
  Future<void> loadInstalledApps() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get apps from native Android via MethodChannel
      final List<Map<String, dynamic>> nativeApps =
          await _vpnService.getInstalledApps();

      _installedApps =
          nativeApps.map((app) {
            // Convert icon bytes from native
            Uint8List? iconBytes;
            if (app['icon'] != null) {
              if (app['icon'] is Uint8List) {
                iconBytes = app['icon'] as Uint8List;
              } else if (app['icon'] is List) {
                iconBytes = Uint8List.fromList(List<int>.from(app['icon']));
              }
            }

            return AppInfo(
              packageName: app['packageName'] as String,
              appName: app['appName'] as String,
              icon: iconBytes,
            );
          }).toList();

      // Sort alphabetically (should already be sorted from native, but ensure)
      _installedApps.sort(
        (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()),
      );
    } on VpnException catch (e) {
      _errorMessage = 'Failed to load apps: ${e.message}';
      debugPrint('Error loading apps: $e');
    } catch (e) {
      _errorMessage = 'Failed to load apps: $e';
      debugPrint('Error loading apps: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load previously saved app selections from SharedPreferences
  Future<void> _loadSavedSelections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedJson = prefs.getString('blocked_apps');

      if (savedJson != null) {
        final List<dynamic> decoded = jsonDecode(savedJson);
        final Set<String> blockedPackages =
            decoded.map((e) => e.toString()).toSet();

        for (var app in _installedApps) {
          if (blockedPackages.contains(app.packageName)) {
            app.isSelected = true;
          }
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved selections: $e');
    }
  }

  /// Save current app selections to SharedPreferences
  Future<void> _saveSelections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> blockedPackages =
          blockedApps.map((app) => app.packageName).toList();

      await prefs.setString('blocked_apps', jsonEncode(blockedPackages));
    } catch (e) {
      debugPrint('Error saving selections: $e');
    }
  }

  /// Toggle app selection
  void toggleAppSelection(String packageName) {
    final index = _installedApps.indexWhere(
      (app) => app.packageName == packageName,
    );

    if (index != -1) {
      _installedApps[index].isSelected = !_installedApps[index].isSelected;
      _saveSelections();
      notifyListeners();
    }
  }

  /// Select all apps
  void selectAllApps() {
    for (var app in _installedApps) {
      app.isSelected = true;
    }
    _saveSelections();
    notifyListeners();
  }

  /// Deselect all apps
  void deselectAllApps() {
    for (var app in _installedApps) {
      app.isSelected = false;
    }
    _saveSelections();
    notifyListeners();
  }

  /// Clear all selections (same as deselect all)
  Future<void> clearAllSelections() async {
    deselectAllApps();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('blocked_apps');
  }

  /// Start blocking selected apps
  Future<void> startDetox() async {
    if (blockedApps.isEmpty) {
      _errorMessage = 'Please select at least one app to block';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<String> blockedPackages =
          blockedApps.map((app) => app.packageName).toList();

      await _vpnService.startBlocking(blockedPackages);
      _isVpnActive = true;
    } on VpnPermissionDeniedException catch (e) {
      _errorMessage =
          'VPN permission required. Please grant permission to continue.';
      debugPrint('VPN permission denied: $e');
    } on VpnException catch (e) {
      _errorMessage = 'Failed to start detox: ${e.message}';
      debugPrint('VPN error: $e');
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      debugPrint('Unexpected error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stop blocking apps
  Future<void> stopDetox() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _vpnService.stopBlocking();
      _isVpnActive = false;
    } on VpnException catch (e) {
      _errorMessage = 'Failed to stop detox: ${e.message}';
      debugPrint('VPN error: $e');
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      debugPrint('Unexpected error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check current VPN status
  Future<void> checkVpnStatus() async {
    try {
      _isVpnActive = await _vpnService.isVpnActive();
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking VPN status: $e');
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
