---
status: planned
related:
  - email-polling.md
  - ai-classification.md
  - case-management.md
  - investor-profile.md
data_model:
  - Case
  - Email
  - CaseEmail
  - InvestorContact
  - InvestorEntity
---

# Case Creation

## Intent

As the system, I want to automatically convert each inbound email into a structured case (or attach it to an existing case if it belongs to a known thread) so that every investor query is tracked from the moment it arrives.

## Threading rule

> All emails sharing the same `graph_conversation_id` belong to the same Case.

On ingest:
1. Look up `Case` by `conversation_id = graph_conversation_id`.
2. **Match found** → attach email to existing case via `CaseEmail`; update `Case.status` to `IN_PROGRESS` if currently `RESOLVED` or `CLOSED`.
3. **No match** → create new `Case` record, then create `CaseEmail` link.

## Case creation flow

```
Email ingested (from email-polling)
  → IQH_ProcessModel_CreateOrAttachCase
      ├── Query Case by conversation_id
      ├── [New case] Create Case record
      │     ├── reference_number: IQ-{YYYY}-{seq}  (Appian sequence)
      │     ├── status: OPEN
      │     ├── priority: MEDIUM  (placeholder until AI classification runs)
      │     ├── created_at: now()
      │     └── subject: email subject
      ├── [New case] Investor resolution  → see investor-profile.md
      │     ├── Query InvestorContact WHERE email_address = Email.from_email AND is_active = true
      │     ├── Match → set Case.investor_contact_id + Case.investor_entity_id
      │     └── No match → both fields null; case workspace shows "Link investor" banner
      ├── [New case] Trigger AI classification (async)  → see ai-classification.md
      └── Create CaseEmail join record
```

## Reference number format

`IQ-{YYYY}-{5-digit-seq}` — e.g. `IQ-2026-00142`. Sequence resets per year. Generated via Appian sequence object `IQH_Seq_CaseReference`.

## Appian objects

- `IQH_ProcessModel_CreateOrAttachCase`
- `IQH_Record_Case`
- `IQH_Record_CaseEmail`
- `IQH_Seq_CaseReference`

## Acceptance criteria

- [ ] Every inbound email results in either a new case or attachment to an existing case — never dropped
- [ ] Threading works correctly: a reply on an existing thread attaches to the existing case, not a new one
- [ ] Reference numbers are unique and in `IQ-YYYY-NNNNN` format
- [ ] New cases start with `status: OPEN`, `priority: MEDIUM`
- [ ] AI classification is triggered asynchronously — case creation does not wait for it
- [ ] A `CaseEmail` join record is created for every email-case association, ordered by `received_at`
- [ ] If a reply arrives on a `RESOLVED` or `CLOSED` case, case is re-opened to `IN_PROGRESS`
- [ ] Investor resolution runs on new case creation: sender email matched against active `InvestorContact` records
- [ ] Matched cases have `investor_entity_id` and `investor_contact_id` populated
- [ ] Unmatched cases have both fields null; case workspace shows the "Link investor" banner

## Open questions

- Should outbound replies (sent by IR team) also be stored as `Email` records and linked via `CaseEmail`? (Suggested: yes, with `direction: OUTBOUND`)
- What happens if two emails with the same `conversationId` arrive simultaneously? Need a concurrency guard.
