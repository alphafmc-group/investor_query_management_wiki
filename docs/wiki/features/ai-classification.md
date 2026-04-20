---
status: planned
related:
  - case-creation.md
  - case-management.md
  - admin-screen.md
  - manager-dashboard.md
data_model:
  - Case
  - Category
---

# AI Classification

## Intent

As the system, I want to automatically assign a priority and category to each new case using an LLM, so that cases are routed and surfaced correctly without requiring manual triage for every email.

## How it works

Triggered asynchronously after case creation (see [[case-creation]]). The Appian LLM Connector sends a structured prompt to the configured model and parses the response.

### Prompt inputs

- `subject` — email subject line
- `body` — email body, truncated to 1500 characters
- `categories` — list of active `Category` records as `[{name, description}]`

### Prompt outputs (expected JSON)

```json
{
  "priority": "LOW | MEDIUM | HIGH | URGENT",
  "category_id": "<id of matched category>",
  "confidence": 0.0–1.0
}
```

### Applying the result

- `Case.priority` ← LLM result (overwrites placeholder `MEDIUM`)
- `Case.category_id` ← LLM result
- `Case.ai_classification_confidence` ← stored for audit
- If the LLM response cannot be parsed or confidence < threshold (TBD), log a warning and leave `priority: MEDIUM`, `category_id: null` — do not fail the case.

### Human override

Case workers can change priority and category at any time from the case workspace. Override is not tracked separately (the AI value is simply replaced), but the `ai_classification_confidence` field remains for audit.

## Appian objects

- `IQH_ProcessModel_ClassifyCase` — async process triggered post-creation
- `IQH_CS_LLMConnector` — Appian OOTB LLM connected system
- `IQH_Constant_LLMModelName`
- `IQH_Constant_ClassificationConfidenceThreshold`

## Acceptance criteria

- [ ] Classification runs asynchronously — does not block case creation
- [ ] Priority is one of `LOW | MEDIUM | HIGH | URGENT`
- [ ] Category is matched to an active `Category` record by ID
- [ ] `ai_classification_confidence` is stored on the `Case` record
- [ ] If LLM fails or returns unparseable output, case is not broken — falls back to defaults
- [ ] Case worker can override both priority and category from the workspace
- [ ] Manager dashboard can report AI classification accuracy (confirmed vs overridden)

## Open questions

- What confidence threshold should trigger a warning or manual review flag?
- Should classification re-run if a new email is added to an existing case?
- Should the prompt include previous emails in the thread for context?
