/// Signed-in user as seen by the client UI (not a Firestore model).
class AuthUser {
  const AuthUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
}
