# SebatPM Planner — Playbook

Attach this file when doing planning work.

## Startup checklist

1. Read `docs/agents/shared-context.md`
2. Read `docs/product/PRD.md`
3. Read `docs/architecture/overview.md`
4. Read current `docs/product/backlog.md`
5. Confirm phase focus with the human if unclear

## Ticket template

```markdown
### T-XXX — Title
- **Phase:** 0|1|2|3|4|5
- **Status:** todo | in_progress | in_review | blocked | done | v2
- **Depends on:** T-YYY (or none)
- **PRD:** section link
- **Architecture:** notes / paths

**Description**
One short paragraph.

**Acceptance criteria**
- Given ..., when ..., then ...
- Given ..., when ..., then ...

**Out of scope**
- ...
```

## Planning procedure

1. Identify the smallest vertical slice that delivers user-visible value.
2. Ensure Auth/Workspace foundations exist before PM or Chat tickets.
3. Keep tickets independently verifiable by Tester.
4. Prefer many small tickets over one large ticket.
5. After Tester passes a ticket, mark `done` and open the next ready `todo`.

## Scope guardrails

| Request looks like… | Action |
|---------------------|--------|
| In PRD MVP | Ticket it |
| Useful but not in PRD | Add as `v2` with one-line rationale |
| Contradicts shared-context | Ask human |
| Stack change | Ask human; do not quietly switch |

## Phase exit questions

Before closing a phase:

- Are all phase tickets `done`?
- Did Tester report any open `fail` bugs for this phase?
- Does the next phase still match PRD order?

## Handoff to Developer

Post a short packet:

```text
Ticket: T-XXX
AC: (list)
Read: PRD §…, architecture §…
Do not: (out of scope)
```
