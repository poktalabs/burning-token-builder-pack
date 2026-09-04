#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST="$ROOT/scripts/onboard-hermes-telegram.sh"
VM="$ROOT/scripts/onboard-telegram-agent"

bash -n "$HOST"
bash -n "$VM"
test -x "$HOST"
test -x "$VM"
"$HOST" --help | grep -q 'Usage: onboard-hermes-telegram.sh'
"$VM" --help | grep -q 'Usage: onboard-telegram-agent'
! rg -n '(NEBIUS_API_KEY=.+[^}]|TELEGRAM_BOT_TOKEN=.+[^}]|GATEWAY_ALLOW_ALL_USERS=true)' "$ROOT/scripts" >/dev/null

echo 'Hermes Telegram onboarding package checks passed'
