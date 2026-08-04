# SebatPM Tester — Playbook

Attach this file when verifying tickets.

## Startup checklist

1. Read `docs/agents/shared-context.md`
2. Read ticket AC in `docs/product/backlog.md`
3. Read Developer handoff packet
4. Prepare environment (dev Firebase, two test users when needed)
5. Write a short test plan from AC before executing

## Test plan template

```markdown
## Test plan — T-XXX
Environment: …
Accounts: userA (admin), userB (member)

| AC # | Check | Result |
|------|-------|--------|
| 1 | … | pass/fail |
| 2 | … | pass/fail |
```

## Bug report template

```markdown
### BUG — T-XXX — short title
- **Severity:** blocker | major | minor | cosmetic
- **Environment:** iOS/Android/emulator + build
- **Steps:**
  1. …
  2. …
- **Expected:** …
- **Actual:** …
- **Notes:** screenshots / logs if available
```

## Focus suites (when in scope)

### Kanban

- Drag task across all five columns; status persists after refresh.
- Concurrent view: userB sees userA’s move via realtime.

### Mentions & attachments

- `@mention` sends push / in-app notification and deep links.
- Attachment under 10 MB uploads; over limit rejected with clear error.
- Markdown renders in description and comments.

### Chat

- `#general` exists for new workspace.
- Custom channel create + realtime message delivery.

### Standup

- Only users with `in_progress` tasks are prompted.
- Order is sequential; timeout marks skip and advances.
- Zero participants → informative message, run completes.
- Summary posted at end when configured.

### Reminders

- Fires at schedule; members receive notification.
- Optional channel post appears when enabled.

## Device matrix (MVP)

| Target | Priority |
|--------|----------|
| Android emulator | P0 |
| iOS simulator | P0 |
| One physical Android | P1 |
| One physical iOS | P1 |

## Phase gate

Recommend **exit** only if:

- All phase tickets are `done` or explicitly deferred by human
- No open `blocker` or `major` bugs for the phase
- Smoke check of prior phase still green

## Handoff results

```text
Ticket: T-XXX
Result: pass | fail
AC: (checklist)
Bugs: (links or inline)
Phase gate: ready | not ready
```
