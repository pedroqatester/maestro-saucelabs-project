#!/bin/bash
set -e
export $(grep -v '^#' .env | xargs)

PLATFORM="${1:-android}"
TAGS="${2:-}"
FILE="${3:-}"

IOS_ARGS=(
  --device C7C3C4F1-F44D-424B-8349-8D14BE68E454
  -e "MAESTRO_USERNAME=$MAESTRO_USERNAME"
  -e "MAESTRO_PASSWORD=$MAESTRO_PASSWORD"
  -e "MAESTRO_LOCKED_USERNAME=$MAESTRO_LOCKED_USERNAME"
  -e "MAESTRO_LOCKED_PASSWORD=$MAESTRO_LOCKED_PASSWORD"
)

if [ -n "$FILE" ]; then
  TARGET=".maestro/flows/$FILE"
else
  TARGET=".maestro"
fi

if [ -n "$TAGS" ]; then
  TAG_ARG="--include-tags=$TAGS"
else
  TAG_ARG=""
fi

if [ "$PLATFORM" = "ios" ]; then
  maestro test "$TARGET" "${IOS_ARGS[@]}" $TAG_ARG
else
  maestro test "$TARGET" $TAG_ARG
fi