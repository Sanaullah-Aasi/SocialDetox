You are an elite Flutter Architect. We are implementing Phase 2 of "Project Zenith" (SocialDetox): The Freemium Monetization Engine. 

We need to integrate RevenueCat (`purchases_flutter`) to manage subscriptions and enforce a "Max 3 Apps" limit for free users. All UI elements must strictly adhere to the "Zenith" design language (Obsidian backgrounds, ContinuousRectangleBorder squircles, spring physics, and premium gradients).

CRITICAL INSTRUCTIONS:
- Do NOT alter the `social_detox_core` package. All of this logic belongs in the main app's `/lib` folder.

### TASK 1: The Subscription Provider (`lib/providers/subscription_provider.dart`)
Create a new `ChangeNotifier` called `SubscriptionProvider`.
- It must initialize `Purchases.configure()` (leave a placeholder string for the API key).
- It must listen to `Purchases.addCustomerInfoUpdateListener`.
- Expose a boolean getter `bool get isPro`. (Default it to `false`).
- Create a method `Future<void> purchasePro()` that handles the RevenueCat package purchase flow.

### TASK 2: Enforce the Paywall Limit (Update `detox_provider.dart`)
Modify the existing provider that handles app selection (e.g., `DetoxProvider`).
- It needs access to the `SubscriptionProvider`'s `isPro` status (either via constructor injection or a ProxyProvider setup).
- In the method where users toggle an app selection (e.g., `toggleAppBlocking(AppInfo app)`), implement this logic:
  - IF `isPro == false` AND the current selected app count is >= 3 AND the user is trying to add a NEW app:
  - Do NOT select the app.
  - Instead, throw a custom exception or trigger a callback (e.g., `onPaywallTriggered()`) that the UI can listen to.

### TASK 3: The Zenith Paywall Bottom Sheet (`lib/widgets/zenith_paywall.dart`)
Create a hyper-premium `PaywallBottomSheet` widget to display when the user hits the 3-app limit.
- Container: `ContinuousRectangleBorder` with a large radius (e.g., 32) at the top left/right.
- Background: Obsidian Base (`#09090B`) with a very subtle white inner top-bevel (opacity 0.05).
- Iconography: A glowing glowing lock icon or crown at the top, using a `ShaderMask` with a gradient (Electric Indigo to Bioluminescent Mint).
- Typography: "Unlock Absolute Focus" (Large, Stardust text). "Free users are limited to 3 apps. Upgrade to Pro to lock down your entire digital life."
- Call to Action: A massive `BouncingCard` button. The background should be a mesh gradient or solid Bioluminescent Mint (`#10B981`), with heavy shadow bleed (`blurRadius: 30`).

Execute these tasks with precision. Ensure the state management bridging is clean and reactive.