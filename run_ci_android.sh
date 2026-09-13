#!/bin/bash
set -e

# Aguarda o emulador conectar
adb wait-for-device

# Aguarda o boot completo
echo "Waiting for Android boot to complete..."
while [ "$(adb shell getprop sys.boot_completed 2>/dev/null)" != "1" ]; do
  sleep 3
done
echo "Boot completed."

# Aguarda o System UI estar pronto
echo "Waiting for System UI..."
while [ "$(adb shell dumpsys activity | grep -c 'mHeavyWeightProcess')" = "0" ]; do
  sleep 2
done

# Aguarda o package manager estar pronto
adb shell pm path com.android.systemui > /dev/null 2>&1 || true
sleep 15

adb install app.apk

# Descarta qualquer dialog de ANR que apareça
adb shell input keyevent 4 || true
sleep 3

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