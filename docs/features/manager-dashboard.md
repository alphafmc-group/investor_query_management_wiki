---
status: planned
related:
  - case-management.md
  - task-management.md
  - ai-classification.md
  - admin-screen.md
data_model:
  - Case
  - CaseTask
  - User
  - Category
last_updated: 2026-04-16
---

# Manager Dashboard

## Intent

As an IR manager, I want a real-time overview of team workload, SLA compliance, and case volume trends — so I can spot bottlenecks and report upward.

> Managers cannot reassign cases from this dashboard. Reassignment is done from the Case record view.

---

## Layout

Three rows. Global filters sit above all rows.

```
┌──────────────┬──────────────┬──────────────┬──────────────┐
│ 1. Open Cases│ 6. New/Week  │ 7. Unassigned│ 4. SLA %     │
│ (KPI + bar)  │ (KPI + delta)│ (KPI, linked)│ (KPI + bar)  │
└──────────────┴──────────────┴──────────────┴──────────────┘
┌──────────────────────────┬───────────────────────────────┐
│ 3. Workload by Assignee  │ 2. Cases by Category          │
│ (data grid)              │ (horizontal bar chart)        │
└──────────────────────────┴───────────────────────────────┘
┌──────────────────────────┬───────────────────────────────┐
│ 5. Resolution Time Trend │ 8. AI Classification Accuracy │
│ (line chart)             │ (2 KPIs + breakdown grid)     │
└──────────────────────────┴───────────────────────────────┘
```

---

## Global filters

| Filter | Component | Applies to panels |
|---|---|---|
| Date range | Date picker (from / to) | 1, 2, 3, 4, 7, 8 |
| Category | Multi-select dropdown | 2, 3, 8 |
| Case worker | Multi-select dropdown | 3 |

Panels 5 (30-day rolling) and 6 (current week vs prior week) are time-fixed and do not respond to the date range filter.

---

## Dashboard panels

### 1. Open Case Volume
**Chart type:** KPI card with embedded mini stacked bar  
**Appian component:** `a!cardLayout` + `a!progressBar` (or inline `a!barChartField`)

```
┌────────────────┐
│  Open Cases    │
│     142        │
│ [███▓▓░░░░░░]  │
│  76   51   15  │
│ Open InProg Pend│
└────────────────┘
```

- Total = count of Cases where `status` IN (OPEN, IN_PROGRESS, PENDING)
- Stacked bar shows proportions, colour-coded: blue = OPEN, amber = IN_PROGRESS, grey = PENDING
- Card is clickable — navigates to Case record list pre-filtered to open statuses
- Responds to global date range filter (cases created within range)

---

### 2. Cases by Category
**Chart type:** Horizontal bar chart  
**Appian component:** `a!barChartField` (horizontal orientation)

```
Capital Calls  ████████████████  42
Distributions  ██████████        27
Reporting      ████████          22
LP Admin       █████             14
Other          ███                9
```

- Bars sorted descending by count
- X-axis = case count; Y-axis = `Category.name`
- Data = count of open Cases per Category within global date range
- Responds to all global filters

---

### 3. Workload by Assignee
**Chart type:** Data grid  
**Appian component:** `a!gridField`

```
┌─────────────────┬──────┬─────────────┬─────────┬───────┐
│ Case Worker     │ Open │ In Progress │ Pending │ Total │
├─────────────────┼──────┼─────────────┼─────────┼───────┤
│ Alice Chen      │   4  │      2      │    1    │   7   │
│ Bob Matsuda     │   6  │      1      │    0    │   7   │
│ Carol Osei      │   2  │      4      │    2    │   8   │ ⚠
└─────────────────┴──────┴─────────────┴─────────┴───────┘
[Export to Excel]
```

- Rows = all active users with at least one open Case
- Row highlighted amber when Total > `IQH_Constant_WorkloadAlertThreshold` (TBD — client to confirm; suggest 10)
- All columns sortable
- Excel export enabled
- Responds to global date range and category filters

---

### 4. SLA Compliance — First Response
**Chart type:** KPI card with 3-segment stacked indicator bar  
**Appian component:** `a!cardLayout` + inline `a!barChartField` or custom `a!progressBar`

```
┌────────────────────────────────┐
│ SLA Compliance (First Response)│
│        91% compliant           │
│  ██████████████████░░░░▒▒▒     │
│        91%       5%    4%      │
│  ■ Compliant  ■ At risk  ■ Breached │
└────────────────────────────────┘
```

- **Compliant** (green): first outbound Email sent within `IQH_Constant_SLATargetHours` of `Case.created_at`
- **At risk** (amber): Case still open, elapsed time > 75% of SLA target, no first response yet
- **Breached** (red): Case still open, elapsed time > SLA target, no first response sent
- Denominator = all Cases within date range
- SLA target read from `IQH_Constant_SLATargetHours` — configured from admin screen
- Responds to global date range filter

---

### 5. Average Resolution Time — 30-Day Trend
**Chart type:** Line chart  
**Appian component:** `a!lineChartField`

```
Days
  8 │          ╭──╮
  6 │    ╭─────╯  ╰──╮
  4 │────╯            ╰───
  2 │
  0 └────────────────────── Date
     -30d             Today
```

- X-axis = date (daily or weekly data points — TBD based on case volume)
- Y-axis = average days from `Case.created_at` to `Case.resolved_at`, for Cases resolved on that day/week
- Always shows rolling 30-day window; does not respond to global date range filter
- Panel label must read: "Rolling 30-day average"

---

### 6. New Cases This Week
**Chart type:** KPI card with week-over-week delta  
**Appian component:** `a!cardLayout`

```
┌──────────────────┐
│  New This Week   │
│       34         │
│   ↑ +12 vs last  │
└──────────────────┘
```

- Count = Cases where `created_at` falls in current calendar week (Mon–Sun)
- Delta = current week count minus prior week count
- Up arrow (green) if positive; down arrow (grey) if negative
- Does not respond to global date range filter

---

### 7. Unassigned Cases
**Chart type:** KPI card with conditional alert styling and click-through  
**Appian component:** `a!cardLayout` with conditional `style` (standard vs error)

```
Normal:                       Alert (count > threshold):
┌──────────────────┐          ┌──────────────────┐
│  Unassigned      │          │ ⚠ Unassigned     │
│       3          │          │       9           │
│  [View list →]   │          │  [View list →]   │
└──────────────────┘          └──────────────────┘ (red border)
```

- Count = Cases where `assigned_to` IS NULL and `status` IN (OPEN, IN_PROGRESS, PENDING)
- Red border and warning icon when count > `IQH_Constant_UnassignedAlertThreshold`
- Card is a link — clicking navigates to Case record list pre-filtered to unassigned
- No separate list panel on the dashboard
- Responds to global date range filter

---

### 8. AI Classification Accuracy
**Chart type:** Two KPI metrics + breakdown grid  
**Appian component:** Two `a!cardLayout` side-by-side + `a!gridField`

```
┌──────────────────────┬──────────────────────┐
│  Priority Accuracy   │  Category Accuracy   │
│   87% confirmed      │   79% confirmed      │
│   13% overridden     │   21% overridden     │
└──────────────────────┴──────────────────────┘

Category override breakdown:
┌─────────────────┬───────────┬────────────┬──────────┐
│ Category        │ Confirmed │ Overridden │ Override%│
├─────────────────┼───────────┼────────────┼──────────┤
│ Capital Calls   │    95     │      5     │   5%     │
│ Distributions   │    72     │     28     │  28%  ⚠  │
│ Reporting       │    80     │     20     │  20%     │
└─────────────────┴───────────┴────────────┴──────────┘
[Export to Excel]
```

- **Priority accuracy** = Cases where `ai_priority` was not changed by case worker ÷ total AI-classified Cases
- **Category accuracy** = Cases where `ai_category_id` was not changed ÷ total AI-classified Cases
- "Confirmed" is inferred: case closed or responded to without the AI-assigned value being changed
- Breakdown grid: one row per active Category; sortable by Override%
- Row highlighted amber when Override% > `IQH_Constant_AIOverrideAlertThreshold` (TBD — suggest 25%)
- Excel export on breakdown grid
- Responds to global date range filter

---

## Appian objects

| Object | Type | Notes |
|---|---|---|
| `IQH_Interface_ManagerDashboard` | Interface | Main dashboard interface |
| `IQH_Report_CaseVolume` | Report | Feeds panels 1, 6, 7 |
| `IQH_Report_SLACompliance` | Report | Feeds panel 4 |
| `IQH_Report_WorkloadByAssignee` | Report | Feeds panel 3 |
| `IQH_Report_ResolutionTrend` | Report | Feeds panel 5 |
| `IQH_Report_AIAccuracy` | Report | Feeds panel 8 |
| `IQH_Report_CasesByCategory` | Report | Feeds panel 2 |
| `IQH_Constant_UnassignedAlertThreshold` | Constant | Alert threshold for panel 7 |
| `IQH_Constant_WorkloadAlertThreshold` | Constant | Row alert threshold for panel 3 |
| `IQH_Constant_SLATargetHours` | Constant | First-response SLA window for panel 4 |
| `IQH_Constant_AIOverrideAlertThreshold` | Constant | Override % row alert for panel 8 |

## Acceptance criteria

- [ ] All 8 panels present and populated with live data
- [ ] Dashboard accessible to managers only (not case workers)
- [ ] Date range filter applies to panels 1, 2, 3, 4, 7, 8; panels 5 and 6 are time-fixed
- [ ] Category filter applies to panels 2, 3, 8
- [ ] Case worker filter applies to panel 3
- [ ] Panel 1 KPI card is clickable and navigates to open case list
- [ ] Panel 7 KPI card is clickable and navigates to unassigned case list
- [ ] Panel 4 SLA compliance reads target from `IQH_Constant_SLATargetHours`
- [ ] Panel 3 row highlights amber when Total > `IQH_Constant_WorkloadAlertThreshold`
- [ ] Panel 7 card shows alert styling when count > `IQH_Constant_UnassignedAlertThreshold`
- [ ] Panel 8 row highlights amber when Override% > `IQH_Constant_AIOverrideAlertThreshold`
- [ ] Panel 3 and panel 8 grids have Excel export enabled
- [ ] Dashboard loads within 5 seconds on live data

## Open questions

- **SLA target hours**: what is the first-response SLA in hours? (client input required — will be stored in `IQH_Constant_SLATargetHours` and editable from admin screen)
- **Workload alert threshold**: at what total open cases per worker should the row highlight? (suggest 10 — confirm with client)
- **AI override alert threshold**: above what Override% should a category row highlight? (suggest 25%)
- **Resolution time granularity**: daily or weekly data points on line chart? (daily preferred if case volume supports it)
