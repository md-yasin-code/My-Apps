import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/app_database.dart';
import 'repositories/learning_repository.dart';
import 'presentation/controllers/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = LearningRepository(AppDatabase());
  await repository.initialize();
  final controller = AppController(repository);
  await controller.load();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LearningRepositoryProvider(repository)),
    ChangeNotifierProvider.value(value: controller),
  ], child: const DeutschBanglaApp()));
}

class LearningRepositoryProvider extends ChangeNotifier {
  LearningRepositoryProvider(this.repository);
  final LearningRepository repository;
}