---
marp: true
theme: default
paginate: true
style: |
  section {
    font-family: 'Segoe UI', sans-serif;
    font-size: 1.1rem;
  }
  h1 { color: #1a2e4a; }
  h2 { color: #1a2e4a; border-bottom: 2px solid #c8a951; padding-bottom: 0.2em; }
  table { font-size: 0.85rem; width: 100%; }
  th { background: #1a2e4a; color: white; }
  tr:nth-child(even) { background: #f4f6f9; }
  .lead h1 { font-size: 2.2rem; }
  .lead p { font-size: 1.1rem; color: #555; }
  blockquote { border-left: 4px solid #c8a951; background: #fdf9ec; padding: 0.6em 1em; font-style: normal; }
---

<!-- _class: lead -->

# Competitor Analysis
## Helpdesk & Case Management Tools

Investor Query Hub — Feature Gap Analysis
April 2026

---

## Scope & purpose

**What this is**
A review of four general-purpose helpdesk tools to identify features worth borrowing or adapting for IQH.

**What this is not**
An evaluation of alternatives to Appian. All tools reviewed are being assessed as *inspiration sources*, not replacement candidates.

**Four tools reviewed**

| Tool | Positioning |
|---|---|
| **Zendesk** | Industry benchmark — broadest feature set |
| **Front** | Email-native — popular with IR and account management teams |
| **Freshdesk** | Mid-market — strong automation and collaboration |
| **Help Scout** | Simplest — human-first email experience |

---

## Zendesk — the benchmark

The de-facto standard for email-based case management. Mature SLA, automation, and AI stack.

**Standout features**

| Feature | What it does |
|---|---|
| Macros | One-click templates: pre-fill reply + set fields + change status simultaneously |
| Side conversations | Private sub-thread with a third party (e.g. fund accounting) — investor never sees it |
| Collision detection | Banner if another agent is currently viewing or composing a reply on the same ticket |
| SLA breach indicator | Colour-coded countdown on each ticket — not just in the dashboard |
| Business hours SLA | SLA clock pauses outside defined working hours |
| Ticket merging | Merge two tickets that turn out to be the same enquiry |
| CC / followers | Stakeholders watch a case without being the assignee |

> Zendesk's strongest lesson for IQH: SLA breach visibility belongs on the **case**, not just the manager dashboard.

---

## Front — closest to IR workflows

No ticket numbers. Conversations are the unit of work. Popular with IR teams that live in email.

**Standout features**

| Feature | What it does |
|---|---|
| Shared drafts | A draft reply is visible to the whole team before it is sent |
| Draft locking | "X is composing a reply" — prevents duplicate sends |
| @mentions in notes | Tag a colleague in an internal comment; they receive a notification and link |
| Snooze | Dismiss a case temporarily; resurfaces at a set time or on investor reply |
| Archive vs. close | Cases are archived (not deleted); re-open automatically if investor replies |
| Scheduled send | Write a reply now, send it at a specific time |
| Busiest hours heatmap | Volume by hour of day and day of week — useful for staffing |

> Front's strongest lesson for IQH: **shared draft + senior review** before a reply reaches the investor — critical for regulated IR communications.

---

## Freshdesk — collaboration depth

Mid-market tool with the richest internal collaboration feature set of the four.

**Standout features**

| Feature | What it does |
|---|---|
| Team Huddle | Private thread with an internal expert *within* the case — expert sees full context, their reply drops into the agent's draft |
| Parent-child tickets | Split a complex multi-question email into linked sub-cases, each tracked independently |
| Linked tickets | Cross-reference related cases without merging — "12 investors asked the same thing" |
| Scenario automations | Named multi-step action bundles: one click applies a set of field changes (e.g. "Escalate to manager") |
| SLA breach escalation | Auto-notify manager or re-assign if SLA breached — not just a visual indicator |
| Reply template variables | Templates auto-populate investor name, case reference, fund name from case fields |

> Freshdesk's strongest lesson for IQH: **Team Huddle** — IR constantly loops in fund accounting or legal before replying. Formalise it.

---

## Help Scout — human-first simplicity

The most email-native of the four. Valuable as a UX benchmark, not just a feature reference.

**Standout features**

| Feature | What it does |
|---|---|
| Previous conversations sidebar | All prior cases for the same sender, visible in the case workspace at a glance |
| @mentions in notes | Same as Front — tag a colleague, trigger a notification |
| AI Improve | Rewrite a human-drafted reply for tone, formality, or brevity — without replacing it |
| Snooze | Same as Front |
| Custom views / saved searches | Each agent saves their own filtered queue |
| Simpler status model | Deliberately avoids status complexity — each status is a decision cost |

> Help Scout's strongest lesson for IQH: the **previous conversations sidebar** — an IR case worker should instantly see every prior interaction with that investor.

---

## Cross-cutting gaps

Features present in **3 or more** of the four tools that are **absent from the current IQH spec**.

| Feature | Tools | Gap severity |
|---|---|---|
| Reply templates / canned responses | Zendesk, Front, Freshdesk, Help Scout | **High** |
| Collision detection / draft locking | Zendesk, Front, Freshdesk, Help Scout | **High** |
| SLA breach indicator on the case record | Zendesk, Front, Freshdesk | **High** |
| @mentions in internal notes | Front, Freshdesk, Help Scout | Medium |
| Snooze / resurface later | Front, Freshdesk, Help Scout | Medium |
| Previous investor conversations sidebar | Help Scout + implied in others | **High** |

> When a feature appears across all four mature products, it is solving a real problem. These are not nice-to-haves.

---

## Recommendations — v1 candidates

Low implementation cost, high day-one value for IR case workers.

| Feature | Why now | Appian approach |
|---|---|---|
| **Reply templates** | IR sends repetitive replies — NAV requests, sub docs, reporting timelines. Saves time, ensures consistency. | `CaseReplyTemplate` record; template picker in reply panel with variable substitution (`{{investor_name}}`, `{{case_ref}}`) |
| **Collision detection** | Shared mailbox — duplicate replies to an investor are a professional embarrassment. | `being_drafted_by` field on Case; set on reply panel open, cleared on send or cancel |
| **SLA breach indicator on case** | Dashboard-only SLA is passive. Case workers need to see breach risk without opening a report. | `sla_status` field (ON_TRACK / AT_RISK / BREACHED) updated by scheduled process model; colour-coded on case list and workspace |
| **Previous investor conversations sidebar** | IR relationships are long-term. Context from prior interactions matters on every new query. | Panel on case workspace filtered by `sender_email`; shows case reference, status, date, subject |

---

## Recommendations — v2 candidates

Higher effort or lower day-one priority. Worth capturing now before the spec is finalised.

| Feature | Why later | Notes |
|---|---|---|
| **Shared draft / senior review** | Important for regulated queries, but requires a workflow decision on who approves what. | `DRAFT_REVIEW` sub-status; "Request review" action on reply panel; manager approves before send |
| **Team Huddle (internal expert thread)** | IR loops in fund accounting or legal regularly — formalising this keeps context in IQH rather than scattered ad-hoc emails. | Internal-only email thread or note thread linked to a case, directed at a named colleague |
| **@mentions in notes** | Extends `CaseNote` from a passive log to an active collaboration tool. | `@username` syntax in note body; notification process model on save |
| **Snooze** | "Waiting on fund accounting" cases should be dormant, not cluttering the active queue. | `snoozed_until` field on Case; scheduled PM resurfaces on expiry |
| **Parent-child cases** | Useful for multi-question emails but adds workflow complexity. | `parent_case_id` FK on Case (self-referential) |
| **SLA breach escalation** | Auto-notify or re-assign when SLA is breached — a safety net, not just a visual. | Scheduled PM triggered when `sla_status = BREACHED` |

---

## Everything is replicable in Appian

No identified feature requires a platform capability IQH doesn't have.

| Capability needed | Appian mechanism |
|---|---|
| Field-level state (e.g. `snoozed_until`, `being_drafted_by`) | Record field update via process model |
| Timed resurface / polling | Scheduled process model |
| In-app notifications | Appian native notifications |
| Template store with variables | `CaseReplyTemplate` record + SAIL expression evaluation |
| Internal expert thread | `CaseHuddle` record (internal email thread FK'd to Case) |
| Investor history sidebar | Record-linked view filtered by `sender_email` |

> The constraint is prioritisation, not platform capability.

---

## Open questions

Answers needed before any of these features enter the build spec.

1. **Senior reply review** — is there currently a manual approval step before IR replies go to investors? If yes, this is a v1 requirement, not v2.

2. **Reply templates** — should these be team-wide (shared library) or per-user? Who manages the template library — admin screen or any case worker?

3. **Investor identity** — is there an `Investor` entity or CRM record beyond `sender_email`? The previous conversations sidebar and other investor-level features depend on a reliable investor identifier.

4. **Status model** — does `IN_PROGRESS` add genuine value over `OPEN + assignee`? Front and Help Scout suggest simpler is better. Worth confirming before building.

5. **SLA targets** — still undefined. Needed before the SLA breach indicator can be built. *(Existing open question — not new.)*
