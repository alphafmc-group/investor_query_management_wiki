---
status: planned
related:
  - case-management.md
  - ai-ddq-agent.md
  - email-polling.md
data_model:
  - Email
  - CaseEmail
  - Case
---

# Email Reply

## Intent

As an IR case worker, I want to compose and send a reply to an investor directly from the case workspace, so that all correspondence stays in thread and is recorded against the case.

## Reply flow

```
Case worker clicks "Reply" in case workspace
  → Reply panel opens (inline or modal)
      ├── To: pre-filled from original sender
      ├── Subject: pre-filled (Re: {original subject})
      ├── Body: editable rich text
      ├── [Optional] AI suggestion loaded from DDQ Agent → see ai-ddq-agent.md
      └── "Send" button
  → On Send:
      ├── POST /v1.0/users/{mailbox}/messages/{original_message_id}/reply
      ├── Store outbound Email record (direction: OUTBOUND)
      ├── Create CaseEmail join record
      └── Update Case.status to IN_PROGRESS (if PENDING)
```

## MS Graph API

Reply preserves thread by replying to the original message ID:
```
POST /v1.0/users/{mailbox}/messages/{id}/reply
Body: { "message": { "body": { "contentType": "html", "content": "..." } } }
```

This ensures `conversationId` is maintained and the reply appears in the same thread in Outlook.

## Signature

A standard IR team email signature is appended automatically. Signature template stored as an Appian constant (`IQH_Constant_EmailSignatureHtml`).

## AI suggestion integration

When the reply panel opens, the DDQ Agent is triggered in the background (see [[ai-ddq-agent]]). If a suggestion is returned:
- It is pre-populated into the body (visually marked as AI-suggested).
- The source citation is shown below the body.
- The case worker must edit and/or confirm before sending — never auto-sent.

## Appian objects

- `IQH_Interface_ReplyPanel`
- `IQH_ProcessModel_SendReply`
- `IQH_Constant_EmailSignatureHtml`

## Acceptance criteria

- [ ] Reply panel pre-fills To, Subject from the case
- [ ] Worker can edit the body freely before sending
- [ ] Send uses Graph API `reply` endpoint to preserve thread
- [ ] Sent email is stored as an `Email` record with `direction: OUTBOUND`
- [ ] Outbound email is linked to the case via `CaseEmail`
- [ ] Case status moves from `PENDING` to `IN_PROGRESS` on send
- [ ] AI suggestion (if available) is pre-populated but editable; source is shown
- [ ] Reply cannot be sent without at least some body content
- [ ] Failures (Graph API errors) are caught, shown to user, logged to `IQH_ErrorLog`

## Open questions

- Should case workers be able to CC additional recipients?
- Should the sent email also be BCC'd to an archive mailbox?
- Should there be a draft save / send-later feature?
