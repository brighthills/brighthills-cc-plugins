# User can add a new TODO

**Parent Epic**: TODO Management
**Depends on**: S1 (User can view their TODO list)

## User Story

As a **registered user**,
I want to **add a new TODO with a title and due date**,
so that **I can keep track of things I need to do**.

## Background

Users need a quick way to capture tasks. The add flow should be minimal friction — title is required, due date is optional.

## Acceptance Criteria

### AC1: Successful TODO Creation
**Given** I am logged in and on the "My TODOs" page
**When** I enter "Buy groceries" as title, set due date to tomorrow, and click "Add"
**Then** the new TODO appears in my list with status "Pending"

### AC2: Title is Required
**Given** I am on the "Add TODO" form
**When** I leave the title empty and click "Add"
**Then** I see an error "Title is required" and the TODO is not created

### AC3: Optional Due Date
**Given** I am on the "Add TODO" form
**When** I enter a title but leave due date empty and click "Add"
**Then** the TODO is created with no due date shown

## Technical Notes

### Architecture / Approach

Simple form submission with client-side validation. Server validates and persists.

### Key Interfaces / Types

```
TODO {
  id: string
  title: string
  dueDate: date | null
  status: "pending" | "completed"
  createdAt: datetime
}
```

### Database Changes

- [ ] Migration needed: Yes
- Schema changes: Create `todos` table with id, title, due_date, status, created_at, user_id

## Files to Create/Modify

| File | Action | Description |
|------|--------|-------------|
| `src/components/AddTodoForm` | Create | Form with title input and date picker |
| `src/api/todos` | Create | POST endpoint for creating TODOs |
| `src/db/migrations/create-todos` | Create | Database migration |

## UI/UX Notes

### Design Reference

Inline form at the top of the TODO list — no separate page.

### User Flow

1. User navigates to "My TODOs"
2. User clicks "Add TODO" button
3. Inline form appears with title (required) and due date (optional) fields
4. User fills in fields and clicks "Add"
5. New TODO appears at the top of the list
6. Form resets for the next entry

### Edge Cases

- Empty state: Show "Add your first TODO" prompt
- Error state: Inline validation message below the field
- Loading state: Disable submit button, show spinner

## Definition of Done

- [ ] All ACs implemented
- [ ] Unit tests passing
- [ ] E2E tests passing
- [ ] Code review approved
- [ ] Build successful
- [ ] Documentation updated (if needed)

## Testing Notes

### Unit Tests

- [ ] Form validates empty title
- [ ] Form submits with valid data
- [ ] API returns 201 on success
- [ ] API returns 400 on empty title

### E2E Tests

- [ ] Happy path: add TODO with title and due date
- [ ] Error handling: submit empty form, see validation

## References

- Parent Epic: TODO Management

## Estimate

**Points**: 5 (2-3 days)

---

## Notes

Consider adding keyboard shortcut (Enter to submit) for power users.
