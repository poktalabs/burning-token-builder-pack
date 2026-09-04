---
name: landing-page-from-five-questions
description: Turn five approved answers into a verified local Astro landing page for Burning Token Workshop 1.
---

# Landing page from five questions

Use this skill for the first local build in Burning Token Workshop 1. It turns an idea into a small, inspectable landing page. It does not set up a sandbox, a VM, a provider, a remote service, or a deployment.

## Scope and boundaries

- Work only inside the starter-project directory that Mel names or approves.
- Keep the deck source at `code/agentic-coding-workshop-deck/` separate.
- Keep retired Tenki material at `code/tenki-pi-sandbox-launcher/` separate. Do not reuse its files, setup, or assumptions.
- Do not place API keys, deployment credentials, browser sessions, or secrets in source files, screenshots, terminal recordings, or prompts.
- Do not install Astro globally.
- Do not use web research, Tavily, Render, Convex, external services, authentication, or deployment unless Mel explicitly asks.

## Intake

Ask these questions one at a time. Wait for each answer. Do not create or edit files until all five answers exist.

1. What problem does this solve, and for whom?
2. What is the simplest solution or offer?
3. How does it work in three concrete actions?
4. What outcome or benefit should a visitor expect?
5. What is the pricing or call to action? If pricing is unknown, say so plainly and use a contact or waitlist action instead.

After question five, restate the brief in five bullets. Show the proposed project directory, files to create or change, and local checks. Ask for approval before writing files.

## Build

After Mel approves:

1. Inspect the approved project directory. If it is not an Astro project, create the project there with the current local `create-astro` package. Astro belongs in that project, never in global tooling.
2. Build one static, responsive landing page from the approved answers.
3. Use the five answers as the page structure: problem, solution, how it works, benefits, and pricing or call to action.
4. Use the repository design instructions and Frutero token references when present.
5. Do not invent testimonials, customer logos, pricing facts, performance claims, sponsor commitments, platform access, or company details.
6. Add a concise README section with local development, production build, and facts still requiring confirmation.

## Verification

Run `npm run build`. If the project provides a check or test command, run it too. Fix build errors before reporting completion.

For the visual rehearsal, run the local development server and report the localhost URL. Do not deploy.

## Deployment boundary

Render is a later workshop topic. It may be discussed or prepared only after Mel explicitly asks. Do not create a Render service, deploy, authenticate, or send credentials without that authorization.
