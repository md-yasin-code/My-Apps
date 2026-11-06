import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/controllers/app_controller.dart';
import 'screens/app_shell.dart';
import 'data/app_database.dart';
import 'screens/onboarding_screen.dart';

class DeutschBanglaApp extends StatelessWidget {
  const DeutschBanglaApp({super.key, required this.database});
  final AppDatabase database;
  @override Widget build(BuildContext context) => Consumer<AppController>(
    builder: (context, controller, _) {
      const seed = Color(0xFF176B5B);
      ThemeData makeTheme(Brightness brightness) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
        scaffoldBackgroundColor: brightness == Brightness.light ? const Color(0xFFF6F8F7) : const Color(0xFF101816),
        appBarTheme: AppBarTheme(centerTitle: false, backgroundColor: brightness == Brightness.light ? const Color(0xFFF6F8F7) : const Color(0xFF101816)),
        cardTheme: CardThemeData(elevation: 0, color: brightness == Brightness.light ? const Color(0xFFFFFFFF) : const Color(0xFF1A2521), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        }),
      );
      return MaterialApp(title: 'Deutsch Bangla', debugShowCheckedModeBanner: false,
        theme: makeTheme(Brightness.light), darkTheme: makeTheme(Brightness.dark),
        themeMode: controller.themeMode, home: controller.onboardingComplete ? AppShell(database: database) : const OnboardingScreen());
    },
  );
}