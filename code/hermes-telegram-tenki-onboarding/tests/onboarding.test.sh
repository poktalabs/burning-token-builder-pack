#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST="$ROOT/scripts/onboard-hermes-telegram.sh"
VM="$ROOT/scripts/onboard-telegram-agent"

SSH_HELPER="$ROOT/scripts/managed-ssh-bootstrap.exp"

bash -n "$HOST"
grep -q '^ROOT=' "$HOST"
EXPECT_PARSE_ONLY=1 SSH_HELPER="$SSH_HELPER" expect -c 'source $env(SSH_HELPER)'
test -x "$HOST"
test -x "$VM"
test -f "$SSH_HELPER"
! grep -q ' -f - ' "$HOST"
grep -q '"$EXPECT_BIN" "$ROOT/scripts/managed-ssh-bootstrap.exp" "$TENKI_BIN" "$NAME" onboarding-telegram-agent' "$HOST"
grep -q 'contains a control character' "$VM"
grep -q '\[\[:cntrl:\]\]' "$VM"
grep -q 'validate the Telegram bot token' "$VM"
! grep -q 'sandbox ssh --session "$NAME" -- /home/tenki/.local/bin/onboard-telegram-agent' "$HOST"
grep -q 'mlxs8y/hermes-telegram-tenki-onboarding@213bb584-8dc7-4a06-94d7-df4cd6c45584' "$HOST"
grep -q 'mlxs8y/hermes-telegram-tenki-onboarding@213bb584-8dc7-4a06-94d7-df4cd6c45584' "$ROOT/README.md"
grep -q 'public and credential-free' "$ROOT/README.md"
! rg -n '(NEBIUS_API_KEY=.+[^}]|TELEGRAM_BOT_TOKEN=.+[^}]|GATEWAY_ALLOW_ALL_USERS=true)' "$ROOT/scripts" >/dev/null

python3 "$ROOT/tests/control-character.test.py"

echo 'Hermes Telegram onboarding package checks passed'
