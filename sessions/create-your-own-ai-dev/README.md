# Session: Create Your Own AI Dev

Session-specific material for Burning Token Workshop 2.

## Participant entry point

The landing page and presentation live at:

```text
../../web/create-your-own-ai-dev/
```

Run the preview from that directory. Open the root route for the workshop entry page and `/presentation/` for the deck.

## Launch the public agent tools sandbox

This public, credential-free Tenki image gives you a disposable Linux VM with:

- Hermes Agent configured for Nebius Token Factory
- Render CLI
- Tenki CLI
- Convex CLI
- GitHub CLI

It does not contain a Nebius key, GitHub login, Render login, Tenki login, Convex deployment, Pi Coding Agent, Telegram, project files, or saved agent sessions.

### Before you start

Install and authenticate the Tenki CLI on your Mac:

```bash
tenki login
tenki status
```

### Create a sandbox

Use the immutable public image reference:

```bash
tenki sandbox create \
  --name my-agent-tools \
  --image mlxs8y/burning-token-agent-tools@c88e596a-fe39-46c5-960b-edbf3e034bcd \
  --cpu 2 \
  --memory-mb 4096 \
  --disk-size-gb 20 \
  --allow-inbound=false \
  --allow-outbound=true \
  --idle-timeout 15m \
  --max-duration 2h \
  --metadata purpose=workshop-agent-tools
```

Connect through Tenki's managed SSH tunnel:

```bash
tenki sandbox ssh --session my-agent-tools
```

### Run Hermes through Nebius

Inside the sandbox, run:

```bash
hermes-nebius
```

The launcher prompts privately for your Nebius Token Factory API key. It holds the key only in the Hermes process environment. It does not write the key to `.env`, shell history, Tenki metadata, or the image.

Then try:

```text
Reply with exactly: Hello from Hermes through Nebius.
```

Hermes starts with the Budget model, `MiniMaxAI/MiniMax-M3`. These aliases are also configured:

```text
/model hermes-pro         # nvidia/Nemotron-3-Ultra-550b-a55b
/model hermes-budget      # MiniMaxAI/MiniMax-M3
/model developer-pro      # moonshotai/Kimi-K2.7-Code
/model developer-budget   # openai/gpt-oss-120b
```

The developer aliases change Hermes' model. This image does not yet include a separate Pi coding-agent process.

### Configure platform CLIs live

Only authenticate tools you need in the disposable VM:

```bash
gh auth login
render login
tenki login
npx convex dev
```

### Clean up

Exit SSH, then terminate the billable VM from your Mac:

```bash
tenki sandbox terminate --session my-agent-tools
```

An idle timeout and maximum duration limit exposure. They do not replace explicit cleanup.

## Intended session scope

- Harness engineering foundations
- Hermes Agent introduction and deployment concepts
- Connecting developer tools and skills
- An app scaffold, a feature build, and a deployment walkthrough
- Participant ideas and a next-step roadmap

Add facilitator notes, links, recovery material, participant resources, and the confirmed run-of-show here. Keep unconfirmed provider access and sponsor claims out of participant-facing content.
