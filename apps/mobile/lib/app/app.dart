import 'package:flutter/material.dart';

import 'package:sebatpm/app/app_shell.dart';
import 'package:sebatpm/app/router.dart';
import 'package:sebatpm/app/theme.dart';
import 'package:sebatpm/features/auth/auth_gate.dart';
import 'package:sebatpm/features/auth/auth_repository.dart';
import 'package:sebatpm/features/auth/auth_scope.dart';
import 'package:sebatpm/features/auth/firebase_auth_repository.dart';

/// App bootstrap: theme + auth gate + routing stubs.
class SebatPmApp extends StatelessWidget {
  const SebatPmApp({super.key, this.authRepository});

  /// Injectable for tests; defaults to [FirebaseAuthRepository].
  final AuthRepository? authRepository;

  @override
  Widget build(BuildContext context) {
    final auth = authRepository ?? FirebaseAuthRepository();

    return AuthScope(
      repository: auth,
      child: MaterialApp(
        title: 'SebatPM',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: AuthGate(
          authRepository: auth,
          child: const AppShell(),
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
