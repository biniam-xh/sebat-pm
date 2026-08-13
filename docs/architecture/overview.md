# SebatPM — Architecture Overview

## 1. Stack

| Layer | Choice |
|-------|--------|
| Mobile | Flutter (iOS + Android) |
| Auth | Firebase Authentication (email/password, Google, Apple) |
| Database | Cloud Firestore |
| Files | Firebase Storage |
| Push | Firebase Cloud Messaging (FCM) |
| Backend jobs | Cloud Functions (+ Cloud Scheduler later) |

## 2. High-level flow

```
Flutter app (dual mode)
  ├── App shell — Chat | Projects mode switch (Chat default)
  ├── Firebase Auth
  ├── Firestore (realtime boards + chat)
  ├── Storage (attachments)
  └── FCM (mentions, assignments, later automation)

Cloud Functions
  ├── onTeamBootstrap / seed — ensure #general + #standup exist
  ├── onMention / onAssignment → FCM
  └── (later) standup runs in #standup + reminders
```

## 3. Repository layout

```
SebatPM/
  apps/mobile/           # Flutter app
  functions/             # Cloud Functions (TypeScript recommended)
  docs/
    product/
    architecture/
    design/mockups/
    agents/
  AGENTS.md
  .cursor/rules/         # Optional Cursor pointers only
```

### Flutter feature folders (target)

```
apps/mobile/lib/
  app/                   # bootstrap, router, theme, shell + mode switch
  core/                  # shared widgets, utils
  features/
    auth/                # Track S
    chat/                # Track C — never import features/projects widgets
    projects/            # Track P — never import features/chat widgets
    notifications/
    standup/             # later: client UI for #standup bot runs
    # workspace/, reminders/ — multi-tenant / later
  data/
    integration/         # TaskRef, ChannelRef, board→channel contract
    # repositories, DTOs, Firestore mappers
```

**Parallel ownership:** Track C owns `features/chat/`; Track P owns `features/projects/`; Track S owns `app/` shell + auth; Track I owns `data/integration/` + deep-link routes. Cross-track UI only via router + contracts.

## 4. Firestore data model (sketch)

MVP uses an **implicit shared team** (single tenant). Prefer top-level collections (simpler than nested `workspaces/{id}` until multi-tenant returns).

```
users/{userId}
  displayName, email, photoUrl, fcmTokens[], createdAt

team/default                 # singleton metadata (name, timezone, createdAt)
  # optional members/{userId} later when roles return

channels/{channelId}
  name, type: general | custom | standup,
  projectId?, createdBy, createdAt
  messages/{messageId}
    bodyMd, authorId, attachmentIds[], mentionIds[],
    taskRef?: { taskId, title, status },
    boardEvent?: { projectId, taskId, fromStatus?, toStatus? },
    standupRunId?, createdAt

standupConfig                     # team singleton (or team/default/standupConfig)
  enabled, cadence: daily | weekly, timeLocal, timezone,
  timeoutMinutes (default 15), channelId (defaults to #standup)

standupRuns/{runId}
  status: running | completed | cancelled
  participantIds[], currentIndex, startedAt, completedAt
  answers/{userId}
    text, taskIds[], respondedAt | skippedAt

projects/{projectId}
  name, description, archived, channelId?,
  createdAt, updatedAt
  epics/{epicId}
    title, description, color, createdAt
  tags/{tagId}
    name, color
  tasks/{taskId}
    title, descriptionMd, status, epicId?,
    assigneeIds[], tagIds[], createdBy,
    createdAt, updatedAt, archived
    comments/{commentId}
      bodyMd, authorId, attachmentIds[], mentionIds[], createdAt

attachments/{attachmentId}
  storagePath, mimeType, sizeBytes, uploadedBy, createdAt
```

Seed: ensure channels with `type == general` (`#general`) and `type == standup` (`#standup`) exist (Cloud Function on deploy / first auth bootstrap). `#standup` is bot-owned; members read and reply during runs.

### Task status enum

`backlog` | `ready` | `in_progress` | `in_review` | `done`

## 5. Storage layout

```
attachments/{attachmentId}/...
# or scoped:
projects/{projectId}/tasks/{taskId}/{attachmentId}
channels/{channelId}/{messageId}/{attachmentId}
```

Limits: max 10 MB per file; allow images and common docs. Validate in client and Storage rules.

## 6. Security rules (sketch)

Principles (MVP shared team):

- Authenticated only for reads/writes.
- Any authenticated user may read/write shared-team channels, projects, tasks (tighten when roles/workspaces return).
- Attachment metadata must match authenticated uploader; size/MIME validated.

When multi-workspace returns, restore membership helpers (`isMember`, `isAdmin`).

## 7. Cloud Functions

| Function | Trigger | Behavior |
|----------|---------|----------|
| `ensureSeedChannels` | Deploy / first run / Auth create | Seed `#general` and `#standup` if missing |
| `onMention` | Task/comment/message write | Detect new mentionIds → FCM deep link |
| `onTaskAssigned` | Task update | Notify new assignees |
| `onTaskStatusChanged` (opt) | Task status update | If project has `channelId` and posting enabled, write board-event message |

Parked until later phase: standup *scheduler* + reminder schedulers (channel `#standup` is seeded earlier).

### Standup in `#standup` (later phase)

1. Load members with ≥1 task where `status == in_progress` in any non-archived project.
2. If empty, post “No in-progress tasks today” in `#standup` and complete run.
3. Else create `standupRuns/{runId}` with ordered `participantIds`.
4. Post prompt in `#standup` for `participantIds[currentIndex]` listing their in-progress tasks.
5. On reply or timeout → write `answers/{userId}` → increment index → next prompt or summary.

## 8. Client concerns

### Shell / navigation

- `AppMode.chat` | `AppMode.projects` segmented control on shell.
- Cold start → Chat → prefer `#general`.
- Routes: `/` shell, `/chat/:channelId`, `/pm/projects/:projectId`, `/pm/tasks/:taskId`.

### Integration contracts (`lib/data/integration/`)

- `TaskRef` — taskId, title, status  
- `ChannelRef` — channelId, name  
- `BoardChannelPoster` / `postBoardEventToChannel(...)` — PM calls; Chat owns message schema  
- Chat never imports PM widgets; PM never imports Chat widgets  

### Other

- Firestore realtime listeners for board and channel.
- Optimistic local updates for drag-and-drop status changes.
- Markdown render for descriptions, comments, messages.
- Deep links: `sebatpm://tasks/{id}`, `sebatpm://channels/{id}`.

## 9. Environments

- `dev` and `prod` Firebase projects.
- FlutterFire generates `lib/firebase_options.dart` (gitignored); see [docs/setup/firebase-dev.md](../setup/firebase-dev.md).
- Never commit service account keys, `google-services.json`, or `GoogleService-Info.plist`; use CI secrets for prod.

## 10. Related docs

- PRD: [../product/PRD.md](../product/PRD.md)
- Backlog: [../product/backlog.md](../product/backlog.md)
- Mockups: [../design/mockups/README.md](../design/mockups/README.md)
- Agents: [../agents/README.md](../agents/README.md)
