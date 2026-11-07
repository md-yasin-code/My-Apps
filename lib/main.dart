import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/firebase_options.dart';
import 'app.dart';
import 'data/app_database.dart';
import 'repositories/learning_repository.dart';
import 'presentation/controllers/app_controller.dart';
import 'screens/startup_error_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _bootstrap();
}

Future<void> _bootstrap() async {
  try {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (error, stackTrace) {
      // Firebase is optional: local learning must remain available offline.
      debugPrint('Firebase initialization skipped: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    final database = AppDatabase();
    final repository = LearningRepository(database);
    await repository.initialize();

    final controller = AppController(repository);
    await controller.load();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LearningRepositoryProvider(repository),
          ),
          ChangeNotifierProvider.value(value: controller),
        ],
        child: DeutschBanglaApp(database: database),
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('Deutsch Bangla startup failed: $error');
    debugPrintStack(stackTrace: stackTrace);
    runApp(
      MaterialApp(
        title: 'Deutsch Bangla',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B5B)),
        ),
        home: StartupErrorScreen(
          error: error,
          onRetry: _bootstrap,
        ),
      ),
    );
  }
}

class LearningRepositoryProvider extends ChangeNotifier {
  LearningRepositoryProvider(this.repository);
  final LearningRepository repository;
}
