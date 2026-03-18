import 'dart:typed_data';

/// Data model representing an installed application.
/// This is a pure Dart model with no UI dependencies.
class AppInfo {
  /// The unique package identifier (e.g., com.example.app)
  final String packageName;

  /// Human-readable app name
  final String appName;

  /// App icon as raw bytes (PNG format)
  final Uint8List? icon;

  /// Whether this app is selected for blocking
  bool isSelected;

  AppInfo({
    required this.packageName,
    required this.appName,
    this.icon,
    this.isSelected = false,
  });

  /// Convert to JSON for persistent storage
  /// Note: Icon is not included in JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'isSelected': isSelected,
    };
  }

  /// Create from JSON data
  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  /// Create a copy with optional field overrides
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppInfo && other.packageName == packageName;
  }

  @override
  int get hashCode => packageName.hashCode;

  @override
  String toString() => 'AppInfo(packageName: $packageName, appName: $appName, isSelected: $isSelected)';
}
