#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter is required. Install the current stable Flutter SDK and retry." >&2
  exit 1
fi

printf '\nInstalling shared package dependencies...\n'
(
  cd "$ROOT_DIR/packages/biloo_domain"
  flutter pub get
)
(
  cd "$ROOT_DIR/packages/biloo_ui"
  flutter pub get
)

for app in customer_app driver_app vendor_app; do
  APP_DIR="$ROOT_DIR/apps/$app"
  printf '\nPreparing %s...\n' "$app"
  (
    cd "$APP_DIR"
    if [[ ! -d android || ! -d ios ]]; then
      flutter create \
        --platforms=android,ios \
        --org=com.biloo \
        --project-name="biloo_${app}" \
        .
    fi
    flutter pub get
  )
done

printf '\nBiloo Delivery workspace is ready.\n'
printf 'Run: make analyze && make test\n'
