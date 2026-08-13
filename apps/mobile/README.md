# SebatPM mobile

Flutter client for SebatPM (Chat + Projects dual-mode).

## Setup

1. `flutter pub get`
2. Firebase `dev` config: follow [docs/setup/firebase-dev.md](../../docs/setup/firebase-dev.md)  
   (creates gitignored `lib/firebase_options.dart`)
3. Enable **Google** in Firebase Auth and add the Android **SHA-1** fingerprint (see setup doc)
4. `flutter run` — cold start shows Google sign-in until a session exists

## Android SSL (this machine)

If Gradle fails with PKIX / SSL errors, see [scripts/README-android-ssl.md](../../scripts/README-android-ssl.md).
