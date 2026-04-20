---
status: planned
related:
  - case-management.md
data_model:
  - FieldAuditLog
---

# Field-Level Auditing

## Intent

As an IR manager or admin, I want every change to key fields on core records to be captured in an immutable audit log — so that we have a full history of who changed what and when, without relying on individual features to implement their own logging.

## Scope

> To be specced in detail. The following is a placeholder.

All writes to tracked fields across core entities should produce a `FieldAuditLog` entry. Initial tracked fields (to be confirmed):

| Entity | Fields |
|---|---|
| Case | `assigned_to`, `status`, `priority`, `category_id` |
| CaseTask | `status`, `assigned_user_id`, `assigned_team_id` |

## Provisional data model

```
FieldAuditLog
  ├── id
  ├── entity_type (e.g. "Case", "CaseTask")
  ├── entity_id
  ├── field_name
  ├── old_value (text)
  ├── new_value (text)
  ├── changed_by (FK → User)
  └── changed_at (timestamp)
```

## Open questions

- Which entities and fields should be tracked? (needs full list from client)
- Should audit log be viewable from within the case workspace, or only via an admin/audit screen?
- Retention policy — how long are audit records kept?
- ~~Should process-driven changes (e.g. auto-status on assignment) be attributed to the triggering user or a system actor?~~ **Decided: system actor.** A dedicated system user (e.g. `IQH_SystemUser`) is the `changed_by` for any field change made by a process model rather than a direct user action.
