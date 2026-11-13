#!/bin/bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "This script does not accept arguments." >&2
  exit 2
fi

PROJECT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
AGENT_DIR="$HOME/Library/LaunchAgents"
AGENT_PATH="$AGENT_DIR/it.m6i.macosdragfix.plist"
DOMAIN="gui/$(id -u)"

if [[ ! -x "$PROJECT_DIR/macosdragfix" ]]; then
  echo "Run build.sh first." >&2
  exit 1
fi
mkdir -p "$AGENT_DIR"
TEMP_DIR="$(mktemp -d "$AGENT_DIR/.macosdragfix.XXXXXX")"
trap 'rm -rf "$TEMP_DIR"' EXIT
cp "$PROJECT_DIR/it.m6i.macosdragfix.plist" "$TEMP_DIR/agent.plist"
plutil -remove ProgramArguments.0 "$TEMP_DIR/agent.plist"
plutil -insert ProgramArguments.0 -string "$PROJECT_DIR/macosdragfix" "$TEMP_DIR/agent.plist"
plutil -lint "$TEMP_DIR/agent.plist"
chmod 644 "$TEMP_DIR/agent.plist"
"$PROJECT_DIR/stop.sh"
mv -f "$TEMP_DIR/agent.plist" "$AGENT_PATH"
launchctl enable "$DOMAIN/it.m6i.macosdragfix"
launchctl bootstrap "$DOMAIN" "$AGENT_PATH"
echo "Registered for login and start requested: $AGENT_PATH"
echo "Log: /tmp/macosdragfix.log"