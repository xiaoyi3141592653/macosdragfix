#!/bin/bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "This script does not accept arguments." >&2
  exit 2
fi

PROJECT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
"$PROJECT_DIR/stop.sh"
rm -f "$HOME/Library/LaunchAgents/it.m6i.macosdragfix.plist"
echo "Removed login registration."