# Copy example Firebase options for local builds (gitignored output).
# Prefer: dart pub global run flutterfire_cli:flutterfire configure --project=<id>

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$mobile = Join-Path $root 'apps\mobile'
$example = Join-Path $mobile 'lib\firebase_options.example.dart'
$dest = Join-Path $mobile 'lib\firebase_options.dart'

if (-not (Test-Path $example)) {
  throw "Missing example: $example"
}

if (Test-Path $dest) {
  Write-Host "Already exists (left unchanged): $dest"
  exit 0
}

Copy-Item $example $dest
Write-Host "Created $dest from example."
Write-Host "Replace REPLACE_ME_* values or re-run FlutterFire configure before hitting real Firebase."
