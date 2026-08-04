# SebatPM — Product Requirements Document (MVP)

## 1. Vision

SebatPM is a mobile app that combines **Slack-like chat** and **Trello-like project management** in one client. Users switch between Chat (default) and Projects modes. The two modes stay separately navigable but are **integrated** (task chips in chat, board events posted to channels, optional project↔channel links).

## 2. Confirmed decisions

| Decision | Choice |
|----------|--------|
| Clients | Flutter (iOS + Android) |
| Backend | Firebase (Auth, Firestore, Storage, FCM, Cloud Functions) |
| App modes | **Chat** (cold-start default) and **Projects**; persistent mode switch |
| Tenancy (MVP) | **Implicit shared team** — all authenticated users share one team; no create-workspace UI |
| Channels | Users create custom channels; **`#general` and `#standup` auto-seeded** for the shared team |
| Chat ↔ PM | Strong: open task from chat; board/status updates can post to a channel; optional project↔channel link |
| Auth (MVP) | Email/password, Google Sign-In, Apple Sign-In (iOS) |
| Standup | Bot owns **`#standup`** channel; targeting = only members with ≥1 `in_progress` task (bot runs later phase) |
| Agent docs | Portable markdown in `docs/agents/` (tool-agnostic) |
| Parallel delivery | Track **S** (shared), **C** (chat), **P** (PM), **I** (integration) |

## 3. Personas

- **Member** — Signs in, chats in channels, works on projects/tasks, switches modes.
- **Admin** (later / v2 multi-workspace) — Invites, roles, standup schedule — **parked** while tenancy is a single shared team.

## 4. Domain model

| Entity | MVP fields / rules |
|--------|-------------------|
| **Team** (implicit) | Single shared team for all authenticated users. No workspace create UI in MVP. |
| **Project** | Name, description, archived flag, optional `channelId`. Owns epics, tasks, tags. |
| **Epic** | Title, description, projectId, optional color. Tasks may be epic-less. |
| **Task** | Title, rich description, status, assignees[], tags[], epicId?, projectId, createdBy, timestamps. |
| **Status** | Fixed: `backlog` → `ready` → `in_progress` → `in_review` → `done`. |
| **Tag** | Project-scoped name + color. Multi-select on tasks. |
| **Comment** | Markdown text, attachments, `@mentions`, author, timestamps. |
| **Channel** | Types: `general` (auto), `standup` (bot-owned, auto), `custom`. Optional `projectId`. Public to the shared team. |
| **Message** | Markdown + mentions, attachments; optional `taskRef` / board-event / standup payload. |
| **StandupRun** | Lives in `#standup`; ordered participants, answers, timeout, summary (execution later). |
| **Attachment** | Storage metadata; ≤10 MB. |

Parked entities (v2 / later): Workspace invites, multi-workspace, Reminder. Standup **channel** is in MVP seed; standup **bot schedule/run** is a later phase.

## 5. Functional requirements

### 5.1 Auth & shared team

- Users sign up / sign in with email/password, Google, or Apple (iOS).
- On first deploy / bootstrap, the shared team exists and **`#general` + `#standup`** are seeded (Cloud Function or admin seed — not a per-user create-workspace flow).
- Authenticated users can use Chat and Projects against the shared team.

### 5.2 App shell (dual mode)

- Persistent **Chat | Projects** mode switch.
- Cold start opens **Chat** (prefer `#general`).
- Last selected mode may be remembered per device.
- Chat and Projects UIs must not import each other’s widgets — integrate via shared contracts + router.

### 5.3 Project management

- Create / edit / archive projects.
- Create / edit epics under a project; tasks may attach to an epic or sit at project level.
- Create / edit tags (name + color) per project; select multiple on a task.
- Create / edit tasks with: title, markdown description, epic (optional), assignees, tags, status, comments.
- Kanban board shows five fixed status columns; drag-and-drop updates status.
- Filters: by assignee(s), tag(s), “assigned to me”, optionally by epic and status.

### 5.4 Communication

- `#general` exists by default for the shared team.
- `#standup` exists by default as the **standup bot’s channel** (bot-owned; members can read and reply during runs when the bot ships).
- Members can create custom channels.
- Realtime markdown messages + attachments in channels.

### 5.4.1 Standup channel (bot)

- Standup prompts, replies, skips, and summaries are posted in `#standup`.
- Participants = shared-team members with ≥1 `in_progress` task.
- Bot schedule / StandupRun orchestration ships in a later phase; the channel is seeded earlier with team bootstrap.

### 5.5 Integration (Chat ↔ PM)

- Messages may include a **task chip**; tapping opens task detail (deep link).
- Board/status changes may optionally **post a system/user message** to a linked or chosen channel.
- A project may optionally **link to a channel** (and vice versa) for context.

### 5.6 Notifications (as features land)

- Push via FCM for: mentions, task assignment, (later) reminders / standup.
- Deep links: `sebatpm://tasks/{id}`, `sebatpm://channels/{id}`.

## 6. Non-functional requirements

- Attachment limit: 10 MB per file; images and common document types.
- Soft delete / archive for projects and tasks.
- Optimistic UI + basic local cache; full offline-first sync is out of scope.
- Authenticated access to shared-team data; tighten roles when multi-workspace returns.

## 7. Out of scope (v2+)

- Multi-workspace create UI, invites, owner/admin role UX
- Private channels / DMs
- Story points, sprints, Gantt, custom workflows, subtasks
- Meeting reminders (parked until after dual-mode + standup run)
- Standup *schedule UI / bot orchestration* until its phase (channel itself is in scope)
- Full Notion-style rich text (use markdown + mentions + attachments)
- Custom status names or per-project column sets
- Always-ping-everyone standup mode

## 8. Acceptance criteria by epic

### Epic A — Foundations (Track S)

- Given a new user, when they sign in, then they reach the dual-mode shell (Chat default).
- Given bootstrap, when the team is initialized, then `#general` and `#standup` exist without a create-workspace UI.

### Epic B — Chat (Track C)

- Given `#general` or a custom channel, when members send messages, then messages appear in realtime for the shared team.

### Epic C — PM core (Track P)

- Given a project, when a member creates tasks and drags them across columns, then status updates and the board reflects the change for all members.
- Given filters for assignee/tag/me, when applied, then only matching tasks show.

### Epic D — Integration (Track I)

- Given a chat message with a task chip, when tapped, then task detail opens.
- Given a linked project/channel (or explicit post), when a board status changes, then a channel message can be created.
- Given a project, when a channel is linked, then the link persists and is visible in both modes.

### Epic E — Rich task collab (after PM slice)

- Markdown, attachments ≤10 MB, `@mentions` with FCM deep links, comments on tasks.

## 9. Delivery phases (parallel tracks)

| Phase | Outcome | Tracks |
|-------|---------|--------|
| 0 — Shared foundations | Repo, shell + mode switch, Firebase, Auth, implicit team + `#general` | S |
| 1a — Chat core | Channel list/create, realtime messages | C (parallel with 1b) |
| 1b — PM core | Projects, epics, tags, tasks, kanban, filters | P (parallel with 1a) |
| 2 — Integration | Task chips, deep links, board→channel posts, project↔channel | I |
| 3 — Rich task collab | Markdown, attachments, mentions on tasks | P (+ shared notifications) |
| 4 — Polish | Empty states, store readiness, crash/analytics | S |
| Later | Standup bot runs in `#standup` + meeting reminders | S |
| v2 | Multi-workspace, invites, roles | — |

UI mockups: [docs/design/mockups/](../design/mockups/).

## 10. Related docs

- Architecture: [../architecture/overview.md](../architecture/overview.md)
- Backlog: [backlog.md](backlog.md)
- Design mockups: [../design/mockups/README.md](../design/mockups/README.md)
- Agents: [../agents/README.md](../agents/README.md)
