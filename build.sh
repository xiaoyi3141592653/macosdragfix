#!/bin/bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
  echo "This script does not accept arguments." >&2
  exit 2
fi

PROJECT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
BUILD_DIR="$(mktemp -d "$PROJECT_DIR/.build.XXXXXX")"
trap 'rm -rf "$BUILD_DIR"' EXIT

swiftc -O -o "$BUILD_DIR/macosdragfix" "$PROJECT_DIR/macosdragfix.swift" \
  -framework ApplicationServices -framework CoreGraphics
codesign --force --sign - --identifier it.m6i.macosdragfix "$BUILD_DIR/macosdragfix"
codesign --verify --strict "$BUILD_DIR/macosdragfix"
mv -f "$BUILD_DIR/macosdragfix" "$PROJECT_DIR/macosdragfix"
echo "Built and signed: $PROJECT_DIR/macosdragfix"
echo "After rebuilding, Accessibility permission may need to be granted again."