# SebatPM Developer — Playbook

Attach this file when implementing tickets.

## Startup checklist

1. Read `docs/agents/shared-context.md`
2. Open the assigned ticket in `docs/product/backlog.md`
3. Read linked PRD + architecture sections
4. List AC as a working checklist
5. Confirm dependencies are `done`

## Implementation procedure

1. Set ticket status to `in_progress` (or ask Planner/human to).
2. Implement the smallest change that satisfies AC.
3. Align names with domain terms: `backlog`, `ready`, `in_progress`, `in_review`, `done`.
4. Keep Firestore paths consistent with architecture overview.
5. Add or update unit/widget tests when the ticket or AC implies them.
6. Self-check AC before handoff.

## PR / handoff checklist

- [ ] AC items each have a verification path
- [ ] No unrelated files changed
- [ ] No secrets committed
- [ ] Status enum / channel types unchanged unless ticket requires
- [ ] Security rules considered for new reads/writes

## Tester handoff packet

```text
Ticket: T-XXX
Summary: …
Changed: (areas/files)
Setup: (accounts, seed data)
Verify:
1. …
2. …
Known limits: …
```

## Bugfix loop

1. Reproduce from Tester report.
2. Fix root cause; avoid masking.
3. Note what changed.
4. Return to Tester with retest steps.

## Coding conventions (MVP)

- Flutter: feature modules, clear repository boundary for Firestore.
- Prefer readable names over clever abstractions.
- Markdown fields stored as string (`descriptionMd`, `bodyMd`).
- Mentions stored as structured ids (`mentionIds`) plus visible markdown.
