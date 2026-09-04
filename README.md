# Burning Token Hackathon Builder Pack

The participant Home/HQ for Burning Token pre-hack workshops and useful builder resources.

**DRI:** Program Lead (Mel)

This is a container repository. It brings together reusable builder skills, session-specific material, workshop/demo code, documentation, and the participant-facing web experience without turning those concerns into one application.

## Start here

- Workshop site and slides: [`web/create-your-own-ai-dev/`](web/create-your-own-ai-dev/)
- Reusable skills: [`skills/`](skills/)
- Individual workshops and tutorials: [`sessions/`](sessions/)
- Workshop/demo repositories: [`code/`](code/)
- Program documentation and references: [`docs/`](docs/)

## Layout

```text
hackathon-builder-pack/
  code/       # Individual workshop/demo repositories and source projects.
  skills/     # Reusable, narrow procedures that agents and builders can load.
  sessions/   # Material specific to an individual workshop, stream, or tutorial.
  docs/       # Program-wide guides, references, and operating records.
  web/        # Participant-facing landing pages and presentation experiences.
  README.md   # This Home/HQ.
```

## Current contents

| Area | Current item | Purpose |
|---|---|---|
| `web/` | `create-your-own-ai-dev/` | Workshop 2 landing page and presentation scaffold. |
| `skills/` | `landing-page-from-five-questions/` | A bounded local Astro landing-page workflow. |
| `sessions/` | `agentic-code-from-0-to-1/` | Workshop 1 prompt and session material. |
| `sessions/` | `create-your-own-ai-dev/` | Workshop 2 session material. |

## Operating rules

- The Program Lead owns what enters the Builder Pack and what becomes participant-facing.
- Put reusable instructions in `skills/`, not in a single session folder.
- Put session-specific prompts, guides, summaries, links, and recovery material in that session's directory.
- Put a workshop or demo project in its own subdirectory of `code/`.
- Put participant-facing sites and slide decks in `web/`.
- Do not commit credentials, API keys, browser sessions, private SSH material, or provider tokens.
- Do not imply sponsor endorsement, provider access, credits, deployment rights, or logistics until confirmed.

## Local web preview

```bash
cd web/create-your-own-ai-dev
python3 -m http.server 8766 --bind 127.0.0.1
```

Open `http://127.0.0.1:8766/` for the entry page and `/presentation/` for the Workshop 2 deck.
