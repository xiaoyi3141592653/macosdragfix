#!/bin/bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "This script does not accept arguments." >&2
  exit 2
fi

PROJECT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
AGENT_PATH="$HOME/Library/LaunchAgents/it.m6i.macosdragfix.plist"
DOMAIN="gui/$(id -u)"

if [[ ! -x "$PROJECT_DIR/macosdragfix" ]]; then
  echo "Run build.sh first." >&2
  exit 1
fi
"$PROJECT_DIR/stop.sh"
if [[ -f "$AGENT_PATH" ]]; then
  launchctl enable "$DOMAIN/it.m6i.macosdragfix"
  launchctl bootstrap "$DOMAIN" "$AGENT_PATH"
else
  nohup "$PROJECT_DIR/macosdragfix" --xoffset 10 --yoffset 8 \
    >>/tmp/macosdragfix.log 2>&1 </dev/null &
fi
echo "Start requested. Log: /tmp/macosdragfix.log"
echo "If Accessibility is not granted, the process waits for permission."