import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration for the Deutsch Bangla project.
///
/// Android values match config/firebase/google-services.json. The CI workflow
/// copies that file into android/app before building.
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
    return const FirebaseOptions(
      apiKey: 'AIzaSyDOWlnE1mtRXiIexFqJV7eyDnkGdcRf-E0',
      appId: '1:494035129938:android:8d99f657a320aabcb4718b',
      messagingSenderId: '494035129938',
      projectId: 'deutsch-bangla',
      storageBucket: 'deutsch-bangla.firebasestorage.app',
    );
  }
}
