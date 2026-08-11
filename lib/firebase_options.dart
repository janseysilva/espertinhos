// Placeholder — generated for real by running `flutterfire configure`
// from the project root once you have a Firebase project. See README.md.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web não configurado. Rode flutterfire configure.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4I861LaQT9bOBtkwvrzD70iXovpBW5uY',
    appId: '1:673534519075:android:62ba240ab8a9cef3764e96',
    messagingSenderId: '673534519075',
    projectId: 'espertinhos-app-2026',
    storageBucket: 'espertinhos-app-2026.firebasestorage.app',
  );
}
