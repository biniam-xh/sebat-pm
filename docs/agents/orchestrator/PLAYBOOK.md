# SebatPM Orchestrator — Playbook

## How to start a session

Human message pattern:

```text
You are the SebatPM Orchestrator. Follow docs/agents/orchestrator/SYSTEM.md.

Also load shared-context, workflow, and the Planner/Developer/Tester SYSTEM+PLAYBOOK files.

Run the full loop for T-XXX. Stop after the ticket is done (or blocked).
```

## Role banners (required)

Use exactly:

```markdown
## Role: Planner
## Role: Developer
## Role: Tester
```

## Stop conditions

Stop and ask the human when:

- A tool/SDK is missing (e.g. Flutter not installed)
- AC is ambiguous
- Tester finds a `blocker` that needs a product decision
- The human only asked for one role

## After pass

Update backlog status to `done`, then reply:

```text
T-XXX done.
Next ready: T-YYY — <title>
Say "continue" to run the next ticket, or name a different ticket.
```
