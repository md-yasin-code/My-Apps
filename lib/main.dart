import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'services/firebase_options.dart';
import 'app.dart';
import 'data/app_database.dart';
import 'repositories/learning_repository.dart';
import 'presentation/controllers/app_controller.dart';
import 'screens/startup_error_screen.dart';

bool _firebaseInitialized = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _bootstrap();
}

void _installCrashlyticsHandlers() {
  if (!_firebaseInitialized || kIsWeb) return;

  // Report framework errors while retaining Flutter's normal error presentation.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    unawaited(
      FirebaseCrashlytics.instance.recordFlutterFatalError(details).catchError(
        (Object error, StackTrace stack) {
          debugPrint('Crashlytics Flutter error reporting failed: $error');
        },
      ),
    );
  };

  // Report uncaught asynchronous errors outside the Flutter framework.
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    unawaited(
      FirebaseCrashlytics.instance
          .recordError(error, stack, fatal: true)
          .catchError((Object reportError, StackTrace reportStack) {
        debugPrint('Crashlytics async error reporting failed: $reportError');
      }),
    );
    return true;
  };
}

Future<void> _bootstrap() async {
  try {
    _firebaseInitialized = false;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _firebaseInitialized = true;
      _installCrashlyticsHandlers();
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
    if (_firebaseInitialized && !kIsWeb) {
      unawaited(
        FirebaseCrashlytics.instance
            .recordError(error, stackTrace, fatal: true)
            .catchError((Object reportError, StackTrace reportStack) {
          debugPrint('Crashlytics startup error reporting failed: $reportError');
        }),
      );
    }
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
