
You are an elite, top 1% Flutter Graphics & UI/UX Engineer. Your previous output was too generic and relied too heavily on standard Material Design paradigms. We need to upgrade "Project Zenith" to a hyper-premium, mathematically complex, and deeply tactile UI. It must look and feel hand-crafted with intense manual effort.

ABSOLUTELY FORBIDDEN:
- Standard `BorderRadius.circular` (Looks too generic).
- Standard flat colors for active elements.
- Static screens without entrance animations.
- Generic `BottomNavigationBar`.

MANDATORY RENDERING TECHNIQUES TO IMPLEMENT:
1. Squircles: Use `ContinuousRectangleBorder` or `SmoothRectangleBorder` for EVERY card and container to give them that premium iOS/physical hardware feel.
2. Inner Bevels & Lighting: Cards must not just have a background color. They MUST have a multi-layered `BoxDecoration` with a subtle inner top-left white highlight (opacity 0.05) and a bottom-right dark shadow to simulate physical, milled aluminum/glass.
3. Complex Shaders: Use `ShaderMask` with `LinearGradient` for all primary active text and active icons. 
4. Staggered Physics: Every list (Apps, Stats) must use staggered entrance animations using `Transform.translate` and `FadeTransition` driven by an `AnimationController` with `SpringSimulation` or `Curves.elasticOut`.

### COMPONENT 1: The "Breathing Liquid" Background (`widgets/liquid_background.dart`)
Do not use a solid `#09090B` background. 
- Create a `CustomPainter` that draws 2-3 massive, out-of-focus blurred orbs (use `MaskFilter.blur` with a sigma of 100+).
- These orbs must slowly oscillate their X/Y positions over a 15-second `AnimationController` to create a "breathing" mesh gradient effect behind the entire app.

### COMPONENT 2: The "Quantum Core" Power Button (`widgets/quantum_power_button.dart`)
Replace the standard circular button with a mathematically driven liquid blob.
- Create a `CustomPainter`.
- Inactive: A perfect, glowing `ContinuousRectangleBorder` squircle.
- Active (Connected): The shape must morph using Sine/Cosine waves applied to its vertices to create a slow, undulating liquid blob (like a lava lamp). 
- Add a massive, multi-layered glowing drop shadow (`BoxShadow` with blur radii of 20, 40, and 80 stacked on top of each other) to make it bleed light into the background.
- Wrap it in a `GestureDetector`. On tap, use `Transform.scale` to push it deep into the Z-axis (scale 0.85) with `Curves.easeOutExpo`, and snap back with a heavy spring oscillation.

### COMPONENT 3: Glass-Bevel App Tiles (`widgets/premium_app_tile.dart`)
Redesign the app list items to feel like physical glass slides.
- Container: `ContinuousRectangleBorder` with borderRadius 28.
- Background: `Colors.white.withOpacity(0.02)`.
- Border: `Border.all` with a linear gradient (Top Left: White 10%, Bottom Right: Transparent).
- Interaction: When selected, do not just change the color. Slide a glowing, 3D-styled pill into the background of the tile using `AnimatedPositioned`, and apply a greyscale `ColorFiltered` matrix to the App Icon to show it is "locked".

### COMPONENT 4: Magnetic Dynamic Island Nav (`widgets/magnetic_nav.dart`)
The bottom navigation must feel physical and magnetic.
- Background: A floating squircle capsule. `BackdropFilter` (sigma 25) with a 1px gradient stroke.
- Active Indicator: Do not just change the icon color. Create a glowing pill shape that physically slides behind the active icon using `AnimatedAlign`. 
- Spring Physics: When an icon is tapped, the icon itself must bounce independently of the background.

Execute these exact mathematical and physical rendering instructions across the codebase. Show me you understand custom Canvas painting and advanced Flutter animation pipelines.