# SocialDetox Core

The core VPN blocking engine for the SocialDetox app. This package provides platform-agnostic business logic for app blocking functionality without any UI dependencies.

## Features

- **VPN Service**: Native platform channel integration for Android VPN-based app blocking
- **App Info Model**: Pure Dart data model for installed applications
- **Exception Handling**: Dedicated exception types for VPN permission and service errors
- **Zero UI Dependencies**: Pure business logic - no Material/Cupertino dependencies

## Architecture

This package follows the **Open Core** pattern:
- All business logic is isolated in `/src/` (private implementation)
- Public API exposed through barrel file (`social_detox_core.dart`)
- Main app treats this as a black box dependency

## Usage

```dart
import 'package:social_detox_core/social_detox_core.dart';

// Initialize VPN service
final vpnService = VpnService();

// Get installed apps
final apps = await vpnService.getInstalledApps();

// Parse app data
final appList = apps.map((appData) => AppInfo(
  packageName: appData['packageName'],
  appName: appData['appName'],
  icon: appData['icon'],
)).toList();

// Start blocking
try {
  await vpnService.startBlocking(['com.facebook.katana', 'com.instagram.android']);
} on VpnPermissionDeniedException {
  // Handle permission denied
} on VpnException catch (e) {
  // Handle other VPN errors
}

// Check status
final isActive = await vpnService.isVpnActive();

// Stop blocking
await vpnService.stopBlocking();
```

## Integration

Add to your app's `pubspec.yaml`:

```yaml
dependencies:
  social_detox_core:
    path: ./packages/social_detox_core
```

## License

MIT License - See LICENSE file for details.
