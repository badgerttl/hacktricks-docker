#!/usr/bin/env bash
set -e

# Use podman if available, otherwise docker
if command -v podman &>/dev/null; then
  ENGINE=podman
elif command -v docker &>/dev/null; then
  ENGINE=docker
else
  echo "Error: need podman or docker in PATH" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Building with $ENGINE..."
$ENGINE build -t hacktricks-arm64 .

CONTAINER_NAME=my-hacktricks
$ENGINE rm -f "$CONTAINER_NAME" 2>/dev/null || true

echo "Starting container..."
$ENGINE run --rm -d -p 3337:3337 -v "$SCRIPT_DIR/hacktricks:/app" --name "$CONTAINER_NAME" hacktricks-arm64

echo "Done. HackTricks is serving at http://localhost:3337"