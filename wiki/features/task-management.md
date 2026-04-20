---
status: planned
related:
  - case-management.md
  - manager-dashboard.md
data_model:
  - CaseTask
  - Team
  - User
---

# Task Management

## Intent

As an IR case worker or manager, I want to create discrete tasks against a case, assign them to a team or individual, and track their completion — so that multi-step queries are coordinated without anything falling through the cracks.

## Task model

```
CaseTask
  ├── id
  ├── case_id (FK → Case)
  ├── title
  ├── description
  ├── assigned_team_id (FK → Team)   ← optional
  ├── assigned_user_id (FK → User)   ← optional; set when team member picks up task
  ├── status: TODO | IN_PROGRESS | DONE
  ├── due_date
  └── completed_at
```

At least one of `assigned_team_id` or `assigned_user_id` must be set.

## Task lifecycle

```
TODO → IN_PROGRESS → DONE
```

- A task assignee (or any team member if assigned to a team) can move it through states.
- When all tasks on a case are `DONE`, the case worker is notified but the case is not auto-resolved (human decision required).

## UI placement

- Tasks appear as a section within the Case Workspace (see [[case-management]]).
- A case worker can also see all their tasks across cases from a "My Tasks" view.
- Tasks assigned to a team appear in a team queue visible to all team members.

## Appian objects

- `IQH_Record_CaseTask`
- `IQH_Interface_TaskList` (embedded in case workspace + standalone)
- `IQH_Action_CreateTask`
- `IQH_Action_UpdateTaskStatus`

## Acceptance criteria

- [ ] Tasks can be created from within a case workspace
- [ ] Task can be assigned to a team, a user, or both
- [ ] Status transitions: TODO → IN_PROGRESS → DONE
- [ ] Due dates are displayed; overdue tasks are visually flagged
- [ ] Case worker receives a notification when a task assigned to them is created or updated
- [ ] "My Tasks" view shows all open tasks assigned to the logged-in user, across all cases
- [ ] Team queue shows tasks assigned to the team, claimable by any team member
- [ ] `completed_at` is set when status moves to `DONE`

## Open questions

- Should tasks support sub-tasks or checklists?
- Should overdue tasks trigger an escalation notification to the manager?
- Is there a need for task templates (pre-defined task sets for common query types)?
