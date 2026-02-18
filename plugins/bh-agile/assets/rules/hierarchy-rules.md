# Ticket Hierarchy Rules

Rules for managing Epic → Story → Task hierarchy in GitHub Issues.

---

## Hierarchy Structure

```
Epic #12 (Feature)
  └── Story #45 (Vertical Slice)
        └── Task #67 (Implementation Unit)
```

---

## Closing Order (MANDATORY) ⚠️

| Order | Type | Rule |
|-------|------|------|
| 1st | **Task** | Close when implementation complete |
| 2nd | **Story** | ONLY when ALL child Tasks closed |
| 3rd | **Epic** | ONLY when ALL child Stories closed |

**NEVER close a parent with open children!**

---

## Status Propagation

### Upward Propagation

| Status | Direction | Condition |
|--------|-----------|-----------|
| `In Progress` | ↑ Immediate | Any child starts → Parent starts |
| `Done/Closed` | ↑ Conditional | ALL children closed → Parent can close |

### Examples

```
Task #67 → In Progress
  → Story #45 → In Progress (auto)
    → Epic #12 → In Progress (auto)

Task #67 → Closed
Task #68 → Closed (last child)
  → Story #45 can now close
    → Epic #12 still open (other Stories exist)
```

---

## Pre-Close Validation

### Before Closing Story

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "List all child Tasks of issue #XX with status (open/closed)" })
```

**IF any child Tasks OPEN:**
1. ❌ STOP - Cannot close Story
2. Close each open Task first
3. Verify all Tasks closed
4. Then close Story

### Before Closing Epic

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "List all child Stories of Epic #XX with status" })
```

---

## Agent Commands

### Check Children

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "List children of #XX with status" })
```

### Close with Propagation

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Close #XX. If ALL siblings closed, close parent too." })
```

### Batch Close Children

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Close Tasks #67, #68, #69 as 'Part of Story #45'" })
```

---

## Common Mistakes

| Mistake | Consequence | Fix |
|---------|-------------|-----|
| Close Story with open Tasks | Incomplete feature | Close Tasks first |
| Skip hierarchy check | Orphan tickets | Always verify children |
| Force close parent | Broken tracking | Follow closing order |

---

## Labels

Hierarchy is tracked via labels:

- `type:epic` - Feature-level container
- `type:story` - Vertical slice (deliverable)
- `type:task` - Implementation unit

Status labels:

- `status:backlog` - Not started
- `status:in-progress` - Being worked on
- `status:review` - In QA/review
- `status:done` - Completed (removed on close)
