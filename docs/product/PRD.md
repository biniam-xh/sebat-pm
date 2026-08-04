# SebatPM — Product Requirements Document (MVP)

## 1. Vision

SebatPM is a mobile project-management and team-communication app for small teams. It combines a Trello-like kanban board (projects, epics, tasks, tags) with workspace chat, an automated standup bot, and group meeting reminders.

## 2. Confirmed decisions

| Decision | Choice |
|----------|--------|
| Clients | Flutter (iOS + Android) |
| Backend | Firebase (Auth, Firestore, Storage, FCM, Cloud Functions) |
| Standup targeting | Ping only members who have ≥1 task in `in_progress` |
| Auth (MVP) | Email/password, Google Sign-In, Apple Sign-In (iOS) |
| Agent docs | Portable markdown in `docs/agents/` (tool-agnostic) |

## 3. Personas

- **Owner / Admin** — Creates workspace, invites members, configures standup schedule and reminders.
- **Member** — Works on tasks, comments, chats, responds to standup prompts.
- **Standup bot** — System actor that runs scheduled standup sessions in `#standup`.

## 4. Domain model

| Entity | MVP fields / rules |
|--------|-------------------|
| **Workspace** | Multi-tenant root. Members + roles: `owner`, `admin`, `member`. |
| **Project** | Name, description, archived flag. Owns epics, tasks, tags. |
| **Epic** | Title, description, projectId, optional color. Tasks may be epic-less (project-level). |
| **Task** | Title, rich description, status, assignees[], tags[], epicId?, projectId, createdBy, timestamps. |
| **Status** | Fixed: `backlog` → `ready` → `in_progress` → `in_review` → `done`. Kanban columns; drag changes status. |
| **Tag** | Project-scoped name + color. Multi-select on tasks. |
| **Comment** | Markdown text, attachments, `@mentions`, author, timestamps. |
| **Channel** | Types: `general` (auto), `custom`, `standup` (bot-owned). Public-in-workspace for MVP. |
| **Message** | Markdown + mentions, attachments. |
| **Reminder** | Title, body, schedule (one-shot or recurring), target workspace or channel. |
| **StandupRun** | Ordered user list, current user, answers, timeout, summary. |

## 5. Functional requirements

### 5.1 Auth & workspace

- Users sign up / sign in with email/password, Google, or Apple (iOS).
- User can create a workspace and become `owner`.
- Admin/owner invites members by email; invitee joins with role `member` (promotable).
- Only admin+ manages invites, standup schedule, and workspace settings.

### 5.2 Project management

- Create / edit / archive projects.
- Create / edit epics under a project; tasks may attach to an epic or sit at project level.
- Create / edit tags (name + color) per project; select multiple on a task.
- Create / edit tasks with: title, markdown description, epic (optional), assignees, tags, status, comments.
- Descriptions and comments support markdown, image/file attachments, and `@user` mentions.
- Mentions send push notification with deep link to the task.
- Kanban board shows five fixed status columns; drag-and-drop updates status.
- Filters: by assignee(s), tag(s), “assigned to me”, optionally by epic and status.

### 5.3 Communication

- Each workspace auto-creates `#general`.
- Members can create custom channels (public within workspace).
- `#standup` channel is bot-controlled:
  - Admin sets schedule (e.g. daily/weekly at a local time in workspace timezone).
  - At fire time, a Cloud Function starts a `StandupRun`.
  - Participants = workspace members with ≥1 `in_progress` task.
  - Bot asks each participant in order: lists their in-progress tasks and requests a short update.
  - User reply is recorded; bot advances; timeout (default 15 min) skips with “no update”.
  - End of run posts an optional summary message.
- Meeting reminders: create with datetime + message; FCM to workspace members; optional channel post.

### 5.4 Notifications

- Push via FCM for: mentions, meeting reminders, standup turn (optional), task assignment (recommended).
- Deep links into task detail or channel.

## 6. Non-functional requirements

- Attachment limit: 10 MB per file; images and common document types.
- Soft delete / archive for projects and tasks.
- Optimistic UI + basic local cache; full offline-first sync is out of scope.
- Roles enforced in Firestore security rules and Cloud Functions.

## 7. Out of scope (v2+)

- Story points, sprints, Gantt, custom workflows, subtasks.
- DMs, private channels, message threads (except standup reply capture).
- Video / voice / email ingest.
- Custom status names or per-project column sets.
- Full Notion-style rich text (use markdown + mentions + attachments).
- Always-ping-everyone standup mode (configurable later if needed).

## 8. Acceptance criteria by epic

### Epic A — Foundations

- Given a new user, when they sign up and create a workspace, then they are owner and `#general` + `#standup` exist.
- Given an admin invite, when the invitee accepts, then they appear as a member.

### Epic B — PM core

- Given a project, when a member creates tasks and drags them across columns, then status updates and board reflects the change for all members.
- Given filters for assignee/tag/me, when applied, then only matching tasks show.

### Epic C — Rich collab

- Given a task description or comment with markdown, attachment, and `@mention`, when saved, then content renders, file is stored, and mentioned user gets a push deep-linked to the task.

### Epic D — Chat

- Given `#general` or a custom channel, when members send messages, then messages appear in realtime for workspace members.

### Epic E — Automation

- Given standup schedule and members with in-progress tasks, when the schedule fires, then the bot runs a sequential standup and posts a summary.
- Given a meeting reminder, when the time arrives, then members receive FCM (and optional channel post).

## 9. Delivery phases

| Phase | Outcome |
|-------|---------|
| 0 — Foundations | Repo, Flutter shell, Firebase, Auth, Workspace + invites, agent docs |
| 1 — PM core | Projects, epics, tags, tasks, kanban, filters, assignees |
| 2 — Rich task collab | Markdown, attachments, @mentions + push |
| 3 — Chat | #general, create channel, realtime messages, attachments |
| 4 — Automation | Standup bot + meeting reminders |
| 5 — Polish | Store readiness, roles polish, empty states, crash/analytics |

## 10. Related docs

- Architecture: [../architecture/overview.md](../architecture/overview.md)
- Backlog: [backlog.md](backlog.md)
- Agents: [../agents/README.md](../agents/README.md)
