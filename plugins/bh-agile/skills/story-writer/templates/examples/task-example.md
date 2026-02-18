# Implement "Add TODO" API endpoint

**Type:** feature
**Parent Story**: User can add a new TODO (S2)

## Description

Create a POST endpoint that accepts a TODO title and optional due date, validates input, saves to database, and returns the created TODO.

## Technical Approach

### Implementation Steps

1. Define request/response types for the endpoint
2. Add input validation (title required, max 200 chars; due date optional, valid format)
3. Implement the endpoint handler with DB insert
4. Add unit tests for validation and handler

### Files to Modify

| File | Change Type | Description |
|------|-------------|-------------|
| `src/api/todos/route` | Create | POST handler |
| `src/api/todos/validation` | Create | Input validation schema |
| `tests/api/todos.test` | Create | Unit tests |

### Code Examples

```
POST /api/todos
Body: { "title": "Buy groceries", "dueDate": "2026-02-15" }
Response 201: { "id": "abc123", "title": "Buy groceries", "dueDate": "2026-02-15", "status": "pending" }
Response 400: { "error": "Title is required" }
```

## Acceptance Criteria

From parent Story AC that this Task addresses:

- [ ] AC1: Successful TODO Creation (server-side)
- [ ] AC2: Title is Required (validation)
- [ ] AC3: Optional Due Date (nullable field)

## Dependencies

- [ ] Database migration for `todos` table must be applied

## Testing Notes

### Unit Tests Required

- [ ] Test: Returns 201 with valid title and due date
- [ ] Test: Returns 201 with valid title and no due date
- [ ] Test: Returns 400 when title is empty
- [ ] Test: Returns 400 when title exceeds 200 characters
- [ ] Test: Returns 400 when due date format is invalid

### Edge Cases to Consider

- Case 1: Title with only whitespace — should be rejected
- Case 2: Due date in the past — accept (user may log completed tasks)

## References

- Parent Story: User can add a new TODO (S2)

## Estimate

| Aspect | Estimate |
|--------|----------|
| Complexity | S |
| Risk | Low |

---

## Notes

Keep the endpoint simple — no labels, priorities, or categories in this task.
