#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$ROOT/.tenki/agent-tools-public.json"
LAUNCHER="$ROOT/code/hermes-nebius-tools-sandbox/scripts/hermes-nebius"

bash -n "$LAUNCHER"
python3 -m json.tool "$TEMPLATE" >/dev/null

grep -q 'https://api.tokenfactory.nebius.com/v1/' "$TEMPLATE"
grep -q 'nvidia/Nemotron-3-Ultra-550b-a55b' "$TEMPLATE"
grep -q 'moonshotai/Kimi-K2.7-Code' "$TEMPLATE"
grep -q 'openai/gpt-oss-120b' "$TEMPLATE"
grep -q 'npm install -g convex' "$TEMPLATE"
grep -q 'npm prefix -g)/bin/convex' "$TEMPLATE"
grep -q 'tenki.cloud/install.sh' "$TEMPLATE"
grep -q 'render-oss/cli/releases/download/v2.22.0' "$TEMPLATE"
! grep -Eq '(NEBIUS_API_KEY|RENDER_API_KEY|TENKI_API_KEY|CONVEX_DEPLOY_KEY|GITHUB_TOKEN)=[^[:space:]]+' "$TEMPLATE"

printf 'agent tools image source checks passed\n'
