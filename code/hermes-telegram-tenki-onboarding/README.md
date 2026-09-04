# Hermes Telegram Tenki onboarding

An operator-controlled onboarding flow for a private Hermes Agent that runs in a disposable Tenki sandbox and is reached through Telegram.

> **Status:** private technical prototype. The image and no-credential controller checks have passed. A live Telegram + Nebius Token Factory handshake, usage reconciliation, and the $25 operating boundary still require an operator-run smoke test. This is **not** participant infrastructure.

## What the completed onboarding experience does

1. Checks that the Tenki CLI is installed and authenticated.
2. Launches a disposable sandbox from the registered private Hermes + Pi image.
3. Keeps inbound networking disabled; enables outbound networking only for Telegram long polling and Nebius inference.
4. Opens Tenki managed SSH for the operator.
5. Prompts within that SSH session for the Nebius key, Telegram BotFather token, and numeric Telegram user ID.
6. Starts an allowlist-only Hermes Telegram gateway on the Budget model by default.
7. Confirms the bot account and asks the operator to send `/whoami` from Telegram.
8. Provides explicit gateway stop and sandbox termination controls.

## Security and operating boundaries

- The golden image contains tooling and configuration only—never provider keys, Telegram tokens, SSH keys, or user IDs.
- Credentials are entered by the operator directly into the temporary managed SSH shell. They must not be passed through Tenki `--env`, committed, recorded in shell history, or put into a public runbook.
- The gateway rejects `GATEWAY_ALLOW_ALL_USERS=true`; access is restricted to numeric Telegram IDs supplied at runtime.
- Stopping the Telegram gateway is not sufficient cleanup: terminate the disposable Tenki sandbox after the test or demo.
- The $25 Nebius budget is an operational boundary, not a verified provider-side hard cap.

## Current operator controls inside the sandbox

```text
workshop-agent start
workshop-agent status
workshop-agent logs
workshop-agent stop
```

`workshop-agent start` requires runtime-only `NEBIUS_API_KEY`, `TELEGRAM_BOT_TOKEN`, and `TELEGRAM_ALLOWED_USERS` values. It starts Hermes with the Budget profile. An authorized Telegram session may explicitly use `/model hermes-pro` for more demanding work; `/new` returns the session to the Budget default.

## Repository boundary

This Builder Pack project is the Burning Token program’s canonical onboarding entrypoint. The private image recipe, immutable image reference, automated verification harness, and technical implementation remain in the operator-owned `fruteroclub/pi-nebius-token-factory` repository on its Hermes/Nebius feature branch.

Do not copy private image internals, credentials, or ephemeral sandbox identifiers into participant-facing material.
