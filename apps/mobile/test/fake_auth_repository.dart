import 'dart:async';

import 'package:sebatpm/features/auth/auth_repository.dart';
import 'package:sebatpm/features/auth/auth_user.dart';

/// In-memory auth for widget tests (no Firebase).
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AuthUser? initialUser}) : _user = initialUser {
    _controller = StreamController<AuthUser?>.broadcast(
      onListen: () => _controller.add(_user),
    );
  }

  factory FakeAuthRepository.signedIn({
    String uid = 'test-uid',
    String email = 'tester@example.com',
  }) {
    return FakeAuthRepository(
      initialUser: AuthUser(uid: uid, email: email, displayName: 'Tester'),
    );
  }

  factory FakeAuthRepository.signedOut() => FakeAuthRepository();

  late final StreamController<AuthUser?> _controller;
  AuthUser? _user;
  int signInCalls = 0;
  int signOutCalls = 0;
  bool failSignIn = false;

  @override
  Stream<AuthUser?> authStateChanges() => _controller.stream;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> signInWithGoogle() async {
    signInCalls++;
    if (failSignIn) {
      throw StateError('Fake Google Sign-In failed');
    }
    _user = const AuthUser(
      uid: 'test-uid',
      email: 'tester@example.com',
      displayName: 'Tester',
    );
    _controller.add(_user);
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    _user = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
