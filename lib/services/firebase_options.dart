import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration for the Deutsch Bangla project.
///
/// The supplied Web SDK values are included for web builds. Android requires
/// the Android app ID from Firebase Console; pass it as
/// --dart-define=FIREBASE_ANDROID_APP_ID=1:...:android:...
/// The Android API key can be overridden with FIREBASE_ANDROID_API_KEY.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDjuWLq2K7_yd2gipYP0-wO55e_GCr5F3w',
        appId: '1:494035129938:web:1fff59aaa0f32733b4718b',
        messagingSenderId: '494035129938',
        projectId: 'deutsch-bangla',
        authDomain: 'deutsch-bangla.firebaseapp.com',
        storageBucket: 'deutsch-bangla.firebasestorage.app',
        measurementId: 'G-215BMBRYDR',
      );
    }
    const androidAppId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
    if (androidAppId.isEmpty) {
      throw StateError(
        'Firebase Android app ID is missing. Register the Android app in '
        'Firebase Console and pass FIREBASE_ANDROID_APP_ID with --dart-define.',
      );
    }
    return const FirebaseOptions(
      apiKey: String.fromEnvironment(
        'FIREBASE_ANDROID_API_KEY',
        defaultValue: 'AIzaSyDjuWLq2K7_yd2gipYP0-wO55e_GCr5F3w',
      ),
      appId: androidAppId,
      messagingSenderId: '494035129938',
      projectId: 'deutsch-bangla',
      storageBucket: 'deutsch-bangla.firebasestorage.app',
    );
  }
}
