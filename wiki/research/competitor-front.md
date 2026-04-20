---
title: Competitor Analysis — Front
source_file: n/a (general knowledge)
ingested: 2026-04-16
type: research
touches: [case-management, email-reply, task-management, manager-dashboard]
---

# Competitor Analysis — Front

## Product overview

Front is a shared inbox platform built around email-native workflows. Unlike traditional ticketing tools, Front retains the feel of a personal email client while adding shared visibility, assignments, and collaboration. It does not use "ticket numbers" — conversations are the unit of work. This makes it a particularly relevant comparison for IQH, whose primary workflow is also email-thread-centric.

It is popular with investor relations, account management, and ops teams that live in email and resist traditional help-desk interfaces.

---

## Core email → case workflow

1. Inbound email arrives in a shared team inbox (equivalent to a monitored mailbox).
2. Team member assigns the conversation to themselves or a colleague — or an automation does it.
3. Assignee replies from within Front; reply goes via the original mailbox (the investor sees a normal email, not a ticket system reply).
4. Internal comments can be added inline in the conversation thread — threaded separately from the email chain.
5. Conversation is archived (not "closed") when complete. Can be re-opened if a new reply arrives.
6. Conversation history is fully preserved and searchable.

---

## Feature inventory

### Shared inbox model
| Feature | Description |
|---|---|
| Team inboxes | Multiple shared mailboxes visible to the team; personal inboxes coexist |
| Inbox rules | Auto-assign, auto-tag, auto-move based on sender, subject, or body keywords |
| Snooze | Temporarily dismiss a conversation; re-surfaces at a set time |
| Archive vs. close | Conversations are archived, not deleted; re-open automatically on new reply |
| Unassigned queue | Dedicated view of conversations with no assignee |

### Collaboration
| Feature | Description |
|---|---|
| @mentions in comments | Tag a colleague in an internal comment to request input without forwarding the email |
| Shared drafts | A draft reply is visible to all team members — can be reviewed before sending |
| Draft locking | When one agent is composing, others see a "being drafted" indicator (collision-prevention) |
| Assignment notifications | Assignee notified on new assignment; watcher notified on any activity |
| Conversation followers | Colleagues can follow a conversation for updates without being assigned |

### Reply workflow
| Feature | Description |
|---|---|
| Canned responses (snippets) | Pre-written reply templates insertable with a shortcut |
| Send later / scheduled send | Schedule a reply to send at a specific time |
| Reply-all vs. reply | Explicit choice per reply |
| Undo send | Brief window to cancel a send after clicking send |
| Signature management | Per-mailbox and per-user signatures |

### Automation
| Feature | Description |
|---|---|
| Rules engine | Powerful if-then rules on any field or activity event |
| Round-robin assignment | Distribute conversations evenly across team members |
| SLA rules | Set response time targets; trigger alerts or re-assignment on breach |
| Sequences (outbound) | Scheduled follow-up email sequences — less relevant for IR inbound |

### AI (Front AI)
| Feature | Description |
|---|---|
| AI Summarise | One-click summary of the full conversation thread |
| AI Compose / Draft | Generate a draft reply from a prompt or from context of the thread |
| AI Translate | Translate incoming messages — less relevant unless multi-lingual investors |
| Sentiment analysis | Surface negative-sentiment conversations for priority attention |
| Conversation tagging (AI) | Auto-tag conversations based on content |

### Analytics
| Feature | Description |
|---|---|
| Response time | Average first-response and resolution time per team and individual |
| Workload distribution | Conversation volume per assignee |
| SLA compliance | % conversations meeting the response time target |
| Busiest hours heatmap | Volume by hour of day / day of week |
| Tag breakdown | Volume breakdown by tag |
| CSAT | Optional satisfaction survey sent on archive |

### Tasks
| Feature | Description |
|---|---|
| Inline tasks | Create a task within a conversation, assign to a team member, set a due date |
| Task reminders | Notify assignee when task is due |

---

## Gap analysis

Features Front has that are **not yet explicitly in the IQH spec**, with Appian replicability assessment.

| Feature                              | Gap severity | Appian replicable? | Notes                                                                                                                                                                                                                                    |
| ------------------------------------ | ------------ | ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Shared drafts (visible before send)  | High         | Partially          | In Appian, a draft reply could be saved as a `CaseDraft` record visible to the team. Requires a "review and send" step rather than a shared live editing experience. Key for IR: senior review of replies before investor receives them. |
| @mentions in internal notes          | Medium       | Yes                | Currently IQH spec has `CaseNote` for internal notes. Adding a `@username` mention field that triggers a notification process model extends this naturally.                                                                              |
| Snooze                               | Medium       | Yes                | A `snoozed_until` datetime field on the Case; a scheduled process model resurfaces it (changes status, sends notification) when the snooze expires.                                                                                      |
| Scheduled send                       | Low          | Yes                | Store the reply as a draft with a `send_at` timestamp; a scheduled process model sends it via Graph API at the right time.                                                                                                               |
| Undo send (brief cancel window)      | Low          | Partially          | Implement as a short delay between "send" click and Graph API call (e.g. 10-second cancel window via a process model timer). Not native in Appian but achievable.                                                                        |
| Busiest hours heatmap                | Low          | Yes                | Appian dashboards can render a heat-map style grid via a custom formatted grid if volume data is available.                                                                                                                              |
| Draft locking / collision prevention | High         | Yes                | Same as Zendesk collision detection. A `being_drafted_by` field on the case, set when a user opens the reply panel, cleared on send or cancel.                                                                                           |
| Round-robin auto-assignment          | Medium       | Yes                | A process model that queries current open case counts per user and assigns to the user with the lowest load. Triggerable from the admin screen.                                                                                          |
| SLA alerts on individual case        | High         | Yes                | See Zendesk gap analysis — same recommendation.                                                                                                                                                                                          |

---

## Inspiration — ideas to consider adopting

1. **Shared draft / senior review step** — this is arguably the most IR-relevant feature Front has. Before a case worker sends a reply, the draft could be visible to (or required to be approved by) a manager or senior team member. This is especially important for regulatory-sensitive queries. Consider adding a `DRAFT_REVIEW` sub-status or an optional "request review" action on the reply panel.

2. **@mention notifications in case notes** — the current `CaseNote` spec is a passive log. Adding the ability to ping a specific colleague (`@name`) with a notification makes it an active collaboration tool. Low implementation cost.

3. **Snooze** — IR frequently has "waiting on fund accounting" cases that shouldn't clutter the active queue but shouldn't be closed either. A snooze that resurfaces the case at a set date is cleaner than manually toggling statuses.

4. **Scheduled reply send** — investors in different time zones may prefer to receive replies during their business hours. Scheduling a send is a professional touch with low implementation cost.

5. **Busiest hours heatmap** — the manager dashboard currently has volume metrics but not time-of-day distribution. A heatmap showing when queries arrive most frequently would help with staffing decisions.

6. **Archive vs. close mental model** — Front's "archive" (conversation lives on, searchable, re-opens on new reply) may be a better model than "CLOSED" for IR. A CLOSED case in IQH currently implies the thread is dead, but an investor may re-open it months later. Worth considering whether `CLOSED` should behave like an archive rather than a terminal state.
