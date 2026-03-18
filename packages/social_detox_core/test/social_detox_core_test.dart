import 'package:flutter_test/flutter_test.dart';
import 'package:social_detox_core/social_detox_core.dart';

void main() {
  group('VpnService', () {
    test('should instantiate', () {
      final vpnService = VpnService();
      expect(vpnService, isNotNull);
    });
  });

  group('AppInfo', () {
    test('should create from JSON', () {
      final json = {
        'packageName': 'com.test.app',
        'appName': 'Test App',
        'isSelected': true,
      };
      
      final appInfo = AppInfo.fromJson(json);
      
      expect(appInfo.packageName, 'com.test.app');
      expect(appInfo.appName, 'Test App');
      expect(appInfo.isSelected, true);
    });

    test('should convert to JSON', () {
      final appInfo = AppInfo(
        packageName: 'com.test.app',
        appName: 'Test App',
        isSelected: false,
      );
      
      final json = appInfo.toJson();
      
      expect(json['packageName'], 'com.test.app');
      expect(json['appName'], 'Test App');
      expect(json['isSelected'], false);
    });
  });
}
