# Fix Android/Gradle SSL on this Windows machine (SebatPM)
# Creates a user-local Java truststore from Windows ROOT + site certs,
# points %USERPROFILE%\.gradle\gradle.properties at it, seeds Gradle zip.

$ErrorActionPreference = 'Continue'
$javaHome = if (Test-Path 'C:\Program Files\Android\Android Studio1\jbr') {
  'C:\Program Files\Android\Android Studio1\jbr'
} elseif (Test-Path 'C:\Program Files\Android\Android Studio\jbr') {
  'C:\Program Files\Android\Android Studio\jbr'
} else {
  throw 'Android Studio JBR not found'
}

$env:JAVA_HOME = $javaHome
$env:Path = "$javaHome\bin;$env:Path"
$keytool = Join-Path $javaHome 'bin\keytool.exe'
$srcCacerts = Join-Path $javaHome 'lib\security\cacerts'
$destDir = Join-Path $env:USERPROFILE '.gradle\ssl'
$destCacerts = Join-Path $destDir 'cacerts'
New-Item -ItemType Directory -Force -Path $destDir | Out-Null
Copy-Item $srcCacerts $destCacerts -Force

function Save-ServerCert([string]$hostUrl, [string]$outFile) {
  $req = [System.Net.HttpWebRequest]::Create($hostUrl)
  $req.Method = 'HEAD'
  $req.Timeout = 20000
  try {
    $resp = $req.GetResponse()
    $resp.Close()
  } catch [System.Net.WebException] {
    if ($null -ne $_.Exception.Response) { $_.Exception.Response.Close() }
  }
  $cert = $req.ServicePoint.Certificate
  if ($null -eq $cert) { Write-Host "NO_CERT $hostUrl"; return }
  [IO.File]::WriteAllBytes($outFile, $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
  Write-Host "Saved cert for $hostUrl"
}

$i = 0
foreach ($h in @(
    'https://services.gradle.org',
    'https://plugins.gradle.org',
    'https://repo.maven.apache.org',
    'https://dl.google.com',
    'https://maven.google.com'
  )) {
  $cer = Join-Path $destDir "host-$i.cer"
  Save-ServerCert $h $cer
  if (Test-Path $cer) {
    & $keytool -importcert -noprompt -alias "sebatpm-host-$i" -file $cer -keystore $destCacerts -storepass changeit | Out-Null
  }
  $i++
}

$rootStore = New-Object System.Security.Cryptography.X509Certificates.X509Store('Root', 'LocalMachine')
$rootStore.Open('ReadOnly')
foreach ($c in $rootStore.Certificates) {
  if ($c.Subject -match 'ISRG|DigiCert|Let.s Encrypt|Google Trust|Starfield|Amazon|Microsoft|USERTrust|Sectigo|GlobalSign|VeriSign|Entrust|Avast|AVG|Web/Mail Shield') {
    $alias = ('winroot-' + $c.Thumbprint.Substring(0, 16)).ToLower()
    $cer = Join-Path $destDir "$alias.cer"
    [IO.File]::WriteAllBytes($cer, $c.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
    & $keytool -importcert -noprompt -alias $alias -file $cer -keystore $destCacerts -storepass changeit 2>&1 | Out-Null
  }
}
$rootStore.Close()

# CurrentUser Root (Avast often installs shield root here)
$userRoot = New-Object System.Security.Cryptography.X509Certificates.X509Store('Root', 'CurrentUser')
$userRoot.Open('ReadOnly')
foreach ($c in $userRoot.Certificates) {
  if ($c.Subject -match 'Avast|AVG|Web/Mail Shield') {
    $alias = ('avast-user-' + $c.Thumbprint.Substring(0, 16)).ToLower()
    $cer = Join-Path $destDir "$alias.cer"
    [IO.File]::WriteAllBytes($cer, $c.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
    & $keytool -importcert -noprompt -alias $alias -file $cer -keystore $destCacerts -storepass changeit 2>&1 | Out-Null
  }
}
$userRoot.Close()

$trustPath = $destCacerts.Replace('\', '/')
@"
org.gradle.jvmargs=-Xmx4G -Dfile.encoding=UTF-8
systemProp.javax.net.ssl.trustStore=$trustPath
systemProp.javax.net.ssl.trustStorePassword=changeit
"@ | Set-Content (Join-Path $env:USERPROFILE '.gradle\gradle.properties') -Encoding ASCII

# Seed Gradle 9.1.0-bin distribution (avoid first SSL download)
$binZip = Join-Path $env:TEMP 'gradle-9.1.0-bin.zip'
if (-not (Test-Path $binZip) -or ((Get-Item $binZip).Length -lt 1MB)) {
  Write-Host 'Downloading gradle-9.1.0-bin.zip via curl...'
  curl.exe -L --ssl-no-revoke --retry 3 -o $binZip 'https://services.gradle.org/distributions/gradle-9.1.0-bin.zip'
  if (-not (Test-Path $binZip) -or ((Get-Item $binZip).Length -lt 1MB)) {
    Write-Host 'ERROR: Gradle zip download failed'
    exit 1
  }
}

Write-Host 'SSL truststore ready:'
Write-Host "  $destCacerts"
Write-Host 'Gradle properties updated:'
Write-Host "  $env:USERPROFILE\.gradle\gradle.properties"
Write-Host ''
Write-Host 'IMPORTANT: before flutter/gradle commands, clear sandbox leftovers:'
Write-Host '  Remove-Item Env:GRADLE_OPTS -ErrorAction SilentlyContinue'
Write-Host '  $env:GRADLE_USER_HOME = "$env:USERPROFILE\.gradle"'
Write-Host '  $store = "$env:USERPROFILE\.gradle\ssl\cacerts".Replace("\","/")'
Write-Host '  $env:JAVA_TOOL_OPTIONS = "-Djavax.net.ssl.trustStore=$store -Djavax.net.ssl.trustStorePassword=changeit -Djavax.net.ssl.trustStoreType=JKS"'
Write-Host '  $env:GRADLE_OPTS = $env:JAVA_TOOL_OPTIONS'
Write-Host ''
Write-Host 'Next:'
Write-Host '  cd apps\mobile'
Write-Host '  flutter build apk --debug'
Write-Host '  flutter run -d emulator-5554'
exit 0
