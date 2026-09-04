# Create Your Own AI Dev - Workshop 2 site

A local web entry point and presentation scaffold for the Burning Token Workshop 2 delivery.

## Run locally

```bash
cd ~/workspaces/frutero/projects/devrel/burning-token/code/create-your-own-ai-dev-deck
python3 -m http.server 8766 --bind 127.0.0.1
```

Open:

```text
http://127.0.0.1:8766/
```

## Routes

| Route | Purpose |
|---|---|
| `/` | Workshop landing page with the two entry actions. |
| `/presentation/` | The 14-slide workshop presentation scaffold. |

The root hero has two distinct actions:

1. **Create your own Agent** opens the presentation from its cover.
2. **Educational Resources** opens the presentation at the Dev Tools and Skills section.

Presentation controls: Right/Space advances; Left returns; Home/End jump; the lower-right control enters fullscreen.

## Presentation structure

1. Cover
2. Icebreaker - Code is free, but time is not
3. Facilitator presentation
4. Intro to Agentic Coding
5. Harness Engineering 101
6. Hermes Agent Intro
7. Hermes Agent Deployment
8. Connecting Dev Tools and Skills to Hermes Agent
9. Dev Agent - Scaffolding an App
10. Dev Agent - Building a Feature
11. Dev Agent - Deploying
12. Dev Agent - Make It Yours: Ideas and Roadmap
13. Final Review
14. Q&A + Closing

The presentation remains structure-only. Do not add claims, credentials, provider-access promises, or workshop content without facilitator review.
