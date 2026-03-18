import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/detox_provider.dart';
import 'providers/subscription_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0E27),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SocialDetoxApp());
}

class SocialDetoxApp extends StatelessWidget {
  const SocialDetoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Subscription provider (independent)
        ChangeNotifierProvider(
          create: (_) => SubscriptionProvider()..initialize(),
        ),
        // Detox provider (depends on subscription)
        ChangeNotifierProxyProvider<SubscriptionProvider, DetoxProvider>(
          create: (_) => DetoxProvider(),
          update: (_, subscriptionProvider, detoxProvider) {
            detoxProvider!.updateProStatus(subscriptionProvider.isPro);
            return detoxProvider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'SocialDetox',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
