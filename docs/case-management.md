---
status: planned
related:
  - case-creation.md
  - task-management.md
  - email-reply.md
  - ai-classification.md
  - manager-dashboard.md
  - field-audit.md
data_model:
  - Case
  - CaseNote
  - User
  - Category
---

# Case Management

## Intent

As an IR case worker, I want to view my queue of cases, open a case to see its full email thread and details, assign it, change its status, add internal notes, and resolve it — all from a single case workspace.

## Case list (queue view)

- Default view: cases assigned to the logged-in user, sorted by priority (URGENT first) then `created_at` asc.
- Filters: status, priority, category, assignee (managers only), date range.
- Unassigned cases surfaced in a separate section (case workers can self-assign).
- Row-level security: case workers see only their assigned cases + unassigned. Managers see all.

## Case workspace (detail view)

Sections:
1. **Header** — reference number, subject, status badge, priority badge, category, assignee, created/resolved dates.
2. **Email thread** — all `CaseEmail` records ordered by `received_at`. Each email shows sender, timestamp, body. Outbound replies visually distinguished.
3. **AI summary** — `Case.ai_summary` shown in a callout panel (collapsible).
4. **Actions panel** — Reply, Add Note, Change Status, Reassign, Change Priority, Change Category.
5. **Tasks** — list of `CaseTask` records; link to task management. See [[task-management]].
6. **Internal notes** — `CaseNote` records, reverse-chronological. Not visible to investors.

## Status transitions

```
OPEN → IN_PROGRESS → PENDING → RESOLVED → CLOSED
         ↑___________________↓  (re-open if new email arrives)
```

- `PENDING` = waiting on investor response.
- `RESOLVED` = answer sent, no further action expected. Sets `resolved_at`.
- `CLOSED` = archived. Manual action by manager or auto-close after N days resolved (TBD).
- Any new inbound email on a `RESOLVED` / `CLOSED` case re-opens to `IN_PROGRESS`.

## Case assignment

### Who can assign

Both case workers and managers can assign a case to any active Appian user. There is no restriction by role or team.

### Actions

| Action | Description |
|---|---|
| Assign | Set `Case.assigned_to` to a chosen user. Available when case is unassigned or already assigned. |
| Unassign | Clear `Case.assigned_to` (set to null). Returns case to the unassigned queue. |
| Self-assign | Shortcut — assigns the case to the logged-in user without a picker. Available from both the case list and case workspace. |

### UI — IQH_Action_AssignCase form

Opens as a standalone Appian action form (navigates away from the case workspace; Cancel returns to it).

**Layout:**

```
┌─ Assign Case ─────────────────────────────────────┐
│ IQ-2026-00142 · Fee query re Fund III              │
│ Status: OPEN   Priority: HIGH                      │
│ Current assignee: Sarah Chen                       │
├────────────────────────────────────────────────────┤
│ [Assign to me]                                     │
│                                                    │
│ Or select another user:                            │
│ ┌─ Search users... ────────────────────────────┐   │
│ │                                              │   │
│ │  Priya Mehta   5 open  [1 URGENT] [1 HIGH] ○│   │
│ │  James Park    8 open  [0 URGENT] [3 HIGH] ○│   │
│ │  Sarah Chen   12 open  [2 URGENT] [4 HIGH] ●│ ← current assignee pre-selected
│ │  ...                                         │   │
│ └──────────────────────────────────────────────┘   │
│                                                    │
│                          [Cancel]  [Assign]        │
└────────────────────────────────────────────────────┘
```

**Form header** shows: reference number, subject (truncated), status badge, priority badge, current assignee name (or "Unassigned").

**Assign to me** button — prominent link/button above the user list. Clicking it executes the assignment immediately and closes the form. Hidden if the logged-in user is already the current assignee.

**User list:**
- All active Appian users, flat list
- Default sort: lowest open case count first (ties broken alphabetically)
- User can re-sort by clicking column headers: Name (A–Z) or Open Cases
- Searchable by name (live filter as user types)
- Each row: name · total open cases · URGENT count badge (red) · HIGH count badge (amber) · radio button
- Current assignee row is pre-selected; all others unselected
- Workload counts reflect cases currently assigned and not RESOLVED/CLOSED

**Assign button** — disabled until a radio selection differs from the current assignee. Clicking executes immediately (no confirmation dialog) and returns user to the case workspace.

**Unassign** — not in this form. Handled by a separate "✕" control next to the assignee name in the case workspace header.

### Process flow

```
User clicks Assign (or Assign to me)
  → IQH_ProcessModel_AssignCase
      ├── Validate: case must be in OPEN, IN_PROGRESS, or PENDING
      ├── Update Case.assigned_to
      ├── If Case.status is OPEN → set status to IN_PROGRESS (attributed to IQH_SystemUser in audit)
      ├── Write field audit record for assigned_to change
      └── Send Appian notification to newly assigned user

User clicks Unassign (✕ in case workspace header)
  → IQH_ProcessModel_AssignCase
      ├── Set Case.assigned_to = null
      ├── Write field audit record (new_value = null)
      └── No notification sent
```

### Notification

Appian native notification sent to the newly assigned user:
- Title: `Case assigned to you: {reference_number}`
- Body: `{subject} — assigned by {actor_name}`
- Links to the case workspace.

No notification is sent on unassign.

### Audit

Assignment changes are recorded by the universal field audit system. See [[field-audit]]. Fields captured: `case_id`, `field = "assigned_to"`, `old_value`, `new_value`, `changed_by`, `changed_at`.

## Appian objects

- `IQH_Record_Case` — record with views: List, Detail, My Queue
- `IQH_Interface_CaseWorkspace`
- `IQH_Interface_CaseList`
- `IQH_Action_AssignCase` — assign or unassign a case; includes self-assign shortcut
- `IQH_ProcessModel_AssignCase`
- `IQH_Action_ChangeStatus`
- `IQH_Action_AddNote`
- `IQH_Record_CaseNote`

## Acceptance criteria

- [ ] Case worker sees only their cases + unassigned; managers see all
- [ ] Case list sortable and filterable by status, priority, category, date
- [ ] Full email thread displayed in chronological order within a case
- [ ] AI summary displayed on case workspace
- [ ] All status transitions available from the workspace
- [ ] Internal notes are saved and visible only to internal users
- [ ] Priority and category are overridable by the case worker
- [ ] Any user (CW or manager) can assign a case to any active user
- [ ] Assignment form opens as a standalone Appian action, not a modal
- [ ] Form header shows case reference, subject, status, priority, and current assignee
- [ ] User list sorted by lowest open case count first; re-sortable by name or count
- [ ] User list is searchable by name (live filter)
- [ ] Each user row shows: name, total open cases, URGENT count (red), HIGH count (amber)
- [ ] Current assignee is pre-selected in the radio list
- [ ] Assign button is disabled until a selection different from current assignee is made
- [ ] "Assign to me" shortcut executes immediately and is hidden if user is already assignee
- [ ] Assign executes immediately — no confirmation dialog
- [ ] Cases can be unassigned via a separate ✕ control in the case workspace header
- [ ] Assigning an OPEN case automatically moves it to IN_PROGRESS (system actor in audit)
- [ ] Assignee receives an Appian notification on assignment (not on unassign)
- [ ] Assignment changes are written to the field audit log (see [[field-audit]])
- [ ] `resolved_at` is set when status moves to `RESOLVED`

## Open questions

- Auto-close: how many days after `RESOLVED` should a case auto-close?
- Should notes support @mentions or attachments?
- Should there be a "watch" feature so non-assignees can follow a case?
