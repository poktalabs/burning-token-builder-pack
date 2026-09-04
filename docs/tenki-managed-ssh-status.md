# Tenki managed-SSH technical status

## Current result

Tenki managed SSH and a real interactive terminal are technically certified on the private Pi image as of 2026-09-03.

The no-credential check proved:

```text
managed SSH connection  - passed
remote identity          - tenki
interactive terminal     - /dev/pts/0
Pi                       - 0.84.4
Render                   - v2.25.0
inbound networking       - disabled
outbound networking      - disabled
```

Every validation sandbox was terminated after testing.

## Important boundary

This is a **technical readiness result**, not an attendee-access promise. These gates remain open:

- user-owned Nebius key inside the temporary remote shell;
- one real model response;
- the five-question approved brief;
- local Astro build and preview;
- measured time-to-smile; and
- explicit Program Lead approval of a Tenki-backed participant format.

Until those gates pass, the Builder Pack's local workflow remains the participant default. Do not add provider keys, credentials, or sandbox launch instructions to attendee material.

## Technical source

The evidence record is maintained separately in the Pi/Nebius technical repository:

```text
fruteroclub/pi-nebius-token-factory
branch: test/pi-nebius-tenki-image
commit: 728b808
```

This Builder Pack intentionally links to the decision boundary rather than duplicating image recipes, private image references, or credential-handling procedures.
