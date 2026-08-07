import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:sebatpm/firebase_options.dart';

/// Initializes Firebase for the active flavor (dev by default).
///
/// Requires a local `lib/firebase_options.dart` generated via FlutterFire
/// (see `docs/setup/firebase-dev.md`). That file is gitignored.
Future<FirebaseApp> initializeSebatFirebase() async {
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    debugPrint('Firebase initialized: ${app.name} (${app.options.projectId})');
  }
  return app;
}
