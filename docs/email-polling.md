---
status: planned
related:
  - case-creation.md
  - admin-screen.md
data_model:
  - Mailbox
  - Email
  - EmailAttachment
---

# Email Polling

## Intent

As an IR system, I want to continuously monitor one or more mailboxes and ingest new investor emails so that no message is missed and every query enters the case management pipeline automatically.

## How it works

- A scheduled Appian process model (`IQH_ProcessModel_PollMailboxes`) polls each active `Mailbox` record on a configurable interval (stored as an Appian constant).
- For each mailbox, the process calls the MS Graph API: `GET /v1.0/users/{mailbox}/messages?$filter=isRead eq false`
- Each unread message is transformed into an `Email` record and passed to the case creation pipeline.
- After successful ingest, the message is marked as read via Graph API so it is not re-processed.
- All Graph API calls are wrapped in try/catch; failures are written to `IQH_ErrorLog`.

## MS Graph API details

| Operation | Endpoint |
|---|---|
| List unread messages | `GET /v1.0/users/{mailbox}/messages?$filter=isRead eq false` |
| Mark as read | `PATCH /v1.0/users/{mailbox}/messages/{id}` `{ "isRead": true }` |

Fields to capture from each Graph message:

| Graph field | Stored as |
|---|---|
| `id` | `graph_message_id` |
| `internetMessageId` | `message_id` (SMTP, dedup key) |
| `conversationId` | `graph_conversation_id` |
| `conversationIndex` | `conversation_index` |
| `internetMessageHeaders["In-Reply-To"]` | `in_reply_to` |
| `from.emailAddress.address` | `from_email` |
| `from.emailAddress.name` | `from_name` |
| `toRecipients[].emailAddress.address` | `to_emails` |
| `toRecipients[].emailAddress.name` | `to_names` |
| `ccRecipients[].emailAddress.address` | `cc_emails` |
| `bccRecipients[].emailAddress.address` | `bcc_emails` |
| `subject` | `subject` |
| `importance` | `importance` |
| `body.content` (html) | `body_html` |
| `body.content` (text) | `body_text` |
| `receivedDateTime` | `received_at` |

**Attachments**: fetched via `GET /v1.0/users/{mailbox}/messages/{id}/attachments`. Each attachment is stored as an Appian document and linked via an `EmailAttachment` record (`is_inline` set from attachment `isInline` flag). `Email.doc_id` stores the full email as a composite Appian document; `Email.doc_id_no_att` stores the email body only.

## Appian objects

- `IQH_ProcessModel_PollMailboxes` — scheduled polling loop
- `IQH_CS_MicrosoftGraph` — connected system (OAuth 2.0 client credentials)
- `IQH_Constant_PollingIntervalMinutes`
- `IQH_Constant_MailboxIds` (list)
- `IQH_ErrorLog` — record for failed API calls

## Acceptance criteria

- [ ] All active mailboxes are polled on the configured interval
- [ ] Each unread email is ingested exactly once (no duplicates)
- [ ] All fields in the field capture table are stored on every `Email` record
- [ ] Attachments are fetched and stored as `EmailAttachment` records with Appian document references
- [ ] Inline attachments (`is_inline = true`) are distinguished from file attachments
- [ ] Message is marked read in Graph API after successful ingest
- [ ] Failures are logged to `IQH_ErrorLog` with mailbox, message ID, timestamp, and error detail
- [ ] Polling can be paused per mailbox from the Admin screen

## Open questions

- What is the polling interval? (suggested: 5 minutes)
- Should bounced / out-of-office auto-replies be filtered out? If so, how — by sender domain, subject prefix, or Graph API category?
- ~~How to handle attachments — store as Appian documents or leave in Graph?~~ **Decided**: stored as Appian documents, linked via `EmailAttachment` records. Inline images flagged with `is_inline = true`.
