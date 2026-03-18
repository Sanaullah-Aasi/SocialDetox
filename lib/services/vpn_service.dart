import 'package:flutter/services.dart';

class VpnService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.socialdetox/vpn',
  );

  /// Get list of installed apps from native Android
  Future<List<Map<String, dynamic>>> getInstalledApps() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod(
        'getInstalledApps',
      );
      return result.map((app) => Map<String, dynamic>.from(app)).toList();
    } on PlatformException catch (e) {
      throw VpnException(e.message ?? 'Failed to get installed apps');
    }
  }

  /// Start blocking the specified apps
  /// Returns true if successful, throws PlatformException on error
  Future<bool> startBlocking(List<String> blockedPackages) async {
    try {
      final bool result = await _channel.invokeMethod('startBlocking', {
        'blockedPackages': blockedPackages,
      });
      return result;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        throw VpnPermissionDeniedException(
          e.message ?? 'VPN permission denied',
        );
      }
      throw VpnException(e.message ?? 'Failed to start blocking');
    }
  }

  /// Stop blocking all apps
  Future<bool> stopBlocking() async {
    try {
      final bool result = await _channel.invokeMethod('stopBlocking');
      return result;
    } on PlatformException catch (e) {
      throw VpnException(e.message ?? 'Failed to stop blocking');
    }
  }

  /// Check if VPN is currently active
  Future<bool> isVpnActive() async {
    try {
      final bool result = await _channel.invokeMethod('isVpnActive');
      return result;
    } on PlatformException {
      return false;
    }
  }
}

// Custom exceptions
class VpnException implements Exception {
  final String message;
  VpnException(this.message);

  @override
  String toString() => 'VpnException: $message';
}

class VpnPermissionDeniedException extends VpnException {
  VpnPermissionDeniedException(super.message);

  @override
  String toString() => 'VpnPermissionDeniedException: $message';
}
