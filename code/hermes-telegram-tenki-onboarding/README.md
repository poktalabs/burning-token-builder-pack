# Hermes + Nebius + Telegram on Tenki

Run a private Hermes Agent in a disposable Tenki Sandbox, using Nebius Token Factory for inference and an allowlisted Telegram bot for chat.

This directory is the canonical **operator onboarding package** for Burning Token. It includes the script you run locally and the script the image runs inside the VM.

> **Status:** the registered image is no-key verified. The first live run requires you to enter a Nebius key and a dedicated Telegram BotFather token personally in the managed SSH terminal. No credential is stored in this repository, the image, or Tenki session configuration.

## What you get

- **Hermes Agent** as the main agent, using Nebius Token Factory.
- **Pi Coding Agent** as a bounded developer subagent.
- Hermes **Budget** by default (`MiniMaxAI/MiniMax-M3`), with an explicit Telegram-session escalation to Hermes Pro.
- An allowlist-only Telegram gateway: only the numeric user ID entered during onboarding can use it.
- Inbound network access disabled. Outbound is enabled only because Telegram long polling and Nebius inference require it.
- A disposable Tenki VM with an explicit idle timeout and maximum lifetime.

## Before you start

1. Install and authenticate the Tenki CLI on your Mac:

   ```bash
   tenki login
   tenki status
   ```

2. Create a **dedicated private bot** with [@BotFather](https://t.me/BotFather). Keep the token secret. Do not paste it into GitHub, this README, a chat, or a Tenki command.

3. Find your numeric Telegram user ID. It is not your Telegram username. For example, message [@userinfobot](https://t.me/userinfobot).

4. Open a local macOS Terminal. You need a real TTY because the VM will request credentials without echoing them.

## Start the full onboarding flow

```bash
cd /Users/mel/workspaces/frutero/projects/devrel/burning-token/hackathon-builder-pack/code/hermes-telegram-tenki-onboarding
./scripts/onboard-hermes-telegram.sh
```

The launcher performs the following steps:

1. Validates that the Tenki CLI exists and is authenticated.
2. Creates a new sandbox from the immutable registered image.
3. Uses `--allow-inbound=false` and `--allow-outbound=true`.
4. Sets a **15-minute idle timeout** and a **2-hour maximum duration** by default.
5. Opens Tenki managed SSH directly into `onboard-telegram-agent` inside the VM.

## What happens inside the VM

The in-VM script asks for, in order:

1. **Nebius Token Factory API key** — hidden while you type.
2. **Telegram BotFather token** — hidden while you type.
3. **Your numeric Telegram user ID** — validated before startup.

It then validates the BotFather token directly with Telegram, identifies the bot’s `@username`, starts the Hermes Telegram gateway, and tells you to send:

```text
/whoami
```

to that bot in Telegram.

Then send a simple chat message:

```text
Hello — confirm Hermes is responding through Telegram.
```

A successful response proves the chain:

```text
Telegram → Hermes gateway → Nebius Token Factory → Hermes response → Telegram
```

## Model controls in Telegram

The gateway starts with Hermes Budget.

```text
/model hermes-pro    # stronger model for this Telegram session
/new                 # begin a new session on the Budget default
/status              # inspect the current Hermes session
/stop                # cancel a running agent turn
```

## Stop and clean up

Inside the VM, stop the Telegram gateway:

```bash
workshop-agent stop
```

Exit SSH, then terminate the sandbox from your Mac. The host launcher prints the exact command for its generated sandbox name:

```bash
tenki sandbox terminate --session <sandbox-name>
```

**Stopping the gateway does not terminate the billable VM.** Always terminate the sandbox after a test or demo unless you have explicitly decided to keep it running.

## Script and image map

| Path | Runs where | Purpose |
|---|---|---|
| [`scripts/onboard-hermes-telegram.sh`](scripts/onboard-hermes-telegram.sh) | Your Mac | Validates Tenki, creates the sandbox, and opens managed SSH. |
| [`scripts/onboard-telegram-agent`](scripts/onboard-telegram-agent) | Inside the Tenki VM | Interactively requests credentials, validates the bot identity, starts Hermes, and gives Telegram test instructions. |
| [`tests/onboarding.test.sh`](tests/onboarding.test.sh) | Your Mac / CI | Checks that both scripts are executable, parse correctly, expose help, and contain no credential assignment. |

The VM script is installed from this exact Builder Pack project while the private image is built. The image recipe, model configuration, budget estimator, and no-key image verifier remain in the operator-owned technical repository `fruteroclub/pi-nebius-token-factory`.

## Registry image reference

The launcher defaults to the immutable image reference below. You may override it only if you have built and verified a newer private image:

```text
mlxs8y/hermes-nebius-workshop@sha256:c7d262d344d8061d75600a1523827f3044cd6c908a7ba75ebec88ae7ef2c5c22
```

```bash
IMAGE_REF='<your-verified-private-image-reference>' ./scripts/onboard-hermes-telegram.sh
```

## Troubleshooting

| Symptom | What to check |
|---|---|
| `Tenki CLI not found` | Install Tenki or set `TENKI_BIN` to its executable path. |
| `Tenki is not authenticated` | Run `tenki login`, then retry. |
| Telegram rejects the token | Regenerate/verify the token with @BotFather; do not paste it into the command line. |
| No Telegram reply | In the VM run `workshop-agent status`, then `workshop-agent logs`. Confirm the numeric Telegram ID is correct and message the bot directly. |
| Budget concern | Use `/usage` in Telegram and the Nebius billing console. The $25 limit is currently an operating boundary, not a confirmed provider-side hard cap. |

## Security rules

- Never put credentials in `--env`, `.env`, shell history, Git, screenshots, or public issues.
- Never set `GATEWAY_ALLOW_ALL_USERS=true`.
- Keep the bot in a direct message for this operator flow. Do not add it to a group or disable BotFather privacy mode.
- Treat the VM as disposable. Terminate it once the test is complete.
