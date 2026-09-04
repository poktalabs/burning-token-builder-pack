#!/usr/bin/env bash
# Launch a private Hermes + Pi sandbox and enter its Telegram bootstrapper.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_IMAGE_REF="mlxs8y/hermes-telegram-tenki-onboarding@b2e9cbf0-a0b6-49ff-a034-1ab68f97f74f"
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

printf '\nSandbox %s is ready. Opening managed SSH for the Hermes + Nebius hello-world check.\n\n' "$NAME"
EXPECT_BIN="$(command -v expect || true)"
[[ -n "$EXPECT_BIN" ]] || { printf 'The local expect utility is required for the interactive SSH handoff.\n' >&2; exit 1; }
"$EXPECT_BIN" "$ROOT/scripts/managed-ssh-bootstrap.exp" "$TENKI_BIN" "$NAME" onboard-hermes-nebius
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
