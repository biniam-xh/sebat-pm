# SebatPM mobile

Flutter client for SebatPM (Chat + Projects dual-mode).

## Setup

1. `flutter pub get`
2. Firebase `dev` config:
   - **New teammates:** [docs/setup/firebase-onboarding.md](../../docs/setup/firebase-onboarding.md)
   - Full / troubleshooting: [docs/setup/firebase-dev.md](../../docs/setup/firebase-dev.md)  
   (creates gitignored `lib/firebase_options.dart`)
3. Enable **Google** in Firebase Auth and add **your** Android **SHA-1** fingerprint (see onboarding doc)
4. `flutter run` — cold start shows Google sign-in until a session exists

## Android SSL (this machine)

If Gradle fails with PKIX / SSL errors, see [scripts/README-android-ssl.md](../../scripts/README-android-ssl.md).
