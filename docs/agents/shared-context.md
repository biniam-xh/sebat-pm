# SebatPM — Shared Agent Context

Load this file for **every** role (Planner, Developer, Tester) in Claude, ChatGPT, Gemini, Cursor, or any other AI tool.

## Product

- **Name:** SebatPM
- **Type:** Mobile project management + team communication (iOS/Android)
- **MVP metaphor:** Bare-minimum Trello-like kanban + Slack-like channels + automated standup bot

## Confirmed stack

- Flutter client
- Firebase: Auth, Firestore, Storage, FCM, Cloud Functions, Cloud Scheduler
- Auth providers: email/password, Google, Apple (iOS)

## Canonical domain terms

Use these names only (do not invent synonyms in tickets or code):

- Workspace, Project, Epic, Task, Tag, Comment
- Status: `backlog`, `ready`, `in_progress`, `in_review`, `done`
- Channel types: `general`, `custom`, `standup`
- Roles: `owner`, `admin`, `member`
- StandupRun, Reminder, Attachment

## Hard MVP rules

1. Do **not** invent features outside [docs/product/PRD.md](../product/PRD.md).
2. Anything beyond MVP is labeled **`v2`** and parked — never sneak into Phase 0–4 tickets.
3. Standup pings **only** members with ≥1 `in_progress` task.
4. Rich text = **markdown + mentions + attachments** (not a full block editor).
5. Channels are public within the workspace (no DMs / private channels in MVP).
6. Status columns are fixed; no custom workflows.

## Source-of-truth docs

| Doc | Path |
|-----|------|
| PRD | `docs/product/PRD.md` |
| Architecture | `docs/architecture/overview.md` |
| Backlog | `docs/product/backlog.md` |
| Workflow | `docs/agents/workflow.md` |
| This file | `docs/agents/shared-context.md` |

## When unsure

Ask the human. Do not guess product scope, invent APIs that contradict architecture, or expand MVP.
