---
status: planned
related:
  - email-reply.md
  - ai-classification.md
data_model:
  - Case
  - Email
---

# AI DDQ Agent (Response Suggestions)

## Intent

As an IR case worker composing a reply, I want the system to suggest a draft response drawn from the DDQ knowledge base — with the source cited — so I can reply faster and more accurately without searching documents manually.

## How it works

Triggered when the reply panel is opened (see [[email-reply]]). Runs in the background; the reply panel is usable immediately while the suggestion loads.

### Request to DDQ API

Input: the investor's query text (latest inbound email body, or the full case subject + body if first email).

```
POST {DDQ_API_ENDPOINT}
{
  "query": "<investor query text>",
  "case_reference": "IQ-2026-00142"
}
```

### DDQ API response (expected shape)

```json
{
  "suggested_reply": "...",
  "source": {
    "document": "Crestline Fund III DDQ v4.pdf",
    "section": "Section 4.2 — Fee Structure",
    "url": "..."
  },
  "confidence": 0.0–1.0
}
```

### Displaying the suggestion

- Suggested reply text is pre-populated into the reply body, visually marked (e.g. light blue background or AI badge).
- Source is shown below the body: `Source: {document}, {section}`.
- If no suggestion or low confidence: show "No suggestion available" — reply panel remains fully editable.
- Worker must edit and explicitly click Send — the AI text is never auto-sent.

## Safety constraint

> AI-generated replies must never be sent without explicit human review and a deliberate send action.

The send button is only enabled after the worker has had opportunity to edit (no auto-send on load).

## Appian objects

- `IQH_ProcessModel_FetchDDQSuggestion` — async, called from reply panel
- `IQH_CS_DDQApi` — connected system for DDQ API
- `IQH_Constant_DDQApiEndpoint`
- `IQH_Constant_DDQConfidenceThreshold`

## Acceptance criteria

- [ ] DDQ suggestion is fetched asynchronously when reply panel opens
- [ ] Suggested text and source are displayed in the reply panel
- [ ] Suggestion is visually distinguished from worker-authored text
- [ ] Source citation (document name + section) is shown alongside the suggestion
- [ ] If API fails or returns no result, reply panel works normally with no suggestion
- [ ] Send button requires explicit worker action — no auto-send
- [ ] Worker can freely edit or discard the suggestion before sending

## Open questions

- What is the DDQ API authentication method? (API key, OAuth?)
- Should the confidence score be shown to the case worker, or hidden?
- Should each suggestion usage be logged for quality tracking?
- What happens if the query spans multiple DDQ sections — can the API return multiple sources?
