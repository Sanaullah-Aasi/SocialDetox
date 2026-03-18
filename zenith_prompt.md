You are an elite, detail-oriented Flutter UI/UX Engineer. Your task is to implement "Project Zenith," a massive visual overhaul of the SocialDetox app. We are moving away from generic, flat glassmorphism to a premium, highly tactile "Cybernetic" aesthetic featuring deep obsidian backgrounds, spatial depth, spring physics, and liquid animations.

CRITICAL INSTRUCTIONS:
- Do NOT alter existing business logic, providers, or state management. Only modify the UI/UX presentation layers.
- Do NOT hallucinate third-party packages. Use standard Flutter widgets, `google_fonts`, `dart:ui` (for ImageFilter), and `flutter/services.dart` (for Haptics).
- Break this down and implement it step-by-step across the provided files.

### 1. DESIGN TOKENS (Update `theme/app_colors.dart` & `theme/app_theme.dart`)
Implement the following global design system:
- Font: 'Plus Jakarta Sans' (via google_fonts)
- Colors:
  - Background: Obsidian Base (#09090B)
  - Cards: Elevated Surface (#18181B) with a 1px inner border of Colors.white.withOpacity(0.04)
  - Primary Inactive: Electric Indigo (#4F46E5)
  - Primary Active: Bioluminescent Mint (#10B981)
  - Warning/Error: Coral Warning (#F43F5E)
  - Text Primary: Stardust (#FAFAFA)
  - Text Secondary: Colors.white.withOpacity(0.60)

### 2. CORE INTERACTION WIDGET (Create/Update `widgets/bouncing_card.dart`)
Create a new reusable wrapper widget called `BouncingCard` that replaces `GlassCard`. 
- Wrap it in a GestureDetector.
- onTapDown: Scale down to 0.97 using `TweenAnimationBuilder` (Duration: 150ms, Curve: Curves.easeOutBack). Trigger `HapticFeedback.lightImpact()`.
- onTapUp/onTapCancel: Scale back to 1.0 (Duration: 300ms, Curve: Curves.elasticOut). Trigger `HapticFeedback.heavyImpact()` on successful tap.
- Use the Elevated Surface color and the 4% white inner border for the container.

### 3. THE "LIQUID CORE" BUTTON (Rewrite `widgets/power_button.dart`)
Completely redesign this from a rotating dashed ring to a liquid, breathing aesthetic.
- Inactive State: A smooth, Electric Indigo glowing ring. 
- Active State: A pulsing, slightly morphing Blob/Wave (using a CustomPainter or complex border radii animation) in Bioluminescent Mint.
- Add a massive, soft shadow (`blurRadius: 80`) behind it using the active/inactive color at 20% opacity.
- Include a subtle particle emission effect or a sweeping gradient when it transitions between states.

### 4. FLOATING NAVIGATION (Rewrite `widgets/bottom_nav_bar.dart`)
Replace the full-width BottomNavBar with a Floating Pill Navigation.
- Position: Floating 20px above the bottom edge, centered.
- Width: Shrink-wrapped to the icons, not full screen width.
- Styling: High blur `ImageFilter.blur(sigmaX: 20, sigmaY: 20)`, semi-transparent dark Zinc background, fully rounded borders (`borderRadius: 99`).
- Interactions: Icons should smoothly transition colors when active.

### 5. SCREEN UPDATES (`screens/home_screen.dart` & `screens/apps_screen.dart`)
- Home Screen: Update typography to reflect the new theme. Remove standard boxes and use the new `BouncingCard`. Below the Liquid Core button, add a sleek status pill (e.g., "[Green Dot] Secured Tunnel Active").
- Apps Screen: Update the `AppTile` to use `BouncingCard`. When an app is selected (isBlocked == true), apply a `ColorFiltered` widget with greyscale/monochrome to the app's icon, and slide in a glowing lock icon from the right edge.

Execute these changes meticulously. If a file becomes too large or complex, pause and ask for confirmation before proceeding to the next file.