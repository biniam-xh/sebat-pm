# SebatPM — Architecture Overview

## 1. Stack

| Layer | Choice |
|-------|--------|
| Mobile | Flutter (iOS + Android) |
| Auth | Firebase Authentication (email/password, Google, Apple) |
| Database | Cloud Firestore |
| Files | Firebase Storage |
| Push | Firebase Cloud Messaging (FCM) |
| Backend jobs | Cloud Functions + Cloud Scheduler |

## 2. High-level flow

```
Flutter app
  ├── Firebase Auth
  ├── Firestore (realtime boards, chat, standup state)
  ├── Storage (attachments)
  └── FCM (mentions, reminders, standup turn)

Cloud Functions
  ├── onMention / onAssignment → FCM
  ├── scheduledStandup → StandupRun orchestration
  ├── scheduledReminder → FCM + optional channel message
  └── standupReply handler / timeout advance
```

## 3. Repository layout

```
SebatPM/
  apps/mobile/           # Flutter app
  functions/             # Cloud Functions (TypeScript recommended)
  docs/
    product/
    architecture/
    agents/
  AGENTS.md
  .cursor/rules/         # Optional Cursor pointers only
```

### Flutter feature folders (target)

```
apps/mobile/lib/
  app/                   # bootstrap, router, theme
  core/                  # shared widgets, theme, utils
  features/
    auth/
    workspace/
    projects/            # projects, epics, tags, tasks, kanban
    chat/
    standup/             # client UI for standup channel
    reminders/
    notifications/
  data/                  # repositories, DTOs, Firestore mappers
```

## 4. Firestore data model (sketch)

Paths are workspace-scoped. IDs are Firebase Auth UIDs or auto-ids.

```
users/{userId}
  displayName, email, photoUrl, fcmTokens[], createdAt

workspaces/{workspaceId}
  name, timezone, createdBy, createdAt
  members/{userId}
    role: owner | admin | member
    joinedAt
  invites/{inviteId}
    email, role, status, createdBy, createdAt
  projects/{projectId}
    name, description, archived, createdAt, updatedAt
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
  channels/{channelId}
    name, type: general | custom | standup,
    createdBy, createdAt
    messages/{messageId}
      bodyMd, authorId, attachmentIds[], mentionIds[],
      standupRunId?, createdAt
  standupConfig
    enabled, cadence: daily | weekly, timeLocal, timezone,
    timeoutMinutes (default 15)
  standupRuns/{runId}
    status: running | completed | cancelled
    participantIds[], currentIndex, startedAt, completedAt
    answers/{userId}
      text, taskIds[], respondedAt | skippedAt
  reminders/{reminderId}
    title, body, scheduleAt | cron, channelId?,
    createdBy, status
  attachments/{attachmentId}
    storagePath, mimeType, sizeBytes, uploadedBy, createdAt
```

### Task status enum

`backlog` | `ready` | `in_progress` | `in_review` | `done`

## 5. Storage layout

```
workspaces/{workspaceId}/
  tasks/{taskId}/{attachmentId}
  comments/{commentId}/{attachmentId}
  channels/{channelId}/{messageId}/{attachmentId}
```

Limits: max 10 MB per file; allow images and common docs (pdf, txt, md, docx, etc.). Validate in client and Cloud Function / Storage rules.

## 6. Security rules (sketch)

Principles:

- Authenticated only.
- Membership required for all workspace reads/writes.
- Role gates: invites, standupConfig, archive project → `admin` or `owner`.
- Task/comment/message create: any member; update own content or assignee fields as defined.
- `#standup` bot messages: written only by privileged Functions (Admin SDK); clients may post replies during their turn.
- Attachment metadata must match membership; Storage rules mirror workspace membership.

Example patterns (illustrative, not final):

```
function isMember(workspaceId) {
  return exists(/databases/$(database)/documents/workspaces/$(workspaceId)/members/$(request.auth.uid));
}

function memberRole(workspaceId) {
  return get(/databases/$(database)/documents/workspaces/$(workspaceId)/members/$(request.auth.uid)).data.role;
}

function isAdmin(workspaceId) {
  return memberRole(workspaceId) in ['owner', 'admin'];
}
```

## 7. Cloud Functions

| Function | Trigger | Behavior |
|----------|---------|----------|
| `onWorkspaceCreate` | Firestore create | Seed `#general`, `#standup`, default standupConfig |
| `onMention` | Task/comment/message write | Detect new mentionIds → FCM deep link |
| `onTaskAssigned` | Task update | Notify new assignees |
| `scheduledStandupTick` | Cloud Scheduler | For due workspaces, start StandupRun; post first prompt |
| `onStandupMessage` | Channel message | If active run and author is current user, record answer, advance |
| `standupTimeout` | Scheduled / delayed | Skip current user if no answer; advance |
| `scheduledReminder` | Scheduler | Send FCM; optional channel post |

### Standup algorithm

1. Load members with ≥1 task where `status == in_progress` in any non-archived project.
2. If empty, post “No in-progress tasks today” and complete run.
3. Else create `standupRuns/{runId}` with ordered `participantIds`.
4. Post prompt for `participantIds[currentIndex]` listing their in-progress tasks.
5. On reply or timeout → write `answers/{userId}` → increment index → next prompt or summary.

## 8. Client concerns

- Use Firestore realtime listeners for board and channel.
- Optimistic local updates for drag-and-drop status changes.
- Markdown render for descriptions, comments, messages.
- Mention picker inserts stable `@[displayName](userId)` or equivalent structured mention.
- Deep links: `sebatpm://tasks/{id}`, `sebatpm://channels/{id}`.

## 9. Environments

- `dev` and `prod` Firebase projects.
- Flutter flavors or `--dart-define` for Firebase config.
- Never commit service account keys; use CI secrets.

## 10. Related docs

- PRD: [../product/PRD.md](../product/PRD.md)
- Backlog: [../product/backlog.md](../product/backlog.md)
- Agents: [../agents/README.md](../agents/README.md)
