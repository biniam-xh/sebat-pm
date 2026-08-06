# SebatPM — Product Backlog

Living backlog. Planner owns status updates. Statuses: `todo` | `in_progress` | `in_review` | `blocked` | `done` | `v2`.

**Tracks:** `S` shared shell/auth/team · `C` chat · `P` PM · `I` integration  

Confirmed defaults: Flutter + Firebase; dual-mode Chat (default) + Projects; implicit shared team; `#general` + `#standup` auto-seeded; auth = email/password + Google + Apple (iOS).

UI mockups: [docs/design/mockups/](../design/mockups/).

---

## Phase 0 — Shared foundations (Track S)

### T-001 — Repository and documentation baseline
- **Phase:** 0
- **Track:** S
- **Status:** done
- **Depends on:** none
- **PRD:** §9 Phase 0; agent docs
- **Architecture:** §3 repo layout

**Description**  
Establish docs pack (PRD, architecture, portable agents, backlog) so all contributors share context.

**Acceptance criteria**
- Given a fresh clone, when a contributor opens `AGENTS.md`, then they can find Planner/Developer/Tester load instructions.
- Given `docs/product/PRD.md` and `docs/architecture/overview.md`, when read, then MVP scope and stack are unambiguous.

**Out of scope**
- Flutter/Firebase app code

---

### T-002 — Flutter app shell
- **Phase:** 0
- **Track:** S
- **Status:** done
- **Depends on:** T-001
- **PRD:** §9 Phase 0
- **Architecture:** §3 Flutter feature folders

**Description**  
Create `apps/mobile` Flutter project with app bootstrap, routing stub, theme stub, and feature folder skeleton.

**Acceptance criteria**
- Given the repo, when `flutter run` is used on an emulator/simulator, then the app launches to a placeholder home screen.
- Given `lib/`, when inspected, then `app/`, `core/`, and `features/` skeletons exist per architecture.

**Out of scope**
- Real Auth UI beyond placeholder; Firestore wiring

---

### T-017 — Dual-mode shell (Chat | Projects)
- **Phase:** 0
- **Track:** S
- **Status:** done
- **Depends on:** T-002
- **PRD:** §5.2, Epic A
- **Architecture:** §8 Client shell

**Description**  
Replace single placeholder home with app shell: segmented **Chat | Projects** switch, Chat as default, stub bodies for each mode. Wire integration contract stubs under `lib/data/integration/`.

**Acceptance criteria**
- Given cold start, when the shell loads, then Chat mode is selected by default.
- Given the mode switch, when Projects is selected, then the Projects stub is shown (and Chat widgets are not imported by Projects).
- Given `lib/data/integration/`, when inspected, then `TaskRef` / `ChannelRef` stubs exist for Track I.

**Out of scope**
- Real channel/project data; Auth gate

---

### T-003 — Firebase project wiring
- **Phase:** 0
- **Track:** S
- **Status:** todo
- **Depends on:** T-017
- **PRD:** §2, §5.1
- **Architecture:** §1, §9

**Description**  
Connect the Flutter app to a Firebase `dev` project (Auth, Firestore, Storage, FCM placeholders). Document env setup.

**Acceptance criteria**
- Given valid `dev` config, when the app starts, then Firebase initializes without crash.
- Given docs, when a new developer follows setup steps, then they can point the app at `dev` without committed secrets.

**Out of scope**
- Production project hardening; CI deploy pipelines

---

### T-004 — Auth (email, Google, Apple)
- **Phase:** 0
- **Track:** S
- **Status:** todo
- **Depends on:** T-003
- **PRD:** §5.1, §2
- **Architecture:** §1 Auth

**Description**  
Implement sign-up/sign-in with email/password, Google, and Apple (iOS), plus sign-out and basic session restore into the dual-mode shell.

**Acceptance criteria**
- Given a new email user, when they register and sign in, then they reach the authenticated dual-mode shell.
- Given Google Sign-In (and Apple on iOS), when completed, then a Firebase session exists and `users/{uid}` profile doc is created/updated.
- Given a signed-in user, when they sign out, then protected screens are inaccessible.

**Out of scope**
- Password reset polish beyond Firebase default; MFA

---

### T-005 — Implicit team bootstrap + seed `#general` and `#standup`
- **Phase:** 0
- **Track:** S
- **Status:** todo
- **Depends on:** T-004
- **PRD:** §5.1, §5.4, Epic A
- **Architecture:** §4 team/channels; §7 `ensureSeedChannels`

**Description**  
No create-workspace UI. Ensure singleton shared team metadata and seed channels `general` (type `general`) and `standup` (type `standup`, bot-owned) via Cloud Function / bootstrap.

**Acceptance criteria**
- Given a signed-in user, when the app loads team data, then `#general` and `#standup` exist without a workspace create screen.
- Given a second authenticated user, when they open Chat, then they see the same `#general` and `#standup` channels.
- Given bootstrap idempotency, when run twice, then only one `general` and one `standup` channel exist.

**Out of scope**
- Multi-workspace; invites; standup bot *execution* (T-015)

---

### T-006 — Invite members by email
- **Phase:** 0
- **Track:** S
- **Status:** v2
- **Depends on:** multi-workspace
- **PRD:** §7 Out of scope

**Description**  
Parked: owner/admin invites while tenancy is a single shared team.

**Out of scope**
- Entire ticket until Workspace returns

---

## Phase 1a — Chat core (Track C) — parallel with 1b

### T-014 — Channel list, create channel, open `#general`
- **Phase:** 1a
- **Track:** C
- **Status:** todo
- **Depends on:** T-005
- **PRD:** §5.4, Epic B
- **Architecture:** §4 channels

**Description**  
Chat mode: list channels (including seeded `#general` and `#standup`), create custom channels, default selection `#general`.

**Acceptance criteria**
- Given the shared team, when Chat opens, then `#general` and `#standup` are listed and `#general` is selectable by default.
- Given a member, when they create a custom channel with a name, then it appears for other members.
- Given Chat UI, when inspected, then it does not import `features/projects` widgets.

**Out of scope**
- Message composer (T-018); DMs; standup bot prompts (T-015)

---

### T-018 — Realtime channel messages + composer
- **Phase:** 1a
- **Track:** C
- **Status:** todo
- **Depends on:** T-014
- **PRD:** §5.4, Epic B
- **Architecture:** §4 messages; §8 realtime

**Description**  
Send/receive markdown messages in a channel with realtime updates (attachments can be stubbed or follow-up).

**Acceptance criteria**
- Given an open channel, when user A sends a message, then user B sees it without manual refresh.
- Given the composer, when empty send is attempted, then it is rejected or no-op.
- Given messages, when listed, then order is chronological.

**Out of scope**
- Task chips (Track I); file attachments polish

---

## Phase 1b — PM core (Track P) — parallel with 1a

### T-007 — Create and archive projects
- **Phase:** 1b
- **Track:** P
- **Status:** todo
- **Depends on:** T-005
- **PRD:** §5.3
- **Architecture:** §4 projects

**Description**  
Members can create/edit projects; archive hides from default lists.

**Acceptance criteria**
- Given an authenticated user, when they create a project with name (and optional description), then it appears in the project list.
- Given a project, when archived, then it no longer appears in the default active list.

**Out of scope**
- Project↔channel link (Track I); templates

---

### T-008 — Epics under projects
- **Phase:** 1b
- **Track:** P
- **Status:** todo
- **Depends on:** T-007
- **PRD:** §5.3
- **Architecture:** §4 epics

**Description**  
Create/edit epics within a project (title, description, optional color).

**Acceptance criteria**
- Given a project, when a member creates an epic, then it is listed under that project.
- Given an epic, when edited, then changes persist for other members via realtime/refresh.

**Out of scope**
- Epic-level rollup reports

---

### T-009 — Tags create and select
- **Phase:** 1b
- **Track:** P
- **Status:** todo
- **Depends on:** T-007
- **PRD:** §5.3
- **Architecture:** §4 tags

**Description**  
Project-scoped tags with name + color; multi-select on tasks (task UI may land with T-010).

**Acceptance criteria**
- Given a project, when a member creates a tag, then it is available for selection on tasks in that project.
- Given tags, when assigned to a task, then multiple tags can be selected and persisted.

**Out of scope**
- Team-global tags

---

### T-010 — Tasks CRUD with assignees and epic
- **Phase:** 1b
- **Track:** P
- **Status:** todo
- **Depends on:** T-008, T-009
- **PRD:** §5.3
- **Architecture:** §4 tasks

**Description**  
Create/edit tasks with title, plain description (markdown rich collab later), optional epic, assignees, tags, and status default `backlog`.

**Acceptance criteria**
- Given a project, when a member creates a task with title, then it is stored with status `backlog`.
- Given a task, when epic, assignees, and tags are set, then those fields persist and are visible to other members.
- Given a task, when opened, then detail shows title, description, epic, assignees, tags, status.

**Out of scope**
- Comments, attachments, mentions; Chat imports

---

### T-011 — Kanban board by status
- **Phase:** 1b
- **Track:** P
- **Status:** todo
- **Depends on:** T-010
- **PRD:** §5.3, Epic C
- **Architecture:** §4 status enum

**Description**  
Board with columns `backlog`, `ready`, `in_progress`, `in_review`, `done`. Drag-and-drop updates status.

**Acceptance criteria**
- Given project tasks, when the board opens, then tasks appear in the column matching their status.
- Given a drag from one column to another, when dropped, then task status updates and other clients see the move.
- Given refresh, when board reloads, then positions match stored statuses.

**Out of scope**
- Custom columns; WIP limits; auto channel posts (Track I)

---

### T-012 — Task filters (users, tags, assigned to me)
- **Phase:** 1b
- **Track:** P
- **Status:** todo
- **Depends on:** T-011
- **PRD:** §5.3, Epic C
- **Architecture:** §4 tasks fields

**Description**  
Filter board/list by assignee(s), tag(s), and “assigned to me”; optional epic/status filters if cheap.

**Acceptance criteria**
- Given tasks with varied assignees/tags, when filter by assignee is applied, then only matching tasks show.
- Given tags, when filter by tag is applied, then only tasks with that tag show.
- Given the current user, when “assigned to me” is on, then only tasks including their uid in assigneeIds show.
- Given filters cleared, when viewing board, then all active tasks show again.

**Out of scope**
- Saved filter presets

---

## Phase 2 — Integration (Track I)

### T-019 — Task chip in chat + open task deep link
- **Phase:** 2
- **Track:** I
- **Status:** todo
- **Depends on:** T-018, T-010
- **PRD:** §5.5, Epic D
- **Architecture:** §8 integration contracts

**Description**  
Render `TaskRef` chips in messages; tap navigates to task detail via router (no Chat→Projects widget imports).

**Acceptance criteria**
- Given a message with `taskRef`, when shown in Chat, then a task chip with title/status is visible.
- Given the chip, when tapped, then task detail opens via `/pm/tasks/:taskId` (or equivalent).
- Given feature folders, when inspected, then Chat does not import PM widgets.

**Out of scope**
- Creating tasks from chat composer polish

---

### T-020 — Board status → channel post
- **Phase:** 2
- **Track:** I
- **Status:** todo
- **Depends on:** T-011, T-018, T-007
- **PRD:** §5.5, Epic D
- **Architecture:** §7 `onTaskStatusChanged`; §8 `postBoardEventToChannel`

**Description**  
When a task status changes and the project has posting enabled / linked channel, write a board-event message using the integration contract.

**Acceptance criteria**
- Given a project linked to a channel (or explicit post target), when a task moves columns, then a channel message appears with task id/title and status change.
- Given no link and posting disabled, when status changes, then no channel message is created.
- Given PM code, when posting, then it uses integration contract (not Chat widgets).

**Out of scope**
- Fancy notification digests

---

### T-021 — Project ↔ channel link
- **Phase:** 2
- **Track:** I
- **Status:** todo
- **Depends on:** T-007, T-014
- **PRD:** §5.5, Epic D
- **Architecture:** §4 `projectId` / `channelId`

**Description**  
Allow optional link between a project and a channel; persist both sides’ references; show link affordance in both modes.

**Acceptance criteria**
- Given a project and a channel, when linked, then `projects.channelId` and `channels.projectId` are set consistently.
- Given either side, when opened, then the linked counterpart is visible/navigable.
- Given unlink, when confirmed, then both references clear.

**Out of scope**
- Auto-creating a channel per project (can be a later convenience)

---

## Phase 3 — Rich task collab

### T-013 — Markdown descriptions/comments + attachments + mentions
- **Phase:** 3
- **Track:** P
- **Status:** todo
- **Depends on:** T-012
- **PRD:** §5.3, Epic E
- **Architecture:** §5 Storage; §7 onMention

**Description**  
Rich task collab: markdown, attachments ≤10 MB, `@mentions` with FCM deep links, comments thread on task.

**Acceptance criteria**
- Given markdown + attachment + mention on a task/comment, when saved, then content renders, file stores, mentioned user can be notified.

**Out of scope**
- Block editor

---

## Later / v2 parking

### T-015 — Standup bot in `#standup`
- **Phase:** later
- **Track:** S
- **Status:** todo
- **Depends on:** T-005, T-011, T-018
- **PRD:** §5.4.1
- **Architecture:** §7 Standup in `#standup`

**Description**  
Scheduled StandupRun for members with `in_progress` tasks. Bot posts sequential prompts, timeout skips, and summary **in the `#standup` channel** (already seeded by T-005).

**Acceptance criteria**
- Given schedule fire and members with `in_progress` tasks, when the run starts, then prompts appear in `#standup` in order.
- Given a participant reply or timeout, when recorded, then the bot advances to the next participant.
- Given zero participants, when the run starts, then an informative message is posted in `#standup` and the run completes.
- Given run end, when configured, then a summary is posted in `#standup`.

**Out of scope**
- Always-ping-everyone mode; multi-workspace schedules


### T-016 — Meeting reminders
- **Phase:** later
- **Track:** S
- **Status:** v2
- **Depends on:** T-005
- **PRD:** §7

**Description**  
Parked group reminders + FCM.

### v2 list

- Multi-workspace create UI + invites + roles
- Private channels / DMs
- Custom status workflows
- Subtasks, story points, sprints, Gantt
- Full offline-first sync
- Always-ping-everyone standup mode
- Notion-style block editor
