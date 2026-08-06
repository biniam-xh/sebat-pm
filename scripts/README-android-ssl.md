# Android SSL fix (Windows + Avast)

Gradle/Java often fail HTTPS downloads when **Avast Web Shield** intercepts TLS (`Issuer: Avast Web/Mail Shield Root`). Browsers trust Avast’s root; the Android Studio JBR does not by default.

## One-time fix

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/fix-android-ssl.ps1
```

This builds `%USERPROFILE%\.gradle\ssl\cacerts` (JBR cacerts + Windows/Avast roots) and points `%USERPROFILE%\.gradle\gradle.properties` at it.

## Every new shell before Flutter/Gradle

Cursor sandboxes sometimes set `GRADLE_OPTS=Windows-ROOT` and a temp `GRADLE_USER_HOME`. Clear them:

```powershell
Remove-Item Env:GRADLE_OPTS -ErrorAction SilentlyContinue
$env:GRADLE_USER_HOME = "$env:USERPROFILE\.gradle"
$store = "$env:USERPROFILE\.gradle\ssl\cacerts".Replace('\','/')
$env:JAVA_TOOL_OPTIONS = "-Djavax.net.ssl.trustStore=$store -Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.trustStoreType=JKS"
$env:GRADLE_OPTS = $env:JAVA_TOOL_OPTIONS
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio1\jbr"  # or your JBR path
```

Then:

```powershell
cd apps\mobile
flutter build apk --debug
flutter run -d emulator-5554
```

## Alternative

Temporarily disable Avast **HTTPS scanning** / Web Shield while building.
