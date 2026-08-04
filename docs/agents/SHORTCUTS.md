# SebatPM — Shortcuts

Works in **any** AI tool (Cursor, Claude, ChatGPT, Gemini, Copilot Chat, Claude Code, etc.).  
Source of truth = markdown under `docs/agents/`. Cursor `.cursor/rules/` are optional helpers only.

## Setup once per tool

### Cursor (one attach)

`@docs/agents/orchestrator/ATTACH_ME.md` — that file tells the agent to load everything else.

Or `@docs/agents` (folder) if your Cursor build supports folder mentions.

Then send: `Orchestrator mode. Run T-002.`

### Other tools (Claude / ChatGPT / Gemini / Copilot / Claude Code)

1. Create a Project / custom instructions / agent session for **Orchestrator**.
2. Paste `docs/agents/orchestrator/SYSTEM.md` into system/instructions.
3. Upload/pin `ATTACH_ME.md` **or** the files it lists (playbooks, shared-context, workflow, backlog).
4. After that, use the one-liners below.

## One-liners

| Say this | Means |
|----------|--------|
| `Run T-002` | Full Orchestrator loop for that ticket |
| `continue` | Run the next ready backlog ticket |
| `Planner only T-002` | Confirm AC / handoff only |
| `Dev T-002` | Implement only |
| `Test T-002` | Verify only (paste handoff if you have it) |
| `status` | Which ticket is active + role last used |
| `stop` | Halt the loop; wait for me |

## New chat (once)

```text
Orchestrator mode. Run T-002.
```

That is enough after the one-time setup above.

## Remember

- New chat/session → one short lock (`Orchestrator mode`) + ticket
- Same chat → just `Run T-XXX` / `continue`
- Role banners (`## Role: Planner` etc.) show who is working
- Do **not** rely on `.cursor/rules` for non-Cursor teammates — they use `SYSTEM.md` paste instead
