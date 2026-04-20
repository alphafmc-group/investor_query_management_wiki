---
title: Investor Profile
status: planned
priority: high
depends_on:
  - case-creation.md
  - auto-assignment.md
  - admin-screen.md
last_updated: 2026-04-16
---

# Investor Profile

## Intent

As an IR case worker or manager, I want to view a profile page for each investor entity that shows all their cases, contacts, and relationship managers — so that I can understand the full history and context of any LP relationship in one place.

## Scope

**Included:**
- `InvestorEntity` as a first-class record (LP firm / fund entity)
- `InvestorEntityRM` join table supporting multiple RMs per entity, with a primary flag
- Refactored `InvestorContact` — now represents an individual at the firm, linked to an entity
- FK links on `Case` to `InvestorEntity` and `InvestorContact`, resolved automatically on case creation
- Investor profile page: header, summary metrics, contacts tab, cases tab, RM tab
- "Link investor" action on cases where sender email was not matched on ingest
- Investor management in admin screen (CRUD for entities, contacts, RM assignments)
- CSV import updated to support the new entity/contact/RM structure

**Excluded (v1):**
- Commitment amount, AUM, fund/vintage membership
- Geographic region or domicile
- KYC/AML status
- Investor self-service portal

---

## Data model

### New entity: InvestorEntity

The LP firm or fund entity — the top-level investor object.

| Field | Type | Notes |
|---|---|---|
| id | int | PK |
| name | string | Entity name (LP firm / fund name) |
| type | string | `PENSION_FUND` `FAMILY_OFFICE` `ENDOWMENT` `SOVEREIGN_WEALTH` `FUND_OF_FUNDS` `INSURANCE` `OTHER` |
| is_active | bool | Inactive entities excluded from auto-assign lookup and case filters |
| notes | string | Internal free-text notes; not visible to investors |
| created_at | datetime | |
| updated_at | datetime | |

### New entity: InvestorEntityRM

Maps relationship managers to an investor entity. Supports multiple RMs with a primary designation.

| Field | Type | Notes |
|---|---|---|
| id | int | PK |
| entity_id | int | FK → InvestorEntity |
| user_id | int | FK → User — the RM |
| is_primary | bool | True for the primary RM. Only one record per entity may have `is_primary = true` — enforced in app logic. |
| created_at | datetime | |

### Refactored entity: InvestorContact

Now represents an individual person at an LP firm, linked to their entity.

> ⚠ Breaking change from [[auto-assignment]]: `assigned_user_id` is removed from this entity — RM is now held at entity level via `InvestorEntityRM`. See [[auto-assignment]] for updated Rule 1 logic.

| Field | Type | Notes |
|---|---|---|
| id | int | PK |
| entity_id | int | FK → InvestorEntity |
| email_address | string | Individual's email — exact-match key used during ingest resolution and auto-assign |
| full_name | string | Display name |
| title | string | Job title (e.g. CFO, Finance Director) — optional |
| is_primary | bool | True = primary contact for this entity (one per entity, by convention; not enforced) |
| is_active | bool | Inactive contacts excluded from ingest resolution and auto-assign |
| source | string | `MANUAL` or `CRM_IMPORT` |
| imported_at | datetime | Set on CRM import; null if manually created |
| created_at | datetime | |
| updated_at | datetime | |

### Modified entity: Case

Two new nullable fields. Null = sender was not matched to a known investor on ingest.

| Field | Type | Notes |
|---|---|---|
| investor_entity_id | int | FK → InvestorEntity — nullable |
| investor_contact_id | int | FK → InvestorContact — nullable |

---

## Investor resolution on case creation

Immediately after the `Case` record is created (before AI classification):

```
Email ingested → IQH_ProcessModel_CreateOrAttachCase
  ├── [Existing] Thread match / new case logic
  └── [New — on new case only] Investor resolution
        ├── Query InvestorContact WHERE email_address = Email.from_email AND is_active = true
        ├── Match found:
        │     ├── Case.investor_contact_id = InvestorContact.id
        │     ├── Case.investor_entity_id  = InvestorContact.entity_id
        │     └── Continue to AI classification → auto-assignment
        └── No match:
              ├── Case.investor_contact_id = null
              ├── Case.investor_entity_id  = null
              └── Case workspace shows "Link investor" banner (see below)
```

Resolution is a lookup step only — it does not block case creation or AI classification.

---

## Unknown sender: "Link investor" action

When `Case.investor_entity_id` is null, the case workspace shows a dismissible banner:

> *"Sender not recognised as a known investor. [Link investor]"*

**`IQH_Action_LinkCaseToInvestor`:**
1. Opens a modal with a search field — search existing `InvestorEntity` by name, or existing `InvestorContact` by email.
2. **Match found:** select to link — sets `Case.investor_contact_id` and `Case.investor_entity_id`.
3. **No match:** option to create a new `InvestorContact` (and optionally a new `InvestorEntity`) inline.
4. On save: FKs written, `FieldAuditLog` entry created, banner dismissed.
5. Case worker can also dismiss without linking — banner does not reappear for that case.

---

## Investor profile page

**Record:** `IQH_Record_InvestorEntity`

**Access:** All authenticated users can view. Editing restricted to admins (entity/contact management) and managers (RM assignments).

### Header

- Entity name, type badge (e.g. `FAMILY_OFFICE`), active/inactive indicator
- Primary RM name (link to user profile) + count of secondary RMs
- Quick action: Edit (admin only)

### Summary strip

Computed metrics displayed prominently below the header:

| Metric | Definition |
|---|---|
| Total cases | COUNT of all `Case` WHERE `investor_entity_id = this entity` |
| Open cases | COUNT WHERE `status IN (OPEN, IN_PROGRESS, PENDING)` |
| Avg resolution time | AVG(`resolved_at − created_at`) for RESOLVED/CLOSED cases, rolling 30 days |
| Last case date | MAX(`Case.created_at`) |

### Contacts tab

- Table of all `InvestorContact` records for this entity
- Columns: full name, email, title, primary flag, active status, source
- Actions (admin): Add contact, Edit, Deactivate

### Cases tab

- Paginated list of all cases linked to this entity via `Case.investor_entity_id`
- Columns: reference number, subject, status badge, category, assignee, created date
- Filters: status multi-select, date range, category
- Clicking a row navigates to the case workspace

### Relationship Managers tab

- Table of `InvestorEntityRM` records for this entity
- Columns: user name, primary indicator (star), added date
- Actions (manager/admin): Add RM, Set as primary, Remove

---

## Appian objects

**Records:**
- `IQH_Record_InvestorEntity`
- `IQH_Record_InvestorContact` *(refactored — `entity_id` replaces `assigned_user_id`)*
- `IQH_Record_InvestorEntityRM`

**Interfaces:**
- `IQH_Interface_InvestorProfile` — top-level profile page (header + tabs)
- `IQH_Interface_InvestorCaseList` — cases tab component (reusable)
- `IQH_Interface_InvestorContacts` — contacts tab component
- `IQH_Interface_InvestorRMs` — RM tab component

**Actions:**
- `IQH_Action_CreateInvestorEntity`
- `IQH_Action_EditInvestorEntity`
- `IQH_Action_DeactivateInvestorEntity`
- `IQH_Action_AddInvestorContact`
- `IQH_Action_EditInvestorContact`
- `IQH_Action_DeactivateInvestorContact`
- `IQH_Action_LinkCaseToInvestor`
- `IQH_Action_ManageInvestorRMs`

**Process model additions:**
- `IQH_ProcessModel_CreateOrAttachCase` — investor resolution step added (new case only)

---

## CSV import (updated)

The import previously mapped one email to one RM. The updated format supports the entity/contact/RM structure.

### New CSV format

```
email_address,full_name,title,is_primary_contact,entity_name,entity_type,primary_rm_username
j.smith@blackstone.com,Jane Smith,CFO,true,Blackstone Group,FAMILY_OFFICE,priya.mehta
c.jones@blackstone.com,Charles Jones,Finance Director,false,Blackstone Group,FAMILY_OFFICE,priya.mehta
c.jones@kkr.com,Chris Jones,Managing Director,true,KKR,PENSION_FUND,james.park
```

**Import logic (`IQH_Action_ImportInvestorContacts`):**

1. For each row, look up `InvestorEntity` by `entity_name` (case-insensitive):
   - **Match:** use existing entity
   - **No match:** create new `InvestorEntity` with provided name and type
2. Upsert `InvestorContact` on `email_address`:
   - **Existing:** update name, title, entity_id, is_primary, imported_at
   - **New:** create with `source = CRM_IMPORT`
3. If `primary_rm_username` provided, upsert `InvestorEntityRM`:
   - Set `is_primary = true` for this RM; demote any existing primary to `is_primary = false`
4. Validation (row fails if any violation):
   - `email_address` — valid email format; required
   - `entity_name` — required
   - `entity_type` — must be a valid enum value if provided; defaults to `OTHER` if omitted
   - `primary_rm_username` — must match an active Appian user if provided
5. Import report: N entities created · N entities matched · N contacts created · N contacts updated · N RM mappings set · N rows failed (with row-level error detail)

---

## Dependencies

- [[case-creation]] — investor resolution step added to the case creation flow
- [[auto-assignment]] — Rule 1 updated to use `InvestorEntityRM`; see that page for revised logic
- [[admin-screen]] — section 6 replaced by expanded Investor Management section

---

## Acceptance criteria

- [ ] `InvestorEntity` records can be created, edited, and deactivated from the admin screen
- [ ] `InvestorContact` records are linked to an entity; multiple contacts per entity supported
- [ ] An entity can have multiple RMs; exactly one may be flagged as primary (enforced in app logic)
- [ ] On new case creation, sender email is matched against active `InvestorContact` records and FKs resolved automatically
- [ ] Cases with an unrecognised sender display a "Link investor" banner in the case workspace
- [ ] "Link investor" action: case worker can search, select, and link an entity (or create one inline)
- [ ] "Link investor" action: case worker can dismiss without linking — banner does not reappear
- [ ] Investor profile page displays header, summary strip, and Contacts / Cases / RMs tabs
- [ ] Summary strip metrics (total cases, open cases, avg resolution, last case date) are computed correctly
- [ ] Cases tab lists all cases for the entity with working filters (status, date range, category)
- [ ] RM tab allows managers/admins to add, set primary, and remove RMs
- [ ] CSV import: creates/matches entities, upserts contacts, sets RM mappings
- [ ] CSV import: returns row-level error report; invalid rows are skipped without aborting the import
- [ ] All investor link/edit actions write to `FieldAuditLog`
- [ ] Investor name on case workspace is a clickable link to the investor profile page

---

## Open questions

- Should unknown-sender cases surface as a dedicated filter or alert in [[manager-dashboard]]?
- Should an entity with all-inactive contacts still appear in search results during "Link investor"?
- Should the profile page be accessible from a top-level navigation item, or only via links from cases?
