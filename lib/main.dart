import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/app_database.dart';
import 'repositories/learning_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = LearningRepository(AppDatabase());
  await repository.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LearningRepositoryProvider(repository),
      child: const DeutschBanglaApp(),
    ),
  );
}

/// Small app-level notifier keeps the repository available to screens.
class LearningRepositoryProvider extends ChangeNotifier {
  LearningRepositoryProvider(this.repository);
  final LearningRepository repository;
}
