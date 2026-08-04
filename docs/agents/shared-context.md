# SebatPM — Shared Agent Context

Load this file for **every** role (Planner, Developer, Tester) in Claude, ChatGPT, Gemini, Cursor, or any other AI tool.

## Product

- **Name:** SebatPM
- **Type:** Mobile dual-mode app — Chat (default) + Project management (iOS/Android)
- **MVP metaphor:** Slack-like channels + Trello-like kanban in one shell, strongly integrated

## Confirmed stack

- Flutter client
- Firebase: Auth, Firestore, Storage, FCM, Cloud Functions, Cloud Scheduler (later)
- Auth providers: email/password, Google, Apple (iOS)

## Canonical domain terms

Use these names only (do not invent synonyms in tickets or code):

- Team (implicit shared team — no Workspace create UI in MVP)
- Project, Epic, Task, Tag, Comment
- Status: `backlog`, `ready`, `in_progress`, `in_review`, `done`
- Channel types: `general`, `custom`, `standup` (bot-owned)
- App modes: `chat`, `projects`
- Attachment; StandupRun (runs later in `#standup`); later: Reminder, Workspace roles (`owner`, `admin`, `member`)

## Delivery tracks

| Track | Owns |
|-------|------|
| **S** | Shell, mode switch, Auth, Firebase, implicit team + `#general` / `#standup` seed |
| **C** | `features/chat/` |
| **P** | `features/projects/` |
| **I** | `data/integration/`, deep links, task chips, board→channel, project↔channel |
| **Standup (later)** | `features/standup/` client UI + Functions writing into `#standup` |

Chat must not import PM widgets; PM must not import Chat widgets — only contracts + router.

## Hard MVP rules

1. Do **not** invent features outside [docs/product/PRD.md](../product/PRD.md).
2. Anything beyond MVP is labeled **`v2`** and parked — never sneak into active phase tickets.
3. Cold start opens **Chat**; `#general` and `#standup` exist by default (standup bot runs later).
4. Rich text = **markdown + mentions + attachments** (not a full block editor).
5. Channels are public within the shared team (no DMs / private channels in MVP).
6. Status columns are fixed; no custom workflows.
7. No create-workspace / invite UI until multi-tenant v2 returns.

## Source-of-truth docs

| Doc | Path |
|-----|------|
| PRD | `docs/product/PRD.md` |
| Architecture | `docs/architecture/overview.md` |
| Backlog | `docs/product/backlog.md` |
| Mockups | `docs/design/mockups/` |
| Workflow | `docs/agents/workflow.md` |
| This file | `docs/agents/shared-context.md` |

## When unsure

Ask the human. Do not guess product scope, invent APIs that contradict architecture, or expand MVP.
