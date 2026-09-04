#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST="$ROOT/scripts/onboard-hermes-telegram.sh"
VM="$ROOT/scripts/onboard-telegram-agent"

SSH_HELPER="$ROOT/scripts/managed-ssh-bootstrap.exp"

bash -n "$HOST"
EXPECT_PARSE_ONLY=1 SSH_HELPER="$SSH_HELPER" expect -c 'source $env(SSH_HELPER)'
test -x "$HOST"
test -x "$VM"
test -f "$SSH_HELPER"
! grep -q ' -f - ' "$HOST"
grep -q '"$EXPECT_BIN" "$ROOT/scripts/managed-ssh-bootstrap.exp" "$TENKI_BIN" "$NAME" onboarding-telegram-agent' "$HOST"
! grep -q 'sandbox ssh --session "$NAME" -- /home/tenki/.local/bin/onboard-telegram-agent' "$HOST"
grep -q 'mlxs8y/hermes-nebius-workshop@sha256:c7d262d344d8061d75600a1523827f3044cd6c908a7ba75ebec88ae7ef2c5c22' "$HOST"
grep -q 'mlxs8y/hermes-nebius-workshop@sha256:c7d262d344d8061d75600a1523827f3044cd6c908a7ba75ebec88ae7ef2c5c22' "$ROOT/README.md"
! rg -n '(NEBIUS_API_KEY=.+[^}]|TELEGRAM_BOT_TOKEN=.+[^}]|GATEWAY_ALLOW_ALL_USERS=true)' "$ROOT/scripts" >/dev/null

echo 'Hermes Telegram onboarding package checks passed'
