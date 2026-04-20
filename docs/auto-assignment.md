---
title: Auto Case Assignment
status: planned
priority: high
depends_on:
  - case-creation.md
  - ai-classification.md
  - admin-screen.md
  - case-management.md
last_updated: 2026-04-16
---

# Auto Case Assignment

## Intent

As an IR manager, I want new cases to be automatically assigned to the right case worker based on investor relationships and case category — so that the team's workload is distributed without manual triage on every case.

## Scope

**Included:**
- Automatic assignment triggered immediately after AI classification on every new case
- Three-rule priority chain: LP/RM relationship → Category→Team load balancing → unassigned fallback
- Per-user availability flag and capacity cap (configurable per user; global default via constant)
- `InvestorContact` reference table: LP email → relationship manager, managed in-app
- CSV import to populate `InvestorContact` from an external CRM export
- Category → default team mapping (extends Category entity and admin screen)
- Global enable/disable switch via admin screen constant
- Manual override always available — any case worker or manager can reassign at any time

**Excluded (v1):**
- Task auto-assignment (cases only)
- Real-time CRM API sync (v1 = CSV import only)
- Continuity routing (returning sender → previous handler) — TBD, deferred
- Skill-based routing beyond category/team mapping
- Multi-RM per investor

---

## Assignment rule priority

The process model evaluates rules in strict order. First match wins.

| Priority | Rule | Assigns to |
|---|---|---|
| 1 | **LP relationship match** | Relationship manager for that investor email |
| 2 | **Category → Team routing** | Lowest-load eligible member of the category's default team |
| 3 | **Fallback** | Unassigned — manager alert sent |

---

## Rule definitions

### Rule 1 — LP relationship match

> ⚠ Updated for [[investor-profile]]: RM is no longer held on `InvestorContact`. RMs are now on the `InvestorEntityRM` join table. The match key (`InvestorContact.email_address`) is unchanged.

1. Query `InvestorContact` WHERE `email_address = Case.from_email` AND `is_active = true`
2. If match found, get `entity_id` and query `InvestorEntityRM` WHERE `entity_id = X`:
   - Try **primary RM** first (`is_primary = true`)
   - If primary is ineligible (unavailable or over capacity), try **secondary RMs** in order of lowest open case count
3. For each candidate RM, check eligibility:
   - `UserConfig.is_available = true`
   - Open case count < `UserConfig.capacity_max`
4. **First eligible RM found** → assign. Set `Case.auto_assignment_reason = LP_RELATIONSHIP`.
5. **All RMs ineligible** (or entity has no RMs) → fall through to Rule 2. Do not block.

### Rule 2 — Category → Team routing

1. Get `Category.default_team_id` for the case's category.
2. If `default_team_id` is null → fall through to fallback.
3. Get all active team members (via `TeamMember`).
4. Filter: `UserConfig.is_available = true` AND `open_case_count < UserConfig.capacity_max`.
5. Sort filtered members by open case count ASC (ties broken alphabetically by name).
6. **If eligible members exist** → assign to first (lowest load). Set `Case.auto_assignment_reason = CATEGORY_ROUTING`.
7. **If no eligible members** → fall through to fallback.

### Rule 3 — Fallback

- Case remains `OPEN` and unassigned (`Case.assigned_to = null`).
- `Case.auto_assigned = false`.
- `Case.auto_assignment_reason = FALLBACK_UNASSIGNED`.
- Appian notification sent to all users in `IQH_Group_Managers`: *"Case {ref} could not be auto-assigned — no eligible workers available."*
- Reason written to `FieldAuditLog`.

---

## Data model additions

### InvestorContact, InvestorEntity, InvestorEntityRM

> These entities are now fully specified in [[investor-profile]], which introduced `InvestorEntity` and `InvestorEntityRM` and refactored `InvestorContact`. The match key for Rule 1 (`InvestorContact.email_address`) is unchanged.

Summary of what Rule 1 uses:
- `InvestorContact.email_address` — match key (unchanged)
- `InvestorContact.entity_id` → `InvestorEntityRM` → candidate RMs (replaces `assigned_user_id`)

### New entity: UserConfig

Extends the native Appian User with app-specific assignment attributes. One record per user; created on demand (absent = use defaults).

| Field | Type | Notes |
|---|---|---|
| user_id | int | FK → User (unique) |
| is_available | bool | If false, user is excluded from auto-assign. Default: true. |
| capacity_max | int | Max open cases before excluded. Default: `IQH_Constant_CapacityDefaultMax`. |

### Modified entity: Category

Add one field:

| Field | Type | Notes |
|---|---|---|
| default_team_id | int | FK → Team — nullable. Team to route cases of this category to. |

### Modified entity: Case

Add two fields:

| Field | Type | Notes |
|---|---|---|
| auto_assigned | bool | True if assigned by process model; false if manually assigned. Default false. |
| auto_assignment_reason | string | `LP_RELATIONSHIP` \| `CATEGORY_ROUTING` \| `FALLBACK_UNASSIGNED` \| null (if manually assigned at creation) |

---

## Process flow

```
New case created → IQH_ProcessModel_ClassifyCase completes
  → IQH_ProcessModel_AutoAssignCase (chained)

  ├── Check IQH_Constant_AutoAssignEnabled
  │   └── If false → skip all rules, case remains unassigned → END
  │
  ├── Rule 1: InvestorContact match
  │   ├── Query InvestorContact on Case.from_email (is_active = true)
  │   ├── No match → skip to Rule 2
  │   ├── Match found → get entity_id → query InvestorEntityRM for entity
  │   ├── No RMs on entity → skip to Rule 2
  │   ├── Try primary RM (is_primary = true) first, then secondary RMs by open_case_count ASC
  │   ├── For each candidate: check is_available AND open_case_count < capacity_max
  │   ├── Eligible RM found:
  │   │   ├── Case.assigned_to = RM user ID
  │   │   ├── Case.auto_assigned = true
  │   │   ├── Case.auto_assignment_reason = LP_RELATIONSHIP
  │   │   ├── Case.status OPEN → IN_PROGRESS (system actor)
  │   │   ├── Write FieldAuditLog (changed_by = IQH_SystemUser)
  │   │   ├── Send Appian notification to RM
  │   │   └── END
  │   └── All RMs ineligible → fall through to Rule 2
  │
  ├── Rule 2: Category → Team routing
  │   ├── Get Category.default_team_id
  │   ├── Null → skip to Fallback
  │   ├── Get TeamMember list for team
  │   ├── Filter: is_available = true AND open_case_count < capacity_max
  │   ├── No eligible members → skip to Fallback
  │   ├── Sort by open_case_count ASC, then name ASC
  │   ├── Assign to first member:
  │   │   ├── Case.assigned_to = member user ID
  │   │   ├── Case.auto_assigned = true
  │   │   ├── Case.auto_assignment_reason = CATEGORY_ROUTING
  │   │   ├── Case.status OPEN → IN_PROGRESS (system actor)
  │   │   ├── Write FieldAuditLog
  │   │   ├── Send Appian notification to assignee
  │   │   └── END
  │
  └── Fallback
      ├── Case.assigned_to = null
      ├── Case.auto_assigned = false
      ├── Case.auto_assignment_reason = FALLBACK_UNASSIGNED
      ├── Write FieldAuditLog (reason = FALLBACK_UNASSIGNED, changed_by = IQH_SystemUser)
      └── Notify IQH_Group_Managers: "Case {ref} could not be auto-assigned"
```

---

## CRM import

### CSV format

```
email_address,entity_name,assigned_worker_username
j.smith@blackstone.com,Blackstone Group,priya.mehta
c.jones@kkr.com,KKR,james.park
```

Columns:
- `email_address` — required; must be valid email format
- `entity_name` — optional; LP firm name for display
- `assigned_worker_username` — required; must match an active Appian username

### Import process (`IQH_Action_ImportInvestorContacts`)

1. Admin uploads CSV file.
2. System parses and validates each row:
   - `assigned_worker_username` must exist in Appian and be active
   - `email_address` must be valid format
3. **Deduplication on `email_address`**: if a record for that email already exists, update it. Do not create duplicates.
4. Creates/updates `InvestorContact` records with `source = CRM_IMPORT`, `imported_at = now()`.
5. Returns an import report in-UI: N created · N updated · N failed — with row-level error detail for failures.

### Manual management

Admins can create, edit, and deactivate individual `InvestorContact` entries at any time from the admin screen. Manually created entries have `source = MANUAL`.

---

## Admin screen additions

See [[admin-screen]] for existing sections 1–5. Auto-assignment adds:

### Section 6 — LP / Relationship Manager Mappings

- Table: investor email, entity name, assigned RM, source, active status
- Actions per row: Edit, Deactivate
- Bulk action: Import CSV (opens upload modal → preview table → confirm)
- Import modal shows a preview of rows and any validation errors before committing

### Section 7 — Assignment Rules

**Category → Default Team** sub-section:
- Table of all active categories with an editable `Default Team` column (dropdown of teams)
- Inline save; clearing the team removes the mapping (category goes unrouted)

**User Capacity** sub-section:
- Table of all active users: name, `Available` toggle (yes/no), `Capacity Max` field (integer)
- Editing these writes to `UserConfig`
- Empty `Capacity Max` = use global default constant

### New system settings (Section 4 additions)

| Setting | Constant | Default |
|---|---|---|
| Auto-assign enabled | `IQH_Constant_AutoAssignEnabled` | true |
| Default capacity max (open cases) | `IQH_Constant_CapacityDefaultMax` | 20 |

---

## Appian objects

**Records:**
- `IQH_Record_InvestorContact`
- `IQH_Record_UserConfig`

**Process models:**
- `IQH_ProcessModel_AutoAssignCase` — 3-rule assignment logic; chained after `IQH_ProcessModel_ClassifyCase`

**Interfaces (admin):**
- `IQH_Interface_AdminInvestorContacts`
- `IQH_Interface_AdminAssignmentRules`

**Actions:**
- `IQH_Action_ImportInvestorContacts` — CSV upload, validation, and import
- `IQH_Action_CreateInvestorContact`
- `IQH_Action_EditInvestorContact`
- `IQH_Action_DeactivateInvestorContact`

**Constants:**
- `IQH_Constant_AutoAssignEnabled`
- `IQH_Constant_CapacityDefaultMax`

---

## Acceptance criteria

- [ ] Auto-assignment process model runs after AI classification on every new case when enabled
- [ ] Rule 1: case from a known investor email assigns to their RM if available and under capacity
- [ ] Rule 1: ineligible RM (unavailable or over capacity) falls through to Rule 2, not blocked
- [ ] Rule 2: case with a categorised default team assigns to the eligible team member with fewest open cases
- [ ] Rule 2: within-team tie on case count broken alphabetically by name
- [ ] Rule 3: case matching no rule remains unassigned; all managers receive an Appian notification
- [ ] All auto-assignments write to `FieldAuditLog` with `changed_by = null` (IQH_SystemUser)
- [ ] Auto-assigning an OPEN case automatically moves it to IN_PROGRESS (same audit rule as manual assign)
- [ ] `Case.auto_assigned` and `Case.auto_assignment_reason` are set on every new case
- [ ] Assignee receives an Appian notification on auto-assignment
- [ ] Manual reassignment always works — no restriction on overriding auto-assignment
- [ ] Auto-assignment can be disabled globally via admin screen (`IQH_Constant_AutoAssignEnabled`)
- [ ] `UserConfig.is_available` toggle is editable per-user in admin screen; false excludes from all rules
- [ ] `UserConfig.capacity_max` is editable per-user; empty = use global constant
- [ ] Category → default team mapping is configurable in admin screen (Section 7)
- [ ] `InvestorContact` records can be created, edited, and deactivated manually
- [ ] CSV import validates: email format, Appian username existence, required fields
- [ ] CSV import deduplicates on `email_address` — updates existing, does not create duplicates
- [ ] CSV import sets `source = CRM_IMPORT` and `imported_at` timestamp
- [ ] Import report shows row-level errors for failed rows

---

## Open questions

- **Continuity routing** — should cases from a returning sender route to whoever last handled that investor, independent of the RM mapping? Deferred.
- **Multi-RM** — can an investor have a primary and backup RM? Current model assumes one. If yes, Rule 1 would try primary first, then backup before falling through.
- **URGENT escalation** — should URGENT cases skip load balancing and route to a designated senior queue or manager, bypassing normal team routing?
- **Team chain fallback** — if the assigned team has no eligible members, should Rule 2 try other teams (e.g. a general queue team) before going unassigned?
- **Skipped-worker notification** — should a case worker who was bypassed due to capacity be notified that a case was routed past them?
- **`InvestorContact` entity name matching** — should matching extend beyond email to LP firm name (for cases where the sender email varies)? Currently email-only.
