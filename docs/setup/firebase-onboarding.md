# Firebase `dev` — new developer setup

Use this when you join the shared Firebase project **`sebatpm-dev-a8ff0`**.  
Do **not** create a new Firebase project.

Owner/admin invites you in Firebase Console → **Project settings → Users and permissions** (Editor is enough for app work).

Local config files are **gitignored** — every developer generates their own:

- `apps/mobile/lib/firebase_options.dart`
- `apps/mobile/android/app/google-services.json`
- `apps/mobile/ios/Runner/GoogleService-Info.plist`

Never commit those files.

For project creation history, SSL/Avast notes, and deeper troubleshooting, see [firebase-dev.md](./firebase-dev.md).

---

## 1. Prerequisites

- Flutter SDK
- A Google account that has been added to `sebatpm-dev-a8ff0`
- Node.js (for `firebase` CLI)
- FlutterFire CLI:

```powershell
dart pub global activate flutterfire_cli
npm install -g firebase-tools
```

Ensure `PATH` includes:

- Flutter bin (e.g. `C:\flutter\bin`)
- `%LOCALAPPDATA%\Pub\Cache\bin`
- `%APPDATA%\npm`

---

## 2. Clone and deps

```powershell
cd apps/mobile
flutter pub get
```

---

## 3. Log in and generate Firebase config

From `apps/mobile`:

```powershell
$env:Path = "C:\flutter\bin;$env:LOCALAPPDATA\Pub\Cache\bin;$env:APPDATA\npm;" + $env:Path

firebase login
flutterfire configure --project=sebatpm-dev-a8ff0 --platforms=android,ios,web --yes
```

This writes the gitignored options / platform files listed above.

### Fallback (no FlutterFire)

```powershell
Copy-Item lib\firebase_options.example.dart lib\firebase_options.dart
```

Then replace `REPLACE_ME_*` with values from Firebase Console → Project settings → Your apps. Prefer `flutterfire configure`.

---

## 4. Add *your* Android debug SHA-1

Each machine has its own debug keystore. Without **your** SHA-1, Google Sign-In fails on your phone/emulator even if it works for others.

```powershell
keytool -list -v -alias androiddebugkey `
  -keystore "$env:USERPROFILE\.android\debug.keystore" `
  -storepass android -keypass android
```

1. Copy the **SHA-1** (and preferably SHA-256).
2. Firebase Console → Project settings → Your apps → Android (`com.sebatpm.sebatpm`) → **Add fingerprint**.
3. Re-run `flutterfire configure` **or** re-download `google-services.json` into `android/app/`.

Confirm Authentication → Sign-in method → **Google** is Enabled (usually already done for the shared project).

---

## 5. Run

```powershell
cd apps/mobile
flutter run
```

You should see a debug log like:

`Firebase initialized: [DEFAULT] (sebatpm-dev-a8ff0)`

Cold start shows **Continue with Google** until you sign in.

---

## Checklist

- [ ] Invited to Firebase project `sebatpm-dev-a8ff0`
- [ ] `flutter pub get`
- [ ] `firebase login` + `flutterfire configure --project=sebatpm-dev-a8ff0 …`
- [ ] Own debug SHA-1 added to the Android app
- [ ] `google-services.json` refreshed after adding SHA-1
- [ ] `flutter run` initializes Firebase without crash

---

## Do not

- Create a second Firebase project for personal use (share `sebatpm-dev-a8ff0`)
- Commit `firebase_options.dart`, `google-services.json`, or `GoogleService-Info.plist`
- Expect someone else’s SHA-1 to work on your machine
