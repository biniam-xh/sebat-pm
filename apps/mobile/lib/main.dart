import 'package:flutter/widgets.dart';

import 'package:sebatpm/app/app.dart';
import 'package:sebatpm/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSebatFirebase();
  runApp(const SebatPmApp());
}
