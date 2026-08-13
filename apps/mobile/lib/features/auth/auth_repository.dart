import 'package:sebatpm/features/auth/auth_user.dart';

/// Auth boundary for Track S (Google Sign-In first).
abstract class AuthRepository {
  /// Emits the current session; null means signed out.
  Stream<AuthUser?> authStateChanges();

  AuthUser? get currentUser;

  /// Interactive Google Sign-In → Firebase session + `users/{uid}` upsert.
  Future<void> signInWithGoogle();

  Future<void> signOut();
}
