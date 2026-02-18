# Implementation Checklists

Pre-commit, pre-close checklists and error handling reference.

---

## Pre-Implementation Checklist

- [ ] Input source read (ticket fetched / docs read)
- [ ] Context gathered (parent ticket / related docs)
- [ ] Status set to `in-progress` (ticket mode) or noted (docs mode)
- [ ] Feature branch created from default branch
- [ ] TaskList created with implementation steps

---

## Code Review Checklist

- [ ] Code review ran on all changed files
- [ ] Applied all review categories:
  - [ ] DRY Violations checked (duplicated logic, copy-pasted blocks)
  - [ ] SOLID Violations checked (SRP, Open/Closed, Interface Segregation)
  - [ ] Naming Conventions enforced (following project patterns)
  - [ ] Forbidden Patterns flagged (unsafe types, debug statements, anti-patterns)
  - [ ] Type Safety verified (return types, assertions, null checks)
- [ ] Simplified code preserves all functionality
- [ ] Phase 3.5 completed BEFORE Phase 4

---

## Quality Checklist

- [ ] Type checking passes
- [ ] Linting passes
- [ ] Unit tests pass
- [ ] Build succeeds

---

## E2E Checklist

### All Tickets (BLOCKING)

- [ ] Smoke E2E passes
- [ ] IF FAIL → Fix first, don't proceed!

### Story/Feature Only (BLOCKING)

- [ ] QA agent ran (or manual E2E written)
- [ ] E2E test file exists following project conventions
- [ ] E2E tests pass
- [ ] IF FAIL → Stop, fix tests!

---

## Pre-Close Checklist

### Task

- [ ] Implementation complete
- [ ] Tests passing
- [ ] Smoke E2E passing
- [ ] Implementation documented

### Story

- [ ] All items above
- [ ] **Child Tasks listed**
- [ ] **ALL child Tasks closed FIRST**
- [ ] Full E2E tests created and passing
- [ ] Version bumped (if project uses package.json versioning)

### Epic

- [ ] All child Stories closed
- [ ] Feature documentation complete

### Docs-Based Feature

- [ ] Implementation complete
- [ ] Tests passing
- [ ] Smoke E2E passing
- [ ] Git commit created with summary

---

## Completion Checklist

- [ ] Implementation solution documented
- [ ] Visible Changes documented (WHERE + WHAT TO SEE + EXPECTED BEHAVIOR)
- [ ] Summary generated
- [ ] Summary appended to ticket (ticket mode) or included in commit (docs mode)
- [ ] Ticket closed with details (ticket mode)
- [ ] Hierarchy updated — propagate to parent (ticket mode)
- [ ] Version bumped — Story only (ticket mode)
- [ ] Git commit created
- [ ] Background processes killed

---

## Error Handling

| Error | Action |
|-------|--------|
| Test fails | Fix, retry, DON'T close |
| Build fails | Fix, retry, DON'T commit |
| **Smoke E2E fails** | **Fix smoke tests FIRST** |
| E2E missing (Story/feature) | Run QA agent or write E2E first |
| **Child Tasks open** | **Close ALL child Tasks FIRST** (ticket mode) |
| Partial implementation | Create follow-up issue/task |

---

## Status Flow Reference

```
Backlog → In Progress → Review → Done
    ↓          ↓           ↓
  Start     Working    QA Phase   Closed
```

**Propagation (ticket mode):**
- `In Progress` → Propagates UP immediately
- `Done/Close` → Only when ALL children closed
