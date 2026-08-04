# SebatPM Agents — Load Guide (Any AI Tool)

Portable agent settings for **Planner**, **Developer**, and **Tester**. Same files work in Claude, ChatGPT, Gemini, Cursor, and similar tools.

## Quick start (all tools)

1. Pick a role: `planner`, `developer`, or `tester`.
2. Set **system / custom instructions** to the contents of `docs/agents/<role>/SYSTEM.md`.
3. Attach or pin these knowledge files:
   - `docs/agents/shared-context.md`
   - `docs/agents/<role>/PLAYBOOK.md`
   - `docs/agents/workflow.md`
   - `docs/product/PRD.md`
   - `docs/architecture/overview.md`
   - `docs/product/backlog.md`
4. Start with a role lock, for example:  
   `You are the SebatPM Planner. Follow SYSTEM.md and shared-context.md.`

## File map

| Path | Purpose |
|------|---------|
| `shared-context.md` | Facts every role must share |
| `workflow.md` | Hand-off protocol |
| `planner/SYSTEM.md` | Planner persona (paste as instructions) |
| `planner/PLAYBOOK.md` | Planner procedures + templates |
| `developer/SYSTEM.md` | Developer persona |
| `developer/PLAYBOOK.md` | Developer procedures |
| `tester/SYSTEM.md` | Tester persona |
| `tester/PLAYBOOK.md` | Tester procedures |

Root index: [AGENTS.md](../../AGENTS.md)

## Claude

1. Create a **Project** per role (or one project with clear role lock each chat).
2. Paste `SYSTEM.md` into Project instructions.
3. Add the knowledge files listed above to Project knowledge.
4. Open a chat and send the role-lock line.

## ChatGPT

1. Create a **Custom GPT** or **Project** per role.
2. Instructions = `SYSTEM.md`.
3. Upload knowledge files (shared-context, PLAYBOOK, PRD, architecture, backlog, workflow).
4. Start chats with the role-lock line.

## Gemini

1. Create a **Gem** (or a chat with uploaded files) per role.
2. Instructions = `SYSTEM.md`.
3. Attach the knowledge files.
4. Start with the role-lock line.

## Cursor

1. Prefer the repo docs as source of truth (this folder).
2. Optional: `.cursor/rules/` pointers load shared context automatically — they do **not** duplicate policy.
3. In chat, `@` the role `SYSTEM.md` + `PLAYBOOK.md` and say which role you want.
4. Do not treat Cursor-only skills as the primary agent pack (keeps non-Cursor teammates aligned).

## Keeping agents in sync

- Edit **only** files under `docs/agents/` and product/architecture docs when policy changes.
- After edits, re-upload or refresh Project/Gem/GPT knowledge in other tools.
- Never maintain a second copy of rules inside Claude/ChatGPT that drifts from this repo.
