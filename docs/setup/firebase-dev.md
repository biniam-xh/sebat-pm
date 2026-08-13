# Firebase `dev` setup (SebatPM)

Goal: point `apps/mobile` at a Firebase **dev** project without committing secrets.

Gitignored (never commit):

- `apps/mobile/lib/firebase_options.dart`
- `apps/mobile/android/app/google-services.json`
- `apps/mobile/ios/Runner/GoogleService-Info.plist`

## Prerequisites

- Flutter SDK
- A Google account
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/):  
  `dart pub global activate flutterfire_cli`  
  Ensure these are on your `PATH`:
  - `C:\flutter\bin`
  - `%LOCALAPPDATA%\Pub\Cache\bin`
  - `%APPDATA%\npm` (for `firebase`)

### Avast / SSL (this machine)

If `firebase projects:list` fails with **unable to verify the first certificate**, Avast Web Shield is intercepting TLS. In that shell set:

```powershell
$env:NODE_EXTRA_CA_CERTS = "$env:USERPROFILE\.gradle\ssl\avast-web-shield-root.pem"
```

(Create the PEM via `scripts/fix-android-ssl.ps1` / prior SSL fix, or temporarily disable Avast HTTPS scanning.)

## 1. Create a Firebase project

1. Open [Firebase Console](https://console.firebase.google.com/).
2. Create project (this repo’s current id: **`sebatpm-dev-a8ff0`**).
3. Enable:
   - **Authentication → Sign-in method → Google** (required for T-004)
   - Cloud Firestore (create DB; use test mode for local MVP or rules that allow authenticated `users/{uid}` writes)
   - Storage
   - Cloud Messaging

### Android Google Sign-In (SHA fingerprints)

Google Sign-In on Android needs the app’s SHA-1 (and preferably SHA-256) on the Firebase Android app. Without them, `google-services.json` has an empty `oauth_client` list and sign-in fails.

1. Print the **debug** keystore fingerprints:

```powershell
keytool -list -v -alias androiddebugkey `
  -keystore "$env:USERPROFILE\.android\debug.keystore" `
  -storepass android -keypass android
```

2. Firebase Console → Project settings → Your apps → Android (`com.sebatpm.sebatpm`) → **Add fingerprint**.
3. Re-download `google-services.json` **or** re-run `flutterfire configure` so `oauth_client` is populated.
4. Confirm Authentication → Google is **Enabled**.

This machine’s current debug SHA-1 (for local emulator builds):

`B5:23:1C:22:54:2E:E1:99:7C:BA:8D:20:43:3C:3A:7A:A6:DD:EA:D1`

### Emulator Google Sign-In tips

1. Use an AVD image with **Google Play** (not plain AOSP).
2. **Update Google Play services** in the Play Store (outdated GMS shows Google’s “Couldn't sign in” screen). Log warning looks like: `Google Play services out of date … Requires X but found Y`.
3. Add a **Google account**: Settings → Passwords & accounts → Add account → Google.
4. Enable **Google** under Firebase Authentication → Sign-in method.

The app passes the Firebase **Web** OAuth client id as `serverClientId` (`lib/firebase/google_sign_in_config.dart`). After regenerating Firebase config, update that constant from the type-3 `client_id` in `google-services.json`.

## 2. Register apps + generate options

From `apps/mobile`:

```powershell
$env:Path = "C:\flutter\bin;$env:LOCALAPPDATA\Pub\Cache\bin;$env:APPDATA\npm;" + $env:Path
$env:NODE_EXTRA_CA_CERTS = "$env:USERPROFILE\.gradle\ssl\avast-web-shield-root.pem"

flutterfire configure --project=sebatpm-dev-a8ff0 --platforms=android,ios,web --yes
```

This writes gitignored `lib/firebase_options.dart` and platform config files.

### Without FlutterFire (fallback)

```powershell
cd apps/mobile
Copy-Item lib\firebase_options.example.dart lib\firebase_options.dart
```

Then replace `REPLACE_ME_*` and app IDs with values from the Firebase console (Project settings → Your apps). Prefer `flutterfire configure` when possible.

Or run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File ..\..\scripts\setup-firebase-options.ps1
```

## 3. Run

```powershell
cd apps/mobile
flutter pub get
flutter run
```

On startup you should see a debug log like:  
`Firebase initialized: [DEFAULT] (sebatpm-dev)`.

## Packages wired (T-003)

| Package | Role |
|---------|------|
| `firebase_core` | Init |
| `firebase_auth` | Auth (T-004) |
| `cloud_firestore` | Data |
| `firebase_storage` | Attachments |
| `firebase_messaging` | FCM |

## Android SSL note

If Gradle HTTPS fails on this machine (Avast Web Shield), see [scripts/README-android-ssl.md](../../scripts/README-android-ssl.md).

## Prod

Use a separate Firebase project (`sebatpm-prod`) and a later flavor / CI secret injection. Out of scope for T-003.
