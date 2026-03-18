# SocialDetox - Complete Design Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Design Philosophy](#design-philosophy)
3. [Color System](#color-system)
4. [Typography](#typography)
5. [Theme Configuration](#theme-configuration)
6. [Custom Widgets](#custom-widgets)
7. [Screens](#screens)
8. [Animations & Transitions](#animations--transitions)
9. [File Structure](#file-structure)

---

## Project Overview

**SocialDetox** is a productivity Flutter application designed to help users reduce screen time by blocking internet access for selected applications. The app features a premium, modern VPN-style interface with glassmorphism effects and smooth animations.

### Tech Stack
| Component | Technology |
|-----------|------------|
| Framework | Flutter SDK ^3.7.2 |
| State Management | Provider ^6.1.0 |
| Local Storage | SharedPreferences ^2.2.0 |
| Typography | Google Fonts (Poppins) |
| Icons | Material Icons |

---

## Design Philosophy

The design follows these core principles:

1. **Dark-First Design** - Premium dark theme as the default for reduced eye strain and modern aesthetics
2. **Glassmorphism** - Frosted glass effect cards with backdrop blur for depth
3. **Gradient Accents** - Purple-to-cyan gradients for visual interest and brand identity
4. **Minimalism** - Clean layouts with purposeful whitespace
5. **Micro-interactions** - Subtle animations that provide feedback and delight

---

## Color System

### Primary Colors
| Name | Hex Code | RGB | Usage |
|------|----------|-----|-------|
| Primary Purple | `#6C5CE7` | rgb(108, 92, 231) | Primary actions, buttons, accents |
| Primary Purple Light | `#A29BFE` | rgb(162, 155, 254) | Gradient endpoints, highlights |
| Primary Cyan | `#00D2D3` | rgb(0, 210, 211) | Secondary accents, active states |
| Primary Blue | `#54A0FF` | rgb(84, 160, 255) | Gradient variations |

### Background Colors
| Name | Hex Code | RGB | Usage |
|------|----------|-----|-------|
| Background Dark | `#0A0E27` | rgb(10, 14, 39) | Main scaffold background |
| Background Secondary | `#1A1F3D` | rgb(26, 31, 61) | Cards, elevated surfaces |
| Background Tertiary | `#252B4A` | rgb(37, 43, 74) | Snackbars, dialogs |

### Surface Colors (Glass Effects)
| Name | Hex Code | Alpha | Usage |
|------|----------|-------|-------|
| Surface Glass | `#FFFFFF` | 10% (0x1A) | Default glass card fill |
| Surface Glass Light | `#FFFFFF` | 20% (0x33) | Hover/active glass states |
| Surface Glass Dark | `#FFFFFF` | 5% (0x0D) | Subtle glass elements |

### Text Colors
| Name | Hex Code | Alpha | Usage |
|------|----------|-------|-------|
| Text Primary | `#FFFFFF` | 100% | Headings, important text |
| Text Secondary | `#FFFFFF` | 70% (0xB3) | Body text, descriptions |
| Text Tertiary | `#FFFFFF` | 40% (0x66) | Hints, placeholders |
| Text Muted | `#FFFFFF` | 30% (0x4D) | Disabled text |

### Status Colors
| Name | Hex Code | RGB | Usage |
|------|----------|-----|-------|
| Success | `#00B894` | rgb(0, 184, 148) | Active states, confirmations |
| Success Light | `#55EFC4` | rgb(85, 239, 196) | Success gradients |
| Error | `#FF6B6B` | rgb(255, 107, 107) | Errors, destructive actions |
| Error Light | `#FF8E8E` | rgb(255, 142, 142) | Error gradients |
| Warning | `#FDAA5E` | rgb(253, 170, 94) | Warnings, cautions |
| Info | `#74B9FF` | rgb(116, 185, 255) | Informational elements |

### Gradients

#### Primary Gradient
```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF6C5CE7), Color(0xFF00D2D3)],
)
```

#### Background Gradient
```dart
LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF0A0E27), Color(0xFF1A1F3D)],
)
```

#### Glass Gradient
```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.white.withOpacity(0.15),
    Colors.white.withOpacity(0.05),
  ],
)
```

#### Power Button Active Gradient
```dart
LinearGradient(
  colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
)
```

#### Power Button Inactive Gradient
```dart
LinearGradient(
  colors: [Color(0xFF6C5CE7), Color(0xFF00D2D3)],
)
```

---

## Typography

### Font Family
**Poppins** (via Google Fonts) - A geometric sans-serif typeface with clean, modern aesthetics.

### Type Scale
| Style | Size | Weight | Letter Spacing | Usage |
|-------|------|--------|----------------|-------|
| Display Large | 32px | Bold (700) | -0.5 | Hero text |
| Display Medium | 28px | Bold (700) | -0.5 | Screen titles |
| Display Small | 24px | Semi-bold (600) | 0 | Section headers |
| Headline Medium | 20px | Semi-bold (600) | 0 | Card titles |
| Headline Small | 18px | Semi-bold (600) | 0 | Subtitles |
| Title Large | 16px | Semi-bold (600) | 0 | List titles |
| Title Medium | 14px | Medium (500) | 0 | Small titles |
| Body Large | 16px | Normal (400) | 0 | Primary body text |
| Body Medium | 14px | Normal (400) | 0 | Secondary body text |
| Body Small | 12px | Normal (400) | 0 | Captions, hints |
| Label Large | 14px | Semi-bold (600) | 1.2 | Buttons, labels |

---

## Theme Configuration

### AppBar Theme
```dart
AppBarTheme(
  backgroundColor: Colors.transparent,
  elevation: 0,
  centerTitle: true,
  systemOverlayStyle: SystemUiOverlayStyle.light,
  titleTextStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
    size: 24,
  ),
)
```

### Card Theme
```dart
CardTheme(
  color: Color(0x1AFFFFFF), // 10% white
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(
      color: Colors.white.withOpacity(0.1),
      width: 1,
    ),
  ),
)
```

### Elevated Button Theme
```dart
ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF6C5CE7),
    foregroundColor: Colors.white,
    elevation: 0,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
)
```

### Input Decoration Theme
```dart
InputDecorationTheme(
  filled: true,
  fillColor: Color(0x1AFFFFFF),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
      color: Color(0xFF6C5CE7),
      width: 2,
    ),
  ),
  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
)
```

### Switch Theme
```dart
SwitchThemeData(
  thumbColor: // White when selected, tertiary text when not
  trackColor: // Primary purple when selected, glass surface when not
  trackOutlineColor: Colors.transparent,
)
```

---

## Custom Widgets

### 1. GlassCard

A reusable glassmorphism card component with backdrop blur effect.

**File:** `lib/widgets/glass_card.dart`

**Properties:**
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| child | Widget | required | Content inside the card |
| padding | EdgeInsets? | EdgeInsets.all(20) | Internal padding |
| margin | EdgeInsets? | EdgeInsets.symmetric(horizontal: 20, vertical: 8) | External margin |
| borderRadius | double | 24 | Corner radius in pixels |
| blur | double | 10 | Backdrop blur sigma value |
| backgroundColor | Color? | null | Solid background (overrides gradient) |
| gradient | Gradient? | glassGradient | Fill gradient |
| border | Border? | 1px white 10% | Card border |
| onTap | VoidCallback? | null | Tap handler |

**Visual Specifications:**
- Backdrop blur: `ImageFilter.blur(sigmaX: 10, sigmaY: 10)`
- Default gradient: 15% to 5% white
- Border: 1px solid white at 10% opacity
- Corner radius: 24px

**Usage Example:**
```dart
GlassCard(
  padding: EdgeInsets.all(16),
  child: Text('Content'),
  onTap: () => print('Tapped'),
)
```

---

### 2. PowerButton

An animated circular power button with rotating ring effects and glow.

**File:** `lib/widgets/power_button.dart`

**Properties:**
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| isActive | bool | required | Whether protection is active |
| isLoading | bool | false | Shows loading spinner |
| onTap | VoidCallback? | null | Tap handler |
| size | double | 200 | Button diameter in pixels |

**Visual Components:**

1. **Outer Glow**
   - Shape: Circle
   - Size: button size + 40px
   - Color: Current state color at 30-50% opacity (animated)
   - Blur radius: 40-60px (animated)
   - Spread: 5px

2. **Rotating Outer Ring**
   - Size: button size + 30px
   - Style: Dashed circle
   - Dash length: 8px
   - Gap length: 12px
   - Stroke width: 2px
   - Color: State color at 30% opacity
   - Animation: Full rotation in 10 seconds

3. **Rotating Inner Ring**
   - Size: button size + 50px
   - Style: Dashed circle
   - Dash length: 4px
   - Gap length: 8px
   - Stroke width: 1px
   - Color: State color at 15% opacity
   - Animation: Reverse rotation at 70% speed

4. **Main Button**
   - Size: As specified (default 200px)
   - Shape: Circle with gradient fill
   - Gradient: Active (green) or Inactive (purple-cyan)
   - Shadow: State color at 50%, blur 30px, offset (0, 10)
   - Inner container: 6px margin, 30% dark background
   - Inner border: 2px white at 20% opacity

5. **Icon**
   - Icon: `Icons.power_settings_new_rounded`
   - Size: 40% of button size
   - Color: White

6. **Active Indicators (when active)**
   - 4 dots positioned around the button
   - Size: 8x8px
   - Animation: Rotate with outer ring
   - Glow: State color, 8px blur

**Animations:**
| Animation | Duration | Curve | Description |
|-----------|----------|-------|-------------|
| Pulse | 2 seconds | easeInOut | Glow intensity variation |
| Rotate | 10 seconds | linear | Ring rotation |
| Scale | 150ms | easeInOut | Tap feedback (1.0 → 0.95) |

---

### 3. BottomNavBar

A glassmorphism bottom navigation bar with gradient active states.

**File:** `lib/widgets/bottom_nav_bar.dart`

**Properties:**
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| currentIndex | int | required | Active tab index (0-3) |
| onTap | Function(int) | required | Tab selection handler |

**Visual Specifications:**
- Height: 70px
- Margin: 20px all sides
- Border radius: 25px
- Backdrop blur: 15 sigma
- Gradient fill: 15% to 5% white
- Border: 1px white at 10% opacity

**Navigation Items:**
| Index | Icon (Inactive) | Icon (Active) | Label |
|-------|-----------------|---------------|-------|
| 0 | shield_outlined | shield_rounded | Home |
| 1 | apps_outlined | apps_rounded | Apps |
| 2 | bar_chart_outlined | bar_chart_rounded | Stats |
| 3 | settings_outlined | settings_rounded | Settings |

**Item States:**
- **Active:**
  - Background: Purple at 20% opacity
  - Icon: Gradient shader mask (purple → cyan)
  - Label: Cyan, weight 600
  - Padding: 16px horizontal, 8px vertical
  
- **Inactive:**
  - Background: Transparent
  - Icon: Text tertiary color
  - Label: Text tertiary color, normal weight

---

### 4. AppTile

A selectable app list item with gradient border effects.

**File:** `lib/widgets/app_tile.dart`

**Properties:**
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| app | AppInfo | required | App data model |
| onTap | VoidCallback | required | Selection toggle handler |
| showToggle | bool | true | Show checkbox indicator |

**Visual Specifications:**

**Container:**
- Margin: 20px horizontal, 6px vertical
- Padding: 16px all sides
- Border radius: 20px
- Animation duration: 200ms

**Selected State:**
- Gradient: Purple 20% → Cyan 10%
- Border: Purple at 50%, 1.5px width

**Unselected State:**
- Gradient: White 8% → White 3%
- Border: White at 8%, 1px width

**App Icon Container:**
- Size: 52x52px
- Border radius: 14px
- Selected: Gradient border (purple → cyan), 2px padding
- Unselected: Glass surface color
- Inner container: 12px border radius, dark secondary background

**Text:**
- App name: 15px, weight 600, primary color
- Package name: 11px, tertiary color

**Checkbox (when showToggle = true):**
- Size: 28x28px
- Border radius: 8px
- Selected: Gradient fill, white check icon (18px)
- Unselected: 2px tertiary border

---

### 5. GlassContainer

A simpler glass container without tap functionality.

**File:** `lib/widgets/glass_card.dart`

**Properties:**
| Property | Type | Default | Description |
|----------|------|---------|-------------|
| child | Widget | required | Content |
| padding | EdgeInsets? | EdgeInsets.all(16) | Internal padding |
| borderRadius | double | 20 | Corner radius |
| blur | double | 10 | Backdrop blur sigma |

---

## Screens

### 1. Splash Screen

**File:** `lib/screens/splash_screen.dart`

**Purpose:** Brand introduction and app initialization

**Duration:** 3 seconds before navigation

**Visual Components:**

1. **Background**
   - Full gradient: backgroundGradient (dark navy)

2. **Ambient Glow Orbs**
   - Top-right: Purple glow, 350px, positioned at (-150, -100)
   - Bottom-left: Cyan glow, 300px, positioned at (-100, -100)
   - Animation: Pulse (opacity varies 0.24 - 0.3)

3. **Animated Logo**
   - Container size: 180x180px
   - Outer ring: Dashed circle, 160px, rotates clockwise
   - Inner ring: Dashed circle, 140px, rotates counter-clockwise at 70% speed
   - Main circle: 120px, gradient fill (purple → cyan)
   - Glow: Purple at 40%, 30px blur, 5px spread
   - Inner container: 4px margin, dark background at 30%
   - Inner border: 2px white at 20%
   - Icon: shield_rounded, 50px, white

4. **App Name**
   - Text: "SocialDetox"
   - Size: 36px
   - Weight: Bold
   - Gradient text: Purple → Cyan (ShaderMask)
   - Letter spacing: 1.5

5. **Tagline**
   - Text: "Focus on what matters"
   - Size: 16px
   - Color: Text secondary
   - Letter spacing: 0.5

6. **Loading Indicator**
   - Position: Bottom, 80px from edge
   - Size: 24x24px
   - Stroke width: 2px
   - Color: Cyan at 50%

**Animations:**
| Element | Animation | Duration | Curve |
|---------|-----------|----------|-------|
| Logo/Text | Fade + Scale | 1.5s | easeIn / easeOutBack |
| Glow orbs | Pulse | 2s | easeInOut, repeat |
| Rings | Rotate | 8s | linear, repeat |

**Transition:** FadeTransition to MainScreen (800ms)

---

### 2. Main Screen (Navigation Wrapper)

**File:** `lib/screens/main_screen.dart`

**Purpose:** Contains bottom navigation and manages screen switching

**Visual Components:**

1. **Background**
   - Gradient: backgroundGradient

2. **Ambient Blobs**
   - Top-right: Purple glow, 300px, radial gradient
   - Bottom-left: Cyan glow, 250px, radial gradient

3. **Screen Content**
   - IndexedStack for tab persistence
   - 4 screens: Home, Apps, Stats, Settings

4. **Bottom Navigation**
   - BottomNavBar widget
   - Position: Bottom, left, right

---

### 3. Home Screen

**File:** `lib/screens/home_screen.dart`

**Purpose:** Main dashboard with power button and status overview

**Layout:** SingleChildScrollView with Column

**Sections:**

#### 3.1 Header
- Padding: 24px horizontal
- Shield icon: Gradient shader mask (purple → cyan), 32px
- App name: "SocialDetox", 24px, bold, white

#### 3.2 Power Section
- Spacing: 40px from header

**Power Button:**
- Widget: PowerButton
- Size: 200px (default)
- States: Active/Inactive based on VPN status
- Disabled when: No apps selected

**Status Text (below button):**
- Spacing: 24px from button
- Primary text: 22px, bold
  - Active: "Protection Active" (green)
  - Inactive: "Tap to Protect" (white)
- Secondary text: 14px, text secondary
  - Active: "{count} apps are being blocked"
  - Inactive with apps: "{count} apps ready to block"
  - Inactive no apps: "Select apps to get started"

#### 3.3 Quick Stats Section
- Spacing: 40px from power section
- Padding: 20px horizontal
- Layout: Row with 2 equal cards, 12px gap

**Stat Card (Left - Blocked Apps):**
- Icon: apps_rounded
- Gradient: Purple → Purple Light
- Value: App count
- Label: "Blocked Apps"

**Stat Card (Right - Status):**
- Icon: access_time_rounded
- Value: "Active" or "Ready"
- Label: "Status"
- Gradient: Green (active) or Cyan (inactive)

#### 3.4 Error Banner (conditional)
- Shown when: provider.errorMessage != null
- Style: GlassCard with error border
- Icon: warning_amber_rounded (error color)
- Close button: X icon

#### 3.5 Blocked Apps Preview (conditional)
- Shown when: blockedAppsCount > 0
- Style: GlassCard

**Header Row:**
- Title: "Blocked Apps", 16px, weight 600
- Link: "View all →", 13px, cyan

**App Chips:**
- Layout: Wrap with 8px spacing
- Max shown: 3 apps
- Chip style:
  - Padding: 12px horizontal, 8px vertical
  - Background: Glass surface
  - Border: 1px white 10%
  - Border radius: 12px
- App icon: 24x24px, 6px border radius
- App name: 13px

**Overflow Chip:**
- Shown when: > 3 apps
- Text: "+{remaining} more"
- Background: Gradient (purple → cyan)
- Text: White, weight 500

---

### 4. Apps Screen

**File:** `lib/screens/apps_screen.dart`

**Purpose:** App selection interface

**Layout:** SafeArea with Column

**Sections:**

#### 4.1 Header
- Spacing: 20px top
- Padding: 24px horizontal
- Title: "Select Apps", 24px, bold
- Menu button: More vert icon in glass container

**Popup Menu:**
- Background: Dark secondary
- Border radius: 16px
- Items:
  - Select All: check_box_rounded (cyan)
  - Deselect All: check_box_outline_blank_rounded (error)

#### 4.2 Search Bar
- Spacing: 20px from header
- Padding: 20px horizontal
- Style: Glass gradient with border
- Border radius: 16px
- Prefix: search_rounded icon
- Suffix: close_rounded (when has text)
- Hint: "Search apps..."

#### 4.3 Selection Summary
- Spacing: 16px from search
- Style: GlassCard with purple gradient tint
- Border: Purple at 30%
- Icon: checklist_rounded with gradient shader

**Text:**
- Count: Bold, 16px, "{count}"
- Description: "of {total} apps selected", 14px, secondary

**Clear Button:**
- Shown when: count > 0
- Text: "Clear", error color, weight 600

#### 4.4 Apps List
- Spacing: 16px from summary
- Padding bottom: 120px (for nav bar)
- Item: AppTile widget
- Loading state: CircularProgressIndicator (purple)
- Empty state: search_off_rounded icon, "No apps found"

---

### 5. Stats Screen

**File:** `lib/screens/stats_screen.dart`

**Purpose:** Usage statistics and analytics

**Layout:** SafeArea with SingleChildScrollView

**Sections:**

#### 5.1 Header
- Spacing: 20px top
- Padding: 24px horizontal
- Title: "Statistics", 24px, bold

#### 5.2 Status Card
- Spacing: 24px from header
- Style: GlassCard with state-based gradient
  - Active: Green gradient tint
  - Inactive: Purple gradient tint

**Content:**
- Icon container: 14px padding, gradient fill, 16px radius
- Title: 18px, bold, state-colored
- Subtitle: 13px, secondary
- Status dot: 12px, with glow when active

#### 5.3 Stats Grid
- Spacing: 20px from status card
- Padding: 20px horizontal
- Layout: 2 rows × 2 columns, 12px gaps

**Stat Boxes:**
| Position | Icon | Value | Label | Gradient |
|----------|------|-------|-------|----------|
| Top-left | apps_rounded | {blocked count} | Blocked Apps | Purple |
| Top-right | smartphone_rounded | {total count} | Total Apps | Cyan |
| Bottom-left | timer_rounded | Active/Idle | Current Status | Green/Gray |
| Bottom-right | trending_up_rounded | 100% | Focus Rate | Warning |

**Stat Box Style:**
- GlassCard with zero margin
- Icon container: 8px padding, gradient, 10px radius
- Value: 24px, bold
- Label: 12px, tertiary

#### 5.4 Activity Section
- Spacing: 24px from grid
- Title: "Recent Activity", 18px, weight 600, 24px padding

**Activity Card (GlassCard):**
- Items separated by dividers (white 10%, 24px height)

**Activity Item:**
- Icon container: 10px padding, glass/green background, 12px radius
- Title: 14px, weight 600
- Subtitle: 12px, tertiary
- Time: 12px, tertiary (green + weight 600 when active)

**Default Activities:**
1. Session Started - "Protection enabled" - "Now" (active)
2. Apps Selected - "Added apps to block list" - "Today"
3. App Installed - "SocialDetox setup complete" - "Today"

#### 5.5 Tips Section
- Spacing: 24px from activity
- Title: "Focus Tips", 18px, weight 600, 24px padding

**Tips Carousel:**
- Height: 120px
- Horizontal scroll
- Padding: 20px horizontal

**Tip Cards:**
| Icon | Title | Gradient |
|------|-------|----------|
| notifications_off_rounded | Disable Notifications | Purple → Cyan |
| schedule_rounded | Set a Schedule | Green |
| psychology_rounded | Take Breaks | Warning |

**Tip Card Style:**
- Width: 140px
- Margin right: 12px
- Padding: 16px
- Gradient: Color at 30% → 10%
- Border radius: 20px
- Border: Color at 30%

---

### 6. Settings Screen

**File:** `lib/screens/settings_screen.dart`

**Purpose:** App configuration and information

**Layout:** SafeArea with SingleChildScrollView

**Sections:**

#### 6.1 Header
- Spacing: 20px top
- Padding: 24px horizontal
- Title: "Settings", 24px, bold

#### 6.2 Profile Card
- Spacing: 24px from header
- Style: GlassCard with full gradient (purple → cyan)

**Content:**
- Avatar: 60x60px, white 20% background, person_rounded icon
- Name: "SocialDetox User", 18px, bold, white
- Subtitle: "Premium Features Unlocked", 13px, white 70%
- Badge: "PRO" chip, white 20% background

#### 6.3 Data Management Section
- Title: "DATA MANAGEMENT", 12px, bold, 1.5 letter spacing, tertiary

**GlassCard with zero padding:**
- Divider: White 8%, 1px, 56px indent

**Settings Tiles:**
1. Clear all selections
   - Icon: delete_outline_rounded (error)
   - Subtitle: "{count} apps selected"
   - Action: Show clear confirmation dialog

2. Reload apps
   - Icon: refresh_rounded (cyan)
   - Subtitle: "Re-scan installed applications"
   - Action: Reload installed apps, show snackbar

#### 6.4 About Section
- Title: "ABOUT"

**Settings Tiles:**
1. Version
   - Icon: tag_rounded (purple)
   - Subtitle: "1.0.0"
   - No action

2. How it works
   - Icon: shield_outlined (success)
   - Subtitle: "Learn about VPN-based blocking"
   - Action: Show how it works dialog

#### 6.5 Testing Section
- Title: "TESTING"

**Settings Tile:**
- Test blocking
  - Icon: bug_report_outlined (warning)
  - Subtitle: "Verify functionality"
  - Action: Show test instructions dialog

#### 6.6 Disclaimer
- Style: GlassCard with info gradient tint
- Border: Info at 20%
- Icon: info_outline_rounded (info)
- Text: Privacy notice about local VPN

#### 6.7 Footer
- Alignment: Center
- Text: "Made with ❤️ for your focus"
- Heart: Gradient shader (error colors)

---

### Settings Tile Component

**Style:**
- Padding: 16px horizontal, 14px vertical
- Border radius: 20px (inkwell)

**Icon Container:**
- Padding: 8px
- Background: Icon color at 15%
- Border radius: 10px
- Icon size: 20px

**Text:**
- Title: 15px, weight 600
- Subtitle: 12px, tertiary

**Chevron:** chevron_right_rounded when onTap provided

---

### Dialog Styles

**Base Dialog:**
- Background: Dark secondary
- Border radius: 24px
- Border: White at 10%

**Dialog Title Row:**
- Icon container: 10px padding, gradient/colored background, 12px radius
- Title: Bold, primary color

**Step Items:**
- Number: 28x28px, gradient background, 8px radius
- Text: 14px, secondary

**Actions:**
- TextButton: "Got it", cyan, weight 600

---

## Animations & Transitions

### Page Transitions
| From | To | Type | Duration |
|------|-----|------|----------|
| Splash | Main | FadeTransition | 800ms |

### Widget Animations

#### PowerButton
| Animation | Property | Duration | Curve |
|-----------|----------|----------|-------|
| Pulse | Glow opacity | 2s repeat | easeInOut |
| Rotate | Ring angle | 10s repeat | linear |
| Scale (tap) | Transform | 150ms | easeInOut |

#### Splash Screen
| Animation | Property | Duration | Curve |
|-----------|----------|----------|-------|
| Fade | Opacity | 1.5s | easeIn |
| Scale | Transform | 1.5s | easeOutBack |
| Pulse | Glow opacity | 2s repeat | easeInOut |
| Rotate | Ring angle | 8s repeat | linear |

### AnimatedContainer Usages
| Widget | Property | Duration |
|--------|----------|----------|
| AppTile | Background/Border | 200ms |
| BottomNavBar item | Background | 200ms |
| AppTile checkbox | All | 200ms |
| Home action button | All | 300ms |

---

## File Structure

```
lib/
├── main.dart                    # App entry point
├── theme/
│   ├── app_colors.dart          # Color definitions
│   └── app_theme.dart           # Theme configuration
├── models/
│   └── app_info.dart            # App data model
├── providers/
│   └── detox_provider.dart      # State management
├── services/
│   └── vpn_service.dart         # VPN communication
├── screens/
│   ├── splash_screen.dart       # Launch screen
│   ├── main_screen.dart         # Navigation wrapper
│   ├── home_screen.dart         # Dashboard
│   ├── apps_screen.dart         # App selection
│   ├── stats_screen.dart        # Statistics
│   └── settings_screen.dart     # Settings
└── widgets/
    ├── glass_card.dart          # Glassmorphism card
    ├── power_button.dart        # Animated power button
    ├── bottom_nav_bar.dart      # Navigation bar
    └── app_tile.dart            # App list item
```

---

## Design Tokens Summary

### Spacing
| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Icon gaps |
| sm | 8px | Tight spacing |
| md | 12px | Default gaps |
| lg | 16px | Section spacing |
| xl | 20px | Card padding |
| 2xl | 24px | Screen padding |
| 3xl | 32px | Large sections |
| 4xl | 40px | Major sections |

### Border Radius
| Token | Value | Usage |
|-------|-------|-------|
| sm | 8px | Checkboxes, small elements |
| md | 12px | Icons, chips |
| lg | 16px | Inputs, buttons |
| xl | 20px | Cards |
| 2xl | 24px | Large cards |
| 3xl | 25px | Navigation bar |
| full | 9999px | Circles |

### Shadows
| Name | Specs | Usage |
|------|-------|-------|
| Glow Small | blur: 8px | Active indicators |
| Glow Medium | blur: 30px, offset: (0, 10) | Buttons |
| Glow Large | blur: 40-60px, spread: 5px | Power button |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | March 2026 | Initial release with complete UI redesign |

---

*Documentation generated for SocialDetox Flutter Application*
