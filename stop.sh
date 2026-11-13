#!/bin/bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "This script does not accept arguments." >&2
  exit 2
fi

SERVICE="gui/$(id -u)/it.m6i.macosdragfix"
if launchctl print "$SERVICE" >/dev/null 2>&1; then
  launchctl bootout "$SERVICE"
fi
if pkill -x macosdragfix; then
  :
else
  EXIT_CODE=$?
  if [[ $EXIT_CODE -ne 1 ]]; then
    exit "$EXIT_CODE"
  fi
fi
echo "Stopped macosdragfix. Login registration is unchanged."