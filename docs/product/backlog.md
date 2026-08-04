# SebatPM — Product Backlog

Living backlog. Planner owns status updates. Statuses: `todo` | `in_progress` | `in_review` | `blocked` | `done` | `v2`.

Confirmed defaults: Flutter + Firebase; standup only for members with `in_progress` tasks; auth = email/password + Google + Apple (iOS).

---

## Phase 0 — Foundations

### T-001 — Repository and documentation baseline
- **Phase:** 0
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
- **Status:** in_review
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

### T-003 — Firebase project wiring
- **Phase:** 0
- **Status:** todo
- **Depends on:** T-002
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
- **Status:** todo
- **Depends on:** T-003
- **PRD:** §5.1, §2
- **Architecture:** §1 Auth

**Description**  
Implement sign-up/sign-in with email/password, Google, and Apple (iOS), plus sign-out and basic session restore.

**Acceptance criteria**
- Given a new email user, when they register and sign in, then they reach an authenticated shell.
- Given Google Sign-In (and Apple on iOS), when completed, then a Firebase session exists and `users/{uid}` profile doc is created/updated.
- Given a signed-in user, when they sign out, then protected screens are inaccessible.

**Out of scope**
- Password reset polish beyond Firebase default; MFA

---

### T-005 — Create workspace + seed channels
- **Phase:** 0
- **Status:** todo
- **Depends on:** T-004
- **PRD:** §5.1, Epic A
- **Architecture:** §4, §7 `onWorkspaceCreate`

**Description**  
Allow an authenticated user to create a workspace (become `owner`). On create, seed `#general` and `#standup` and default standupConfig.

**Acceptance criteria**
- Given an authenticated user, when they create a workspace, then they are `owner` in `members/{uid}`.
- Given workspace creation, when complete, then channels `general` and `standup` exist and standupConfig has defaults.
- Given the user, when they open the app, then the workspace is selectable/visible.

**Out of scope**
- Multi-workspace switcher polish beyond listing; standup execution

---

### T-006 — Invite members by email
- **Phase:** 0
- **Status:** todo
- **Depends on:** T-005
- **PRD:** §5.1, Epic A
- **Architecture:** §4 invites; §6 admin role

**Description**  
Owner/admin invites by email; invitee can accept and join as `member`.

**Acceptance criteria**
- Given an admin/owner, when they invite an email, then an invite record is created.
- Given an invitee with a matching account, when they accept, then they appear in `members` with role `member`.
- Given a non-admin member, when they attempt to invite, then the action is denied.

**Out of scope**
- SSO; invite expiry UX polish; role promotion UI (can be a small follow-up in Phase 0 if needed)

---

## Phase 1 — PM core

### T-007 — Create and archive projects
- **Phase:** 1
- **Status:** todo
- **Depends on:** T-006
- **PRD:** §5.2
- **Architecture:** §4 projects

**Description**  
Members can create/edit projects; admin/member can archive. Archived projects are hidden from default lists.

**Acceptance criteria**
- Given a workspace member, when they create a project with name (and optional description), then it appears in the project list.
- Given a project, when archived, then it no longer appears in the default active list and tasks are not shown on the main board entry points.

**Out of scope**
- Project templates; soft-delete recovery UI beyond unarchive if trivial

---

### T-008 — Epics under projects
- **Phase:** 1
- **Status:** todo
- **Depends on:** T-007
- **PRD:** §5.2
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
- **Phase:** 1
- **Status:** todo
- **Depends on:** T-007
- **PRD:** §5.2
- **Architecture:** §4 tags

**Description**  
Project-scoped tags with name + color; multi-select on tasks (task UI may land with T-010).

**Acceptance criteria**
- Given a project, when a member creates a tag, then it is available for selection on tasks in that project.
- Given tags, when assigned to a task, then multiple tags can be selected and persisted.

**Out of scope**
- Workspace-global tags

---

### T-010 — Tasks CRUD with assignees and epic
- **Phase:** 1
- **Status:** todo
- **Depends on:** T-008, T-009
- **PRD:** §5.2
- **Architecture:** §4 tasks

**Description**  
Create/edit tasks with title, plain description (markdown rich collab is Phase 2), optional epic, assignees, tags, and status default `backlog`.

**Acceptance criteria**
- Given a project, when a member creates a task with title, then it is stored with status `backlog`.
- Given a task, when epic, assignees, and tags are set, then those fields persist and are visible to other members.
- Given a task, when opened, then detail shows title, description, epic, assignees, tags, status.

**Out of scope**
- Comments, attachments, mentions (Phase 2)

---

### T-011 — Kanban board by status
- **Phase:** 1
- **Status:** todo
- **Depends on:** T-010
- **PRD:** §5.2, Epic B
- **Architecture:** §4 status enum

**Description**  
Physical board with columns `backlog`, `ready`, `in_progress`, `in_review`, `done`. Drag-and-drop updates status.

**Acceptance criteria**
- Given project tasks, when the board opens, then tasks appear in the column matching their status.
- Given a drag from one column to another, when dropped, then task status updates and other clients see the move.
- Given refresh, when board reloads, then positions match stored statuses.

**Out of scope**
- Custom columns; WIP limits

---

### T-012 — Task filters (users, tags, assigned to me)
- **Phase:** 1
- **Status:** todo
- **Depends on:** T-011
- **PRD:** §5.2, Epic B
- **Architecture:** §4 tasks fields

**Description**  
Filter board/list by assignee(s), tag(s), and “assigned to me”; optional epic/status filters if cheap.

**Acceptance criteria**
- Given tasks with varied assignees/tags, when filter by assignee is applied, then only matching tasks show.
- Given tags, when filter by tag is applied, then only tasks with that tag show.
- Given the current user, when “assigned to me” is on, then only tasks including their uid in assigneeIds show.
- Given filters cleared, when viewing board, then all active tasks show again.

**Out of scope**
- Saved filter presets; complex query builder

---

## Phase 2+ (stubs only — not started)

### T-013 — Markdown descriptions/comments + attachments + mentions
- **Phase:** 2
- **Status:** todo
- **Depends on:** T-012
- **PRD:** §5.2, Epic C

**Description**  
Rich task collab: markdown, attachments ≤10 MB, `@mentions` with FCM deep links, comments thread on task.

### T-014 — Chat channels and realtime messages
- **Phase:** 3
- **Status:** todo
- **Depends on:** T-005
- **PRD:** §5.3, Epic D

**Description**  
`#general`, create custom channels, realtime markdown messages + attachments.

### T-015 — Standup bot
- **Phase:** 4
- **Status:** todo
- **Depends on:** T-014, T-011
- **PRD:** §5.3, Epic E

**Description**  
Scheduled StandupRun for members with `in_progress` tasks; sequential prompts; timeout skip; summary.

### T-016 — Meeting reminders
- **Phase:** 4
- **Status:** todo
- **Depends on:** T-005
- **PRD:** §5.3, Epic E

**Description**  
Create group reminders; FCM at schedule; optional channel post.

---

## v2 parking lot

- Private channels / DMs
- Custom status workflows
- Subtasks, story points, sprints, Gantt
- Full offline-first sync
- Always-ping-everyone standup mode
- Notion-style block editor
