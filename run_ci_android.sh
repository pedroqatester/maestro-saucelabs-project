#!/bin/bash
set -e

echo "Installing APK..."
adb install -r app.apk

echo "Waiting for app to settle..."
sleep 15

echo "Running Maestro tests..."
maestro test .maestro \
  --include-tags=smoke \
  --format junit \
  --output report-android.xml \
  -e MAESTRO_USERNAME="$MAESTRO_USERNAME" \
  -e MAESTRO_PASSWORD="$MAESTRO_PASSWORD" \
  -e MAESTRO_LOCKED_USERNAME="$MAESTRO_LOCKED_USERNAME" \
  -e MAESTRO_LOCKED_PASSWORD="$MAESTRO_LOCKED_PASSWORD" \
  -e MAESTRO_EMAIL_DOMAIN="$MAESTRO_EMAIL_DOMAIN" \
  -e MAESTRO_CARD_NUMBER="$MAESTRO_CARD_NUMBER" \
  -e MAESTRO_CARD_EXPIRATION="$MAESTRO_CARD_EXPIRATION" \
  -e MAESTRO_CARD_CVV="$MAESTRO_CARD_CVV"