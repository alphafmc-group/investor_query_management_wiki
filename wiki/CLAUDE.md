# CLAUDE.md — Investor Query Hub

> Project constitution. Load this file at the start of every agent session.
> Feature pages live in `/wiki/features/`. Build log lives in `/wiki/log.md`.

---

## Wiki Maintenance Guide
@WIKI.md


## Project overview

A case management web application built on **Appian** for the IR (Investor Relations) team of a PE firm. The tool ingests investor emails from one or more monitored mailboxes via the **Microsoft Graph API**, converts them into structured cases, and supports the full lifecycle of tracking, assigning, responding to, and resolving investor queries.

**Primary users**
- IR Case Workers — manage and respond to cases
- IR Managers — oversee team workload and performance
- Admins — configure categories, teams, and system settings

---

## Technology stack

| Layer | Technology |
|---|---|
| Platform | Appian (cloud) |
| Data | Appian native records and process data |
| Email integration | Microsoft Graph API (mailbox polling) |
| Document/file context | SharePoint (via MS Graph) |
| Search | Appian Semantic Search |
| AI — classification | Appian OOTB LLM Connector (auto-prioritise & categorise) |
| AI — response suggestion | Appian AI Agent → DDQ API (suggest replies with source citation) |
| Reporting | Appian native dashboards and records |

---

## Data model (core entities)

```
Mailbox
  ├── id, email_address, display_name, is_active

Email (raw, immutable after ingest)
  ├── graph_message_id (unique)
  ├── graph_conversation_id  ← thread key
  ├── mailbox_id (FK)
  ├── sender, recipients, subject, body_html, received_at
  └── direction: INBOUND | OUTBOUND

Case
  ├── id, reference_number (e.g. IQ-2026-00142)
  ├── conversation_id  ← groups all emails in thread
  ├── subject, status: OPEN | IN_PROGRESS | PENDING | RESOLVED | CLOSED
  ├── priority: LOW | MEDIUM | HIGH | URGENT  ← LLM-assigned, overridable
  ├── category_id (FK → Category)
  ├── assigned_to (FK → User)
  ├── created_at, resolved_at
  └── ai_summary (LLM-generated on ingest)

CaseEmail (join — emails linked to a case, ordered by received_at)

CaseTask
  ├── id, case_id (FK), title, description
  ├── assigned_team_id (FK → Team), assigned_user_id (FK → User)
  ├── status: TODO | IN_PROGRESS | DONE
  └── due_date, completed_at

CaseNote (internal notes, not sent to investor)

Category
  ├── id, name, description, is_active
  └── managed via Admin screen

Team
  └── id, name, members (FK → User[])

User (Appian native)
```

**Threading rule:** All emails sharing the same `graph_conversation_id` belong to the same Case. On ingest, if a conversation ID already exists, attach to the existing case. If new, create a new case.

---

## Feature scope

Features are documented individually in `/wiki/features/`. This is the canonical list:

| Feature file | Description | Status |
|---|---|---|
| `email-polling.md` | MS Graph mailbox polling, ingest pipeline | planned |
| `case-creation.md` | Auto-create cases from inbound emails, threading | planned |
| `case-management.md` | View, assign, status change, resolve cases | planned |
| `task-management.md` | Create/assign tasks against a case | planned |
| `email-reply.md` | Reply to investor from within a case | planned |
| `ai-classification.md` | LLM auto-priority and category assignment | planned |
| `ai-ddq-agent.md` | AI Agent DDQ response suggestions with source | planned |
| `semantic-search.md` | Appian semantic search across cases | planned |
| `manager-dashboard.md` | Workload, SLA, volume, and trend reporting | planned |
| `admin-screen.md` | Category management, team/mailbox config | planned |

---

## Appian conventions

- **Naming:** All Appian objects prefixed with `IQH_` (e.g. `IQH_Case`, `IQH_ProcessModel_IngestEmail`)
- **Process models:** One process model per major workflow (ingest, reply, escalate). No monolithic processes.
- **Records:** Each core entity has an Appian Record with views defined. Use record-level security.
- **Interfaces:** Sites-based UI. One site, multiple pages. Use SAIL components only — no custom HTML injection unless explicitly required.
- **Constants:** All config values (polling interval, mailbox IDs, LLM model name) stored as Appian constants, not hardcoded.
- **Error handling:** All MS Graph API calls wrapped in try/catch with errors logged to a `IQH_ErrorLog` record.
- **Security:** Row-level security on Case records. Case workers see only assigned or unassigned cases in their queue. Managers see all.

---

## MS Graph API conventions

- Auth: OAuth 2.0 client credentials flow. Token stored as Appian connected system.
- Polling: Use `/v1.0/users/{mailbox}/messages?$filter=isRead eq false` — mark as read after ingest.
- Threading: Use `conversationId` field on message object as the canonical thread key.
- Replies: Send via `/v1.0/users/{mailbox}/messages/{id}/reply` to preserve thread.
- Always store raw `id` (Graph message ID) and `conversationId` on every Email record.

---

## AI / LLM conventions

**Auto-classification (Appian LLM Connector)**
- Triggered on case creation.
- Prompt receives: email subject, body (truncated to 1500 chars), and list of active Category names + descriptions.
- Returns: `priority` (LOW/MEDIUM/HIGH/URGENT) and `category_id`.
- LLM result is applied automatically but is always overridable by the case worker.
- Store `ai_classification_confidence` for audit.

**DDQ Agent (response suggestions)**
- Triggered from the Reply action on a case.
- Agent calls the DDQ API with the investor query as input.
- Response must include: suggested reply text + `source` (document name, section, or URL from DDQ API response).
- Display suggestion and source inline in the reply panel — worker edits before sending.
- Never send an AI-generated reply without human review and explicit send action.

---

## Manager dashboard — agreed metrics

The following are the confirmed panels for the manager dashboard (`manager-dashboard.md`):

- **Open case volume** — total open cases by status
- **Cases by category** — breakdown of case types
- **Workload by assignee** — open cases per case worker
- **SLA compliance** — % cases responded to within target (TBD: define SLA targets)
- **Average resolution time** — rolling 30-day trend
- **New cases this week** — vs prior week
- **Unassigned cases** — count and list, highlighted if > threshold
- **AI classification accuracy** — % of AI-assigned categories confirmed vs overridden

> SLA targets TBD — to be defined with client and added to `admin-screen.md`.

---

## Agent context loading instructions

When starting work on any feature, load:
1. **This file** (`CLAUDE.md`) — always
2. The relevant **feature `.md`** from `/wiki/features/`
3. Any **directly related** existing Appian object definitions

Do not load all feature files at once. One feature per session.

After completing work, append a one-line entry to `/wiki/log.md`:
```
## [YYYY-MM-DD] build | <feature-name> | <brief summary of what was done>
```

---

## Out of scope (v1)

- Investor portal (self-service)
- SMS / phone channel
- Multi-language support
- Mobile app