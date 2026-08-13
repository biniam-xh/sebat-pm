// Example Firebase options for SebatPM (dev).
//
// Setup:
//   1. Copy this file to lib/firebase_options.dart
//      OR run: dart run flutterfire_cli:flutterfire configure --project=<your-dev-project>
//   2. Never commit lib/firebase_options.dart (gitignored).
//
// Placeholder values below compile but will NOT talk to a real project.
// Replace via FlutterFire before running against Firebase.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform. '
          'Run FlutterFire configure for your targets.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_ME_WEB_API_KEY',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'sebatpm-dev',
    authDomain: 'sebatpm-dev.firebaseapp.com',
    storageBucket: 'sebatpm-dev.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME_ANDROID_API_KEY',
    appId: '1:000000000000:android:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'sebatpm-dev',
    storageBucket: 'sebatpm-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME_IOS_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'sebatpm-dev',
    storageBucket: 'sebatpm-dev.appspot.com',
    iosBundleId: 'com.sebatpm.sebatpm',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_ME_MACOS_API_KEY',
    appId: '1:000000000000:ios:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'sebatpm-dev',
    storageBucket: 'sebatpm-dev.appspot.com',
    iosBundleId: 'com.sebatpm.sebatpm',
  );
}
