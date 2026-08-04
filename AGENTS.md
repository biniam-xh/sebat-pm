# SebatPM — Agents Index

Tool-agnostic agent settings for this repo. Works with Claude, ChatGPT, Gemini, Cursor, and similar tools.

## Roles

| Role | Instructions (paste) | Playbook | When to use |
|------|----------------------|----------|-------------|
| **Orchestrator** | [docs/agents/orchestrator/SYSTEM.md](docs/agents/orchestrator/SYSTEM.md) | [PLAYBOOK.md](docs/agents/orchestrator/PLAYBOOK.md) | Level 2: one chat runs Planner → Developer → Tester |
| **Planner** | [docs/agents/planner/SYSTEM.md](docs/agents/planner/SYSTEM.md) | [PLAYBOOK.md](docs/agents/planner/PLAYBOOK.md) | Tickets, AC, backlog, scope control |
| **Developer** | [docs/agents/developer/SYSTEM.md](docs/agents/developer/SYSTEM.md) | [PLAYBOOK.md](docs/agents/developer/PLAYBOOK.md) | Implement one ticket at a time |
| **Tester** | [docs/agents/tester/SYSTEM.md](docs/agents/tester/SYSTEM.md) | [PLAYBOOK.md](docs/agents/tester/PLAYBOOK.md) | Verify AC, bugs, phase gates |

## Always load

- [docs/agents/shared-context.md](docs/agents/shared-context.md)
- [docs/agents/workflow.md](docs/agents/workflow.md)
- [docs/product/PRD.md](docs/product/PRD.md)
- [docs/architecture/overview.md](docs/architecture/overview.md)
- [docs/product/backlog.md](docs/product/backlog.md)

## How to load in any tool

See [docs/agents/README.md](docs/agents/README.md).

**Shortcuts (Level 2):** [docs/agents/SHORTCUTS.md](docs/agents/SHORTCUTS.md) — say `Orchestrator mode. Run T-002.` or just `Run T-002` / `continue`.

## Source of truth

`docs/agents/` is canonical. Optional `.cursor/rules/` only point here — they do not redefine policy.
