#!/bin/bash
set -e

# Aguarda o emulador conectar
adb wait-for-device

# Aguarda o boot completo do Android (sys.boot_completed = 1)
echo "Waiting for Android boot to complete..."
while [ "$(adb shell getprop sys.boot_completed 2>/dev/null)" != "1" ]; do
  sleep 3
done
echo "Boot completed."

# Aguarda mais 5 segundos pra garantir que os serviços subiram
sleep 5

adb install app.apk

adb shell am start -n com.saucelabs.mydemoapp.rn/.MainActivity
sleep 5
adb exec-out screencap -p > /tmp/screen.png

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