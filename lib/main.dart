import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'app.dart';
import 'data/app_database.dart';
import 'repositories/learning_repository.dart';
import 'presentation/controllers/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (error) {
    debugPrint('Firebase is not configured; continuing in offline guest mode: $error');
  }
  final database = AppDatabase();
  final repository = LearningRepository(database);
  await repository.initialize();
  final controller = AppController(repository);
  await controller.load();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LearningRepositoryProvider(repository)),
    ChangeNotifierProvider.value(value: controller),
  ], child: DeutschBanglaApp(database: database)));
}

class LearningRepositoryProvider extends ChangeNotifier {
  LearningRepositoryProvider(this.repository);
  final LearningRepository repository;
}