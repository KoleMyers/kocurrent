#!/usr/bin/env bash
# Copy jitsi-config.js from the repo into the Jitsi web config dir so the container uses it.
# Run from repo root on the server (e.g. ~/kocurrent). Creates the target dir if needed.
#
# Usage:
#   ./scripts/copy-jitsi-config.sh
#   CONFIG=/path/to/jitsi-cfg ./scripts/copy-jitsi-config.sh
#
# Default destination: $CONFIG/web/config/config.js (CONFIG defaults to ./jitsi-cfg).
# To copy to jitsi-cfg/web/config.js instead, set: DEST=/path/to/jitsi-cfg/web/config.js
# Then reload or restart the web container so nginx serves the new config.

set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${CONFIG:-$REPO_ROOT/jitsi-cfg}"
SRC="${1:-$REPO_ROOT/jitsi-config.js}"
if [[ -n "$DEST" ]]; then
  DEST_DIR="$(dirname "$DEST")"
else
  DEST_DIR="$CONFIG/web/config"
  DEST="$DEST_DIR/config.js"
fi

if [[ ! -f "$SRC" ]]; then
  echo "Source not found: $SRC"
  exit 1
fi

mkdir -p "$DEST_DIR"
cp "$SRC" "$DEST"
echo "Copied $SRC -> $DEST"

if command -v docker >/dev/null 2>&1; then
  if docker compose -f "$REPO_ROOT/docker-compose.yml" ps web -q 2>/dev/null | head -1 | grep -q .; then
    echo "Reload web container to apply: docker compose exec web nginx -s reload"
    echo "Or restart: docker compose restart web"
  fi
fi
