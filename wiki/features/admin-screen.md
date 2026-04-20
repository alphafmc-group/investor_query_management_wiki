---
status: planned
related:
  - email-polling.md
  - ai-classification.md
  - manager-dashboard.md
  - auto-assignment.md
data_model:
  - Category
  - Team
  - Mailbox
  - User
  - InvestorEntity
  - InvestorContact
  - InvestorEntityRM
  - UserConfig
---

# Admin Screen

## Intent

As an admin, I want a configuration screen to manage categories, teams, mailboxes, and system settings — so the IR Hub can be configured without requiring developer intervention.

## Sections

### 1. Category management
- List of all `Category` records (name, description, active/inactive).
- Actions: Create, Edit, Deactivate (soft delete — categories in use cannot be hard-deleted).
- Deactivated categories are excluded from AI classification prompts and case filters.

### 2. Team management
- List of `Team` records with member lists.
- Actions: Create team, Edit name, Add/remove members.
- Members are selected from Appian user list.

### 3. Mailbox configuration
- List of `Mailbox` records (email address, display name, active/inactive).
- Actions: Add mailbox, Edit display name, Activate/deactivate.
- Deactivated mailboxes are skipped during polling.
- Connected system (`IQH_CS_MicrosoftGraph`) configured separately by an Appian admin.

### 4. System settings (constants UI)
Configuration values surfaced as editable fields (backed by Appian constants):

| Setting | Constant | Default |
|---|---|---|
| Polling interval (minutes) | `IQH_Constant_PollingIntervalMinutes` | 5 |
| Unassigned case alert threshold | `IQH_Constant_UnassignedAlertThreshold` | 10 |
| SLA target (hours) | `IQH_Constant_SLATargetHours` | TBD |
| AI confidence threshold | `IQH_Constant_ClassificationConfidenceThreshold` | 0.7 |
| Auto-close after resolved (days) | `IQH_Constant_AutoCloseDays` | TBD |
| Email signature (HTML) | `IQH_Constant_EmailSignatureHtml` | (template) |
| Auto-assign enabled | `IQH_Constant_AutoAssignEnabled` | true |
| Default capacity max (open cases) | `IQH_Constant_CapacityDefaultMax` | 20 |

### 6. Investor Management
*(See [[investor-profile]] for full spec)*

Replaces the old LP/RM Mappings section. Manages `InvestorEntity`, `InvestorContact`, and `InvestorEntityRM` records.

**Entities sub-section:**
- Table of `InvestorEntity` records: name, type, primary RM, contact count, active status.
- Actions per row: Edit, Deactivate, View profile (links to investor profile page).
- Create new entity button.

**Contacts sub-section:**
- Table of `InvestorContact` records: full name, email, title, entity name, primary contact flag, source, active status.
- Actions per row: Edit, Deactivate.
- **Import CSV** button — modal: upload → preview parsed rows with validation errors → confirm.
  - CSV format: `email_address, full_name, title, is_primary_contact, entity_name, entity_type, primary_rm_username`
  - Upserts on `email_address`; creates/matches entity by name; sets/updates primary RM on entity.
  - Import report: N entities created · N contacts created · N updated · N RM mappings set · N failed (row-level detail).

**RM Assignments sub-section:**
- Table: entity name, primary RM, secondary RMs (comma-separated), last updated.
- Inline edit to add/remove RMs or change primary designation.
- Changing primary: the previous primary is demoted to secondary automatically.

### 7. Assignment Rules
*(See [[auto-assignment]] for full spec)*

**Category → Default Team sub-section:**
- Table of all active categories with an editable `Default Team` dropdown column.
- Clearing the team removes the routing mapping for that category.

**User Capacity sub-section:**
- Table of all active users: name · Available toggle · Capacity Max field.
- Edits write to `UserConfig`. Empty `Capacity Max` = use global default constant.

### 5. User / role management
- View of all users and their roles (Case Worker, Manager, Admin).
- Role assignment delegated to Appian Group management — admin screen shows a read-only summary and links to Appian group config.

## Access control

Admin screen is accessible only to users in the `IQH_Group_Admins` Appian group.

## Appian objects

- `IQH_Interface_AdminScreen`
- `IQH_Interface_AdminCategories`
- `IQH_Interface_AdminTeams`
- `IQH_Interface_AdminMailboxes`
- `IQH_Interface_AdminSettings`
- `IQH_Action_CreateCategory`, `IQH_Action_EditCategory`, `IQH_Action_DeactivateCategory`
- `IQH_Action_CreateTeam`, `IQH_Action_EditTeam`
- `IQH_Action_AddMailbox`, `IQH_Action_EditMailbox`
- `IQH_Interface_AdminInvestorManagement` *(replaces `IQH_Interface_AdminInvestorContacts`)*
- `IQH_Interface_AdminAssignmentRules`
- `IQH_Action_ImportInvestorContacts`, `IQH_Action_CreateInvestorEntity`, `IQH_Action_EditInvestorEntity`, `IQH_Action_DeactivateInvestorEntity`
- `IQH_Action_AddInvestorContact`, `IQH_Action_EditInvestorContact`, `IQH_Action_DeactivateInvestorContact`
- `IQH_Action_ManageInvestorRMs`
- `IQH_Group_Admins`

## Acceptance criteria

- [ ] Admin screen accessible only to admin-role users
- [ ] Categories can be created, edited, and deactivated (not deleted if in use)
- [ ] Teams can be created and members added/removed
- [ ] Mailboxes can be added, edited, and activated/deactivated
- [ ] System settings are editable without a developer deploying a new constant
- [ ] Deactivated categories are excluded from AI classification prompts
- [ ] Deactivated mailboxes are skipped in polling
- [ ] All changes are logged (who changed what, when)

## Open questions

- SLA target and auto-close days: to be defined with client — values will be stored here once agreed.
- Should there be a full audit log view in the admin screen showing all configuration changes?
- Should email signature support per-mailbox overrides?
