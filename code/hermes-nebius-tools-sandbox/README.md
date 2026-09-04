# Hermes + Nebius tools sandbox

Build source for the credential-free Tenki image used in the Workshop 2 guide.

The image contains Hermes Agent, Render CLI, Tenki CLI, Convex CLI, GitHub CLI, and a `hermes-nebius` launcher. Hermes is set to Nebius Token Factory with the correct endpoint and these model aliases:

- `hermes-pro`: Nemotron 3 Ultra
- `hermes-budget`: MiniMax M3
- `developer-pro`: Kimi K2.7 Code
- `developer-budget`: gpt-oss-120b

It contains no Nebius key, GitHub login, Render login, Tenki login, Convex deployment, project files, or user session state.

Participant launch and cleanup instructions live in [`../../sessions/create-your-own-ai-dev/README.md`](../../sessions/create-your-own-ai-dev/README.md).
