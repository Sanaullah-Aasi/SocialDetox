You are an elite, Principal-level Flutter Architect. We are transitioning the "SocialDetox" app into an "Open Core" monorepo architecture. 

I have already created a local package at `/packages/social_detox_core`. Your task is to extract the background VPN, app blocking, and device app querying logic out of the main application and move it into this isolated package. The main app must treat this package as a complete black box.

CRITICAL INSTRUCTIONS:
- Do NOT modify the UI or visual components in the main app.
- Ensure the `social_detox_core` package does NOT depend on any UI libraries (e.g., no Material or Cupertino imports inside the core engine).

### TASK 1: Migrate the Core Logic
Move the following business logic files from the main app into `/packages/social_detox_core/lib/src/`:
1. The VPN Service implementation (e.g., `vpn_service.dart`).
2. The App Info data models (e.g., `app_info.dart`).
3. Any background native channel communicators used for blocking.
*Note: Ensure you update the import paths inside these files to reflect their new relative locations within the package's `src` folder.*

### TASK 2: Create the Public API Barrel File
Create a new file at `/packages/social_detox_core/lib/social_detox_core.dart`.
- This is the barrel file. It must explicitly `export` ONLY the public classes, interfaces, and models from the `src` folder that the main app needs to function (e.g., `export 'src/vpn_service.dart';`). Hide internal implementation details.

### TASK 3: Update Package Dependencies
Modify `/packages/social_detox_core/pubspec.yaml`:
- Add any necessary dependencies that the VPN engine requires (e.g., `device_apps`, native channel helpers) that you extracted from the main app's pubspec.

### TASK 4: Link the Main App
Modify the MAIN app's `pubspec.yaml` (at the root of the project):
- Add the local package to the dependencies using the relative path:
  ```yaml
  dependencies:
    social_detox_core:
      path: ./packages/social_detox_core