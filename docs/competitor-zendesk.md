---
title: Competitor Analysis — Zendesk
source_file: n/a (general knowledge)
ingested: 2026-04-16
type: research
touches: [case-management, email-reply, manager-dashboard, admin-screen, task-management]
---

# Competitor Analysis — Zendesk

## Product overview

Zendesk is the de-facto benchmark for email-based support case management. It converts inbound emails into numbered tickets, supports multi-channel ingest (email, chat, voice, social), and has a mature SLA, automation, and reporting stack. Its breadth makes it the reference point for "what does a mature ticketing system do?"

Closest analogue to IQH: Zendesk Support (email + ticket workflow only, not the full suite).

---

## Core email → case workflow

1. Inbound email arrives at a support address → Zendesk creates a ticket, assigns a ticket number, extracts sender details.
2. All subsequent emails in the same thread attach to the same ticket (matched by `In-Reply-To` / `References` email headers, not a custom conversation ID).
3. Agent views ticket in a workspace: email history, internal notes, sidebar metadata.
4. Agent replies from within the ticket — reply sent via Zendesk's outbound SMTP/API, stored on the ticket.
5. Ticket moves through statuses: **New → Open → Pending → On-hold → Solved → Closed**.
6. CSAT survey optionally sent to customer on solve.

---

## Feature inventory

### Routing and assignment
| Feature | Description |
|---|---|
| Skills-based routing | Route tickets to agents based on declared skills (e.g. language, product area) |
| Round-robin assignment | Automatically distribute tickets evenly across a group |
| Views and queues | Saved filtered ticket lists — each agent/team can have their own view |
| Group inboxes | Tickets assigned to a team group before individual assignment |

### Within-ticket tools
| Feature | Description |
|---|---|
| Macros | One-click templates that pre-fill a reply, set fields, and change status simultaneously |
| Side conversations | Start a private sub-thread (email, Slack, Teams) with a third party without the customer seeing |
| CC and followers | Stakeholders can watch a ticket and receive notifications without being the assignee |
| Ticket tags | Free-form labels applied alongside the structured category/priority fields |
| Ticket merging | Merge two tickets that turn out to be the same enquiry |
| Linked tickets | Reference related tickets without merging |
| Collision detection | Banner alert if another agent is currently viewing or composing a reply on the same ticket |
| Internal notes | Private comments visible only to agents, threaded with the ticket timeline |
| Time tracking (add-on) | Log time spent per ticket — available via app marketplace |

### SLA
| Feature | Description |
|---|---|
| SLA policies | Define first-reply-time and resolution-time targets, can vary by priority or ticket type |
| Business hours | SLA clock pauses outside defined working hours |
| SLA breach alerts | Real-time visual indicator (red/amber) on the ticket when breach is approaching or has occurred |
| SLA reporting | % tickets meeting SLA, breach counts, breakdowns by agent/group |

### Automations
| Feature | Description |
|---|---|
| Triggers | If-then rules that fire on ticket create or update (e.g. auto-assign by email subject keyword) |
| Automations | Time-based rules (e.g. send a follow-up if ticket is pending for 48 h) |
| Schedules | Business hour calendars used by SLA and automations |

### AI (Zendesk AI / previously Intelligent Triage)
| Feature | Description |
|---|---|
| Intent detection | Classifies the ticket intent from subject + body |
| Sentiment detection | Flags negative-sentiment tickets for priority attention |
| Suggested replies | Recommends a reply from the knowledge base or past tickets |
| Intelligent triage | Auto-suggests category, priority, and language |
| Summarisation | Generates a plain-language summary of a long ticket thread |
| Agent copilot | In-compose suggestions as the agent types |

### Reporting
| Feature | Description |
|---|---|
| Pre-built dashboards | Volume, CSAT, SLA compliance, agent performance — out of the box |
| Zendesk Explore | Custom report builder with drag-and-drop, scheduled exports |
| Team performance | Resolution time, first-reply time, ticket handled counts per agent |
| CSAT | Customer satisfaction scores per ticket and rolled up |

---

## Gap analysis

Features Zendesk has that are **not yet explicitly in the IQH spec**, with Appian replicability assessment.

| Feature | Gap severity | Appian replicable? | Notes |
|---|---|---|---|
| Collision detection | Medium | Yes | Show "X is currently viewing this case" banner via a lightweight process model or record subscription. Prevents duplicate replies. |
| Macros (reply templates) | High | Yes | Implement as a `CaseReplyTemplate` record — pre-canned reply text selectable in the reply panel. Very common IR need (fund update requests, standard NAV queries). |
| Side conversations | Medium | Yes | A separate email thread linked to a case but invisible to the investor. Useful when IR needs to loop in fund accounting or legal. Worth adding to email-reply spec. |
| CC / followers on a case | Low–Medium | Yes | A `CaseWatcher` join table. Sends notifications to stakeholders without making them the assignee. |
| SLA breach real-time alerts | High | Yes | A scheduled process model checks SLA deadlines and updates a `sla_breach_status` field; drives visual indicator on case record. Currently only in dashboard, not on individual case. |
| Business hours SLA | Medium | Yes | Store business hour schedule as constants or a `BusinessHourSchedule` record; adjust SLA calculation accordingly. |
| Ticket tags (free-form) | Low | Yes | A `CaseTag` join table alongside the structured `category_id`. Low priority given structured categories exist. |
| Ticket merging | Medium | Yes | Process model re-parents `CaseEmail` rows from one case to another, marks source case `MERGED`. Useful when same investor sends duplicate emails. |
| Time tracking | Low | Yes | A `CaseTimeLog` record — agents log effort. Useful for reporting on complex queries. Not a priority for v1. |
| Triggers / automations | Medium | Yes | Appian process models can implement most automation rules. Worth defining a small set of standard triggers (e.g. auto-assign by category). |
| CSAT survey | Low | Partially | Could send a survey email on close via Graph API. Out of scope for v1 but worth noting. |
| Summarisation of thread | High | Yes — already planned | IQH already plans `ai_summary` on case creation. Zendesk extends this to re-summarise after each update. Consider whether summary should refresh when new emails are added. |

---

## Inspiration — ideas to consider adopting

1. **Reply templates / macros** — IR teams send repetitive replies (NAV request, subscription doc request, reporting timelines). A template library would save significant time and ensure consistency. Add a `CaseReplyTemplate` entity and a template picker in the reply panel.

2. **Collision detection** — the most common complaint in shared inbox tools is duplicate replies. A simple "currently being handled by X" indicator on the case workspace prevents this. Low implementation cost, high value.

3. **SLA breach indicator on the case record itself** — not just in the dashboard. A colour-coded `sla_status` field (ON_TRACK / AT_RISK / BREACHED) visible on the case list and workspace gives case workers immediate context without opening the dashboard.

4. **Side conversations** — IR frequently needs to query internal teams (fund accounting, legal, compliance) before replying to an investor. Formalising this as a "side thread" linked to the case (rather than an ad-hoc internal email) would keep the full context in one place.

5. **Snooze / remind-me** — Zendesk's "pending" status is conceptually a snooze (waiting on the investor to reply). Consider whether IQH's `PENDING` status should trigger an automatic reminder if no investor reply is received within N days.

6. **Status `On-hold`** — Zendesk has a fifth status between Pending and Solved for cases blocked on a third party (not the investor). IQH currently has `PENDING` but doesn't distinguish between "waiting on investor" vs "waiting on internal team". Worth considering.
