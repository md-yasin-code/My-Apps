import 'package:flutter/material.dart';
import '../repositories/learning_repository.dart';

class AppController extends ChangeNotifier {
  AppController(this.repository);
  final LearningRepository repository;
  ThemeMode themeMode = ThemeMode.system;
  int dailyGoal = 10;
  bool onboardingComplete = false;
  Future<void> load() async {
    final theme = await repository.readSetting('theme_mode');
    final goal = await repository.readSetting('daily_goal');
    final onboarding = await repository.readSetting('onboarding_complete');
    if (theme == 'light') themeMode = ThemeMode.light;
    if (theme == 'dark') themeMode = ThemeMode.dark;
    dailyGoal = int.tryParse(goal ?? '') ?? 10;
    onboardingComplete = onboarding == 'true';
    notifyListeners();
  }
  Future<void> setTheme(ThemeMode value) async {
    themeMode = value; await repository.saveSetting('theme_mode', value.name); notifyListeners();
  }
  Future<void> setDailyGoal(int value) async {
    dailyGoal = value; await repository.saveSetting('daily_goal', '$value'); notifyListeners();
  }
  Future<void> finishOnboarding() async {
    onboardingComplete = true; await repository.saveSetting('onboarding_complete', 'true'); notifyListeners();
  }
}