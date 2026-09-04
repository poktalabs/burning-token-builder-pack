#!/usr/bin/env bash
# Launch a private Hermes + Pi sandbox and enter its Telegram bootstrapper.
set -euo pipefail

DEFAULT_IMAGE_REF="mlxs8y/hermes-nebius-workshop@sha256:e527cba4aa6e156cffc43d153b782fc473a420f2fde67d1a58bffe853f2735bd"
TENKI_BIN="${TENKI_BIN:-${HOME}/.local/bin/tenki}"
IMAGE_REF="${IMAGE_REF:-$DEFAULT_IMAGE_REF}"
NAME=""
IDLE_TIMEOUT="15m"
MAX_DURATION="2h"

usage() {
  cat <<'EOF'
Usage: onboard-hermes-telegram.sh [options]

Create a disposable Tenki sandbox from the registered Hermes + Pi image,
then open managed SSH directly into the in-VM Telegram bootstrapper.

Options:
  --name NAME             Sandbox name (default: hermes-telegram-<timestamp>)
  --image IMAGE_REF       Immutable Tenki registry image reference
  --idle-timeout DURATION Idle timeout (default: 15m)
  --max-duration DURATION Maximum duration (default: 2h)
  --help                  Show this help

The script validates the Tenki CLI and login before creation. It never accepts,
stores, or forwards provider or Telegram credentials. You enter them only after
managed SSH opens inside the sandbox.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="${2:?missing value for --name}"; shift 2 ;;
    --image) IMAGE_REF="${2:?missing value for --image}"; shift 2 ;;
    --idle-timeout) IDLE_TIMEOUT="${2:?missing value for --idle-timeout}"; shift 2 ;;
    --max-duration) MAX_DURATION="${2:?missing value for --max-duration}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage; exit 2 ;;
  esac
done

[[ -n "$NAME" ]] || NAME="hermes-telegram-$(date +%Y%m%d-%H%M%S)"
[[ -x "$TENKI_BIN" ]] || { printf 'Tenki CLI not found or not executable: %s\n' "$TENKI_BIN" >&2; exit 1; }

STATUS="$($TENKI_BIN status 2>&1)" || { printf '%s\n' "$STATUS" >&2; exit 1; }
printf '%s\n' "$STATUS" | grep -q 'Status       : Logged in' || {
  printf 'Tenki is not authenticated. Run: %s login\n' "$TENKI_BIN" >&2
  exit 1
}

CREATE_JSON="$($TENKI_BIN sandbox create \
  --image "$IMAGE_REF" \
  --name "$NAME" \
  --cpu 2 \
  --memory-mb 4096 \
  --disk-size-gb 20 \
  --allow-inbound=false \
  --allow-outbound=true \
  --idle-timeout "$IDLE_TIMEOUT" \
  --max-duration "$MAX_DURATION" \
  --metadata purpose=hermes-telegram-onboarding \
  --metadata lifecycle=operator-controlled \
  --json)"
printf '%s\n' "$CREATE_JSON"

printf '\nSandbox %s is ready. Opening managed SSH onboarding now.\n\n' "$NAME"
"$TENKI_BIN" sandbox ssh --session "$NAME" -- /home/tenki/.local/bin/onboard-telegram-agent
ssh_exit=$?

cat <<EOF

Managed SSH ended (exit $ssh_exit).
Gateway controls, if it was started:
  $TENKI_BIN sandbox ssh --session $NAME -- workshop-agent status
  $TENKI_BIN sandbox ssh --session $NAME -- workshop-agent stop

Terminate the disposable sandbox when you are done:
  $TENKI_BIN sandbox terminate --session $NAME
EOF
exit "$ssh_exit"
