#!/bin/bash
set -e
CONFIG="/etc/svc/config.json"
TOKEN_FILE="/etc/svc/tunnel.token"
/usr/local/bin/svc run -c "$CONFIG" &
SVC_PID=$!
if [[ -f "$TOKEN_FILE" ]]; then
  TOKEN="$(cat "$TOKEN_FILE")"
  if [[ -n "$TOKEN" ]]; then
    exec /usr/local/bin/cfd tunnel --no-autoupdate run --token "$TOKEN"
  fi
fi
wait "$SVC_PID"
