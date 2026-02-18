# Acceptance Criteria Reference

## Format: Given-When-Then

```gherkin
Given [precondition/context]
When [action/trigger]
Then [expected outcome]
And [additional outcome] (optional)
```

## Examples by Type

All examples use a TODO management app for illustration.

### Happy Path
```markdown
### AC1: Successful TODO Creation
**Given** I am logged in
**When** I enter "Buy groceries" as title, set due date to tomorrow, and click "Add TODO"
**Then** the new TODO appears at the top of my list with status "Pending"
```

### Error Handling
```markdown
### AC2: Validation Error on Empty Title
**Given** I am on the "Add TODO" form
**When** I leave the title field empty and click "Add TODO"
**Then** I see an error message "Title is required"
**And** the TODO is not created
```

### Edge Cases
```markdown
### AC3: Empty State
**Given** I am a new user with no TODOs
**When** I navigate to "My TODOs"
**Then** I see an empty state message "No TODOs yet" with an "Add your first TODO" button
```

### State Transitions
```markdown
### AC4: Mark TODO as Complete
**Given** I have a pending TODO "Buy groceries"
**When** I click the checkbox next to "Buy groceries"
**Then** the TODO status changes to "Completed"
**And** it moves to the "Completed" section with a strikethrough style
```

### Filtering / Sorting
```markdown
### AC5: Filter by Status
**Given** I have 3 pending and 2 completed TODOs
**When** I select the "Pending" filter
**Then** I see only the 3 pending TODOs
**And** the completed TODOs are hidden
```

## Anti-Patterns

| Bad | Good |
|-----|------|
| "TODOs should work" | Specific Given-When-Then |
| "Store in PostgreSQL" | "TODO persists after page refresh" |
| "CRUD operations" | Separate AC per operation |
| "Page loads fast" | "TODO list visible within 2 seconds" |
| "Handle errors" | "Error message shown when title is empty" |

## Checklist

- [ ] Uses Given-When-Then format
- [ ] One scenario per AC
- [ ] Describes behavior, not implementation
- [ ] Is testable
- [ ] Covers success and failure paths
