import 'package:flutter/material.dart';

import 'package:sebatpm/features/auth/auth_repository.dart';
import 'package:sebatpm/features/auth/auth_user.dart';
import 'package:sebatpm/features/auth/sign_in_screen.dart';

/// Gates the dual-mode shell behind a Firebase Auth session.
class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.authRepository,
    required this.child,
  });

  final AuthRepository authRepository;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: authRepository.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          final existing = authRepository.currentUser;
          if (existing != null) {
            return child;
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return SignInScreen(authRepository: authRepository);
        }

        return child;
      },
    );
  }
}
