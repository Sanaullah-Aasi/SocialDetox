You are an elite, top 1% Flutter Graphics & UI/UX Engineer. We are executing the final visual overhaul for the proprietary UI of the "SocialDetox" app. We need to build the core visual components using mathematically complex, tactile rendering techniques. 

ABSOLUTELY FORBIDDEN:
- Standard `BorderRadius.circular`.
- Flat colors.
- Generic Material widgets without custom physics.

MANDATORY RENDERING TECHNIQUES:
- Squircles: Use `ContinuousRectangleBorder` or `SmoothRectangleBorder` for ALL containers.
- Inner Bevels: Apply multi-layered `BoxDecoration` with a subtle inner top-left white highlight (opacity 0.05) and bottom-right shadow.
- Spring Physics: Use `TweenAnimationBuilder` with `Curves.elasticOut` for tap interactions.

### TASK 1: The "Breathing Liquid" Background (`lib/widgets/liquid_background.dart`)
Create a stateless widget that acts as the scaffold background.
- Use a `CustomPainter` to draw 3 massive, out-of-focus blurred orbs (`MaskFilter.blur` with sigma 120+).
- Colors: Obsidian Base (#09090B), Deep Electric Indigo (#4F46E5), and a hint of Bioluminescent Mint (#10B981).
- Wrap it in an `AnimationController` (duration: 20s, repeating) that slowly oscillates the X/Y coordinates of the orbs using `math.sin` and `math.cos` to create a slow-breathing mesh gradient.

### TASK 2: The "Quantum Core" Power Button (`lib/widgets/quantum_power_button.dart`)
Replace the standard VPN circular toggle with a hyper-premium tactile button.
- Needs an `isActive` boolean and `onTap` callback.
- Container: A perfect `ContinuousRectangleBorder` squircle.
- Inactive: Glowing Electric Indigo stroke.
- Active: The inner shape must pulse. Add a massive, multi-layered glowing drop shadow (`BoxShadow` with blur radii of 20, 40, and 80 stacked) in Bioluminescent Mint to bleed light into the background.
- Interaction: On tap, scale down to 0.85 using `Curves.easeOutExpo`, and snap back with a heavy spring oscillation. Trigger heavy haptic feedback.

### TASK 3: Magnetic Dynamic Island Nav (`lib/widgets/magnetic_nav.dart`)
Create a custom bottom navigation bar that feels physical.
- Background: A floating squircle capsule. `BackdropFilter` (sigma 25) with a 1px white gradient stroke (opacity 0.1).
- Active Indicator: Create a glowing pill shape that physically slides behind the active icon using `AnimatedAlign` (duration 300ms, curve `Curves.easeOutBack`).
- Icons: When active, use `ShaderMask` to apply a gradient to the icon itself.

### TASK 4: Glass-Bevel App Tiles (`lib/widgets/premium_app_tile.dart`)
Create the premium list item for the apps screen.
- Container: `ContinuousRectangleBorder` with radius 28.
- Background: `Colors.white.withOpacity(0.02)`.
- Border: `Border.all` with a linear gradient (Top Left: White 10%, Bottom Right: Transparent).
- Selected State: Slide a glowing, 3D-styled pill into the background using `AnimatedPositioned`. Apply a greyscale `ColorFiltered` matrix to the trailing App Icon to visually indicate it is "locked".

Write production-ready, highly optimized code. Provide the complete code for these 4 widgets.