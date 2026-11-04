import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class DeutschBanglaApp extends StatelessWidget {
  const DeutschBanglaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF176B5B);
    return MaterialApp(
      title: 'Deutsch Bangla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        appBarTheme: const AppBarTheme(centerTitle: false, backgroundColor: Color(0xFFF6F8F7)),
        cardTheme: CardThemeData(elevation: 0, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
      ),
      home: const HomeScreen(),
    );
  }
}
