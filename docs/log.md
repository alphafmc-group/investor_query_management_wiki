# Build Log

Append-only. One entry per session. Format: `## [YYYY-MM-DD] <type> | <feature> | <summary>`

Types: `build` | `design` | `ingest` | `query` | `lint` | `scaffold`

---

## [2026-04-15] scaffold | all-features | Initial wiki scaffold created — 10 feature pages, index, and log
## [2026-04-15] design | case-management | Specced IQH_Action_AssignCase — full form design: standalone action, workload list with priority breakdown, self-assign shortcut, pre-selected current assignee, immediate execution
## [2026-04-15] design | data-model | Created wiki/architecture/data-model.md — Mermaid ERD + field reference tables for all 11 entities
## [2026-04-15] design | system-design | Created wiki/architecture/system-design.md — component diagram, stack, integrations, security model
## [2026-04-15] ingest | raw/MySQL_DDLs.sql | Processed APP_MAIL_POLLER DDL — expanded Email entity (19 fields), added EmailAttachment entity, updated email-polling AC and field map
## [2026-04-15] ingest | raw/MySQL-AddOnScript_V4.3.0.sql | Processed v4.3.0 migration — added conversation_index to Email entity and field map
## [2026-04-16] design | manager-dashboard | Specced all 8 dashboard panels — chart types, Appian components, layout, filter scope, alert thresholds, and Excel export; updated feature page with build-ready detail
## [2026-04-16] research | competitor-analysis | Created 4 competitor pages (Zendesk, Front, Freshdesk, Help Scout) — feature inventories, gap analysis tables, and inspiration notes; updated index
## [2026-04-16] design | auto-assignment | New feature page — 3-rule priority chain (LP/RM → category/team → fallback), InvestorContact + UserConfig entities, CSV import, admin sections 6–7; data model and admin-screen updated
## [2026-04-16] design | investor-profile | New feature — InvestorEntity + InvestorEntityRM (multi-RM with primary flag), refactored InvestorContact (entity_id replaces assigned_user_id), Case FKs; investor resolution on creation; profile page with cases/contacts/RM tabs; updated data-model, auto-assignment Rule 1, case-creation, admin-screen section 6
