# SebatPM — Agent Workflow

How Planner, Developer, and Tester hand off work. Tool-agnostic.

## Flow

```
PRD / backlog  →  Planner  →  ticket + AC
                      ↓
                 Developer  →  implementation + notes
                      ↓
                   Tester   →  pass / fail + bugs
                      ↓
            pass → Planner marks done / opens next
            fail → Developer fixes → Tester retests
```

## Ticket states

Use these statuses in `docs/product/backlog.md`:

| Status | Meaning |
|--------|---------|
| `todo` | Ready for Developer |
| `in_progress` | Developer actively implementing |
| `in_review` | Awaiting Tester |
| `blocked` | Waiting on decision or dependency |
| `done` | Tester passed |
| `v2` | Explicitly out of MVP |

## Hand-off packets

### Planner → Developer

- Ticket id + title
- Given/When/Then acceptance criteria
- Links to PRD section + architecture notes
- Out of scope for this ticket

### Developer → Tester

- Ticket id
- What changed (files/areas)
- How to verify (steps, test accounts, data setup)
- Known limitations

### Tester → Developer / Planner

- Result: `pass` or `fail`
- On fail: bug reports (repro, expected, actual, severity)
- On pass: short confirmation; Planner moves ticket to `done`

## Rules

1. One active implementation ticket per Developer session unless human says otherwise.
2. Tester does not expand scope; file `v2` suggestions separately.
3. Planner does not write production app code; Developer does not silently change AC.
4. If AC is ambiguous, stop and ask — do not invent behavior.
