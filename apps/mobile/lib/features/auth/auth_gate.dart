import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sebatpm/data/team/team_bootstrap.dart';
import 'package:sebatpm/features/auth/auth_repository.dart';
import 'package:sebatpm/features/auth/auth_user.dart';
import 'package:sebatpm/features/auth/sign_in_screen.dart';

/// Gates the dual-mode shell behind a Firebase Auth session.
class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    required this.authRepository,
    required this.child,
  });

  final AuthRepository authRepository;
  final Widget child;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _workspaceBootstrapped = false;

  Future<void> _ensureWorkspaceBootstrapped() async {
    if (_workspaceBootstrapped) {
      return;
    }

    _workspaceBootstrapped = true;
    try {
      await const TeamBootstrap().ensureReady();
    } catch (_) {
      // Preserve the auth flow even if bootstrap fails; the app can retry.
      _workspaceBootstrapped = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser?>(
      stream: widget.authRepository.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          final existing = widget.authRepository.currentUser;
          if (existing != null) {
            unawaited(_ensureWorkspaceBootstrapped());
            return widget.child;
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          _workspaceBootstrapped = false;
          return SignInScreen(authRepository: widget.authRepository);
        }

        unawaited(_ensureWorkspaceBootstrapped());
        return widget.child;
      },
    );
  }
}
