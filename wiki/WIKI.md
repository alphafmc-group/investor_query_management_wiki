# WIKI.md — Investor Query Hub Wiki Maintainer

> Operational instructions for the LLM agent. Load alongside CLAUDE.md at the start of every session.
> This file describes HOW to behave. CLAUDE.md describes WHAT we are building.

---

## Directory structure

```
/
├── CLAUDE.md                  ← Project constitution (load every session)
├── AGENTS.md                  ← This file (load every session)
│
├── raw/                       ← Immutable source documents. Never modify.
│   ├── requirements/          ← Briefs, specs, client notes
│   ├── api/                   ← MS Graph API docs, DDQ API docs, Appian docs
│   ├── design/                ← Wireframes, design notes
│   └── meetings/              ← Call notes, decisions, transcripts
│
└── wiki/
    ├── index.md               ← Catalogue of all wiki pages (update on every ingest)
    ├── log.md                 ← Append-only session log (update at end of every session)
    ├── features/              ← One .md per feature (the unit of agent build work)
    ├── architecture/          ← System design, data model notes, integration decisions
    ├── decisions/             ← Architectural decision records (ADRs)
    └── research/              ← Answers to queries worth preserving
```

---

## On every session start

1. Read `CLAUDE.md` — confirm project context
2. Read `WIKI.md` — confirm operational behaviour (this file)
3. Read `wiki/index.md` — orient to current wiki state
4. Read the last 5 entries of `wiki/log.md` — understand what was done recently
5. Ask the user what they want to do if no task has been given

Do not load all feature files speculatively. Load only what the current task requires.

---

## Workflows

### 1. Ingest — processing a new file in `/raw/`

Triggered when the user says: *"process this file"*, *"ingest this"*, *"I've added X to raw"*, or similar.

**Steps:**

1. **Read** the source file in full
2. **Discuss** with the user — summarise what you found, flag anything surprising or worth emphasising. Ask if there are specific angles to focus on.
3. **Write a summary page** at `wiki/research/<source-slug>.md` using the source page template below
4. **Update `wiki/index.md`** — add the new page to the correct section
5. **Identify affected feature pages** — which features in `wiki/features/` does this source touch? List them and confirm with the user before updating.
6. **Update affected feature pages** — integrate new information, note contradictions with existing content using a `> ⚠ Contradiction:` blockquote, update status if relevant
7. **Update architecture pages** if the source affects data model, integrations, or system design decisions
8. **Append to `wiki/log.md`** using the log format below

A single source may touch 5–15 wiki pages. That is expected and correct.

If the source contradicts something already in the wiki, **flag it explicitly** — do not silently overwrite. Use:
```markdown
> ⚠ Contradiction: This source states X. Previous source `<slug>` stated Y. Awaiting clarification.
```

---

### 3. Query — answering a question against the wiki

Triggered when the user asks a question about the project, a decision, or the system.

**Steps:**

1. Read `wiki/index.md` to find relevant pages
2. Read the relevant pages
3. Synthesise an answer with page citations (e.g. `[Case data model](wiki/features/case-management.md)`)
4. **If the answer is worth keeping**, ask the user: *"This seems worth filing — shall I save it to the wiki?"*
5. If yes, write the answer as a page in `wiki/research/<slug>.md` and update the index
6. Append to `wiki/log.md` if a new page was created

---

### 4. Lint — health-checking the wiki

Triggered when the user says: *"lint the wiki"*, *"health check"*, *"clean up"*, or similar.

**Check for:**
- Orphan pages — pages in the wiki not linked from anywhere
- Missing pages — concepts mentioned in multiple pages but with no page of their own
- Stale contradictions — `⚠ Contradiction` flags that have not been resolved
- Features still `planned` that may have been implicitly built
- Index entries missing or out of date
- Log entries that reference pages that don't exist

**Output:** A lint report in the chat. Ask the user which issues to fix before touching any files.

---

## File templates

### Feature page — `wiki/features/<feature-name>.md`

```markdown
---
title: <Feature Name>
status: planned | in-progress | built | revised
priority: high | medium | low
depends_on: []
last_updated: YYYY-MM-DD
---

# <Feature Name>

## Intent
As a <user type>, I want to <action> so that <outcome>.

## Scope
What is included. What is explicitly out of scope for this feature.

## Appian objects
List of Appian objects this feature creates or modifies:
- Process models:
- Records:
- Interfaces:
- Connected systems:
- Constants:

## Data touched
Which entities from the CLAUDE.md data model this feature reads or writes.

## Acceptance criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Open questions
Questions that need answering before or during build.

## Dependencies
Links to other feature pages this feature relies on.

## Build notes
(Populated during/after build — deviations from spec, decisions made, gotchas.)
```

---

### Source summary page — `wiki/research/<source-slug>.md`

```markdown
---
title: <Source Title>
source_file: raw/<path/to/file>
ingested: YYYY-MM-DD
type: requirements | api-doc | meeting | design | research
touches: [<feature-slug>, ...]
---

# <Source Title>

## Summary
2–4 sentence summary of what this source contains.

## Key points
- Point 1
- Point 2

## Implications for the project
What this means for features, architecture, or decisions.

## Contradictions flagged
Any conflicts with existing wiki content noted here.

## Raw excerpt
Optional: a short direct quote if wording matters (e.g. a client requirement stated verbatim).
```

---

### Architecture decision record — `wiki/decisions/<slug>.md`

```markdown
---
title: <Decision Title>
date: YYYY-MM-DD
status: decided | under-review | superseded
---

# <Decision Title>

## Context
Why this decision needed to be made.

## Decision
What was decided.

## Rationale
Why this option over alternatives.

## Consequences
What this means going forward. Any trade-offs accepted.

## Alternatives considered
Other options that were evaluated.
```

---

## Index format — `wiki/index.md`

Maintain sections in this order. Add new pages to the correct section. One line per page.

```markdown
# Wiki index

Last updated: YYYY-MM-DD | Pages: N

## Features
- [Email Polling](features/email-polling.md) — MS Graph mailbox polling and ingest pipeline `planned`
- [Case Creation](features/case-creation.md) — Auto-create cases from inbound emails, threading logic `planned`
...

## Architecture
- [System Design](architecture/system-design.md) — High-level architecture overview
- [Data Model](architecture/data-model.md) — Entity relationships and field definitions
...

## Decisions
- [YYYY-MM-DD — Decision title](decisions/<slug>.md)
...

## Research / Query answers
- [Source: <title>](research/<slug>.md) — one line description
...
```

---

## Log format — `wiki/log.md`

Append only. Never edit previous entries. One entry per session.

```markdown
## [YYYY-MM-DD] <type> | <subject> | <brief summary>
```

Types: `ingest` | `build` | `query` | `lint` | `decision` | `update`

**Examples:**
```markdown
## [2026-04-15] ingest | MS Graph API docs | Added summary, updated email-polling and case-creation feature pages
## [2026-04-16] build | email-polling | Implemented mailbox polling process model IQH_PM_PollMailbox, marked feature built
## [2026-04-17] query | SLA targets | Discussed SLA options, filed recommendation to wiki/research/sla-targets.md
## [2026-04-17] lint | full wiki | Fixed 3 orphan pages, resolved 1 contradiction in case-management.md
```

Parse the last 5 entries on session start with:
```
grep "^## \[" wiki/log.md | tail -5
```

---

## Behavioural rules

- **Never modify files in `/raw/`** — they are immutable source documents
- **Never silently overwrite a contradiction** — always flag with `⚠ Contradiction` and seek clarification
- **Never auto-send an AI-generated reply** — the DDQ agent suggestion always requires explicit human send action (see CLAUDE.md)
- **One feature per build session** — do not attempt to build multiple features in one context window
- **Always confirm scope before building** — restate what you are about to do and wait for the user to confirm
- **File good answers** — if a query produces a useful synthesis, offer to save it to the wiki
- **Keep feature pages current** — the feature `.md` is the source of truth for its spec; update it as decisions are made, not just when building
- **Update the index and log on every session that changes the wiki** — a wiki without a current index is hard to navigate

---

## What a healthy wiki looks like

- Every feature in `CLAUDE.md`'s feature table has a corresponding page in `wiki/features/`
- Every feature page has acceptance criteria that could be handed to an agent as a self-contained task
- No `⚠ Contradiction` flags older than one week without resolution
- The index reflects every page that exists
- The log has an entry for every session
- Architecture decisions are recorded in `wiki/decisions/` so future sessions don't re-litigate settled choices