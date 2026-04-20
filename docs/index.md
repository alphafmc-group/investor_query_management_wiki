# Wiki Index

Central index of all pages. Updated on every session. Read this first when navigating the wiki.

---

## Architecture

| Page | Description |
|---|---|
| [system-design](system-design.md) | Component diagram, tech stack, integrations, security model |
| [[system-design]] | Component diagram, tech stack, integrations, security model |
| [[data-model]] | Full ERD — all entities, fields, and relationships |

---

## Features

| Page | Status | Description |
|---|---|---|
| [email-polling](email-polling.md) | planned | MS Graph mailbox polling and email ingest pipeline |
| [[case-creation]] | planned | Auto-create or attach cases from inbound emails, threading logic |
| [[case-management]] | planned | Case workspace: view, assign, status changes, notes, resolve |
| [[task-management]] | planned | Create and track tasks against a case, team queues |
| [[email-reply]] | planned | Compose and send replies to investors from within a case |
| [[ai-classification]] | planned | LLM auto-assign priority and category on case creation |
| [[ai-ddq-agent]] | planned | DDQ Agent response suggestions with source citation in reply panel |
| [[auto-assignment]] | planned | Auto-assign cases via LP/RM mapping and category→team routing |
| [[semantic-search]] | planned | Appian semantic search across cases, emails, and notes |
| [[manager-dashboard]] | planned | Workload, SLA, volume, and AI accuracy reporting for managers |
| [[admin-screen]] | planned | Category, team, mailbox, and system settings configuration |
| [[field-audit]] | planned | Universal field-level audit log for changes to core record fields |
| [[investor-profile]] | planned | Investor entity profiles — cases per investor, contacts, multi-RM, link-investor action |

---

## Key cross-references

- **Email thread** → Case: [[email-polling]] → [[case-creation]] → [[case-management]]
- **Reply flow**: [[case-management]] → [[email-reply]] → [[ai-ddq-agent]]
- **AI pipeline**: [[case-creation]] → [[ai-classification]], [[email-reply]] → [[ai-ddq-agent]]
- **Manager view**: [[case-management]] + [[task-management]] + [[ai-classification]] → [[manager-dashboard]]
- **Config**: [[email-polling]] + [[ai-classification]] + [[manager-dashboard]] → [[admin-screen]]

---

## Open questions (cross-feature)

- SLA targets: not yet defined. Blocked on client input. Will be set in [[admin-screen]] and consumed by [[manager-dashboard]].
- Auto-close days: not yet defined. Same dependency.
- ~~Attachment handling: not addressed in any feature.~~ **Resolved**: stored as Appian documents via `EmailAttachment` records; inline images flagged separately. See [[email-polling]].
- Outbound email storage: should sent replies be stored as `Email` records? Suggested yes — needs confirmation.

---

## Research / Competitor analysis

| Page | Description |
|---|---|
| [[research/competitor-analysis-slides]] | Marp slide deck — competitor analysis summary, gap analysis, recommendations |
| [[research/competitor-zendesk]] | Zendesk — feature inventory, gap analysis, and inspiration |
| [[research/competitor-front]] | Front — feature inventory, gap analysis, and inspiration |
| [[research/competitor-freshdesk]] | Freshdesk — feature inventory, gap analysis, and inspiration |
| [[research/competitor-helpscout]] | Help Scout — feature inventory, gap analysis, and inspiration |

---

## Build log

See [[log]] for session history.
