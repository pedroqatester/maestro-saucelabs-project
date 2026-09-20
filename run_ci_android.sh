#!/bin/bash

set -e

echo "Installing APK..."
adb install -r app.apk

echo "Waiting for emulator..."
adb wait-for-device

echo "Waiting for Android boot..."
adb shell 'while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 2; done'

echo "Android environment:"
adb shell getprop ro.build.version.sdk
adb shell getprop ro.build.version.release
adb shell getprop ro.product.model
adb shell getprop ro.product.cpu.abi
adb shell getprop ro.product.name
adb shell getprop ro.product.device

echo "Checking emulator..."
adb shell getprop sys.boot_completed

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