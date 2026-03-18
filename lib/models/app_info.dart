import 'dart:typed_data';

class AppInfo {
  final String packageName;
  final String appName;
  final Uint8List? icon;
  bool isSelected;

  AppInfo({
    required this.packageName,
    required this.appName,
    this.icon,
    this.isSelected = false,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'isSelected': isSelected,
    };
  }

  // Create from JSON
  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  AppInfo copyWith({
    String? packageName,
    String? appName,
    Uint8List? icon,
    bool? isSelected,
  }) {
    return AppInfo(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
