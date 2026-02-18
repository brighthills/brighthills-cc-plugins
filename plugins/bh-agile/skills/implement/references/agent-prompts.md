# Standard Agent Prompts

Pre-defined prompts for common agent operations during implementation.

---

## agile-ticket-manager Prompts

### Get Ticket Details

```
Get full details for [#XX] including:
- Title and description
- Acceptance Criteria (if Story)
- Parent relationship
- Current status and labels
- Child issues (if Epic or Story)
```

### Set Status to In Progress

```
Set [#XX] to In Progress:
1. Add in-progress status label
2. Remove backlog status label
3. Propagate to parent (Story → In Progress if not already)
4. Propagate to grandparent Epic if applicable
```

### Set Status to Review

```
Set [#XX] to Review:
1. Add review status label
2. Remove in-progress status label
3. Do NOT propagate — parent stays In Progress
```

### Close Ticket as Completed

```
Close [#XX] as completed:
1. Close the issue with completion state
2. Remove all status labels
3. Check if all sibling Tasks are closed
4. If yes, close parent Story
5. Check if all sibling Stories are closed
6. If yes, close parent Epic
```

### List Children with Status

```
List all child issues of [#XX] with their current status.
Report: issue number, title, type (Task/Story), status.
Flag any that are still open.
```

---

## qa-tester Prompts

### Create E2E Tests from Requirements

```
Create E2E tests for [#XX or feature]:

Requirements source:
{AC from ticket or docs specification}

Instructions:
1. Create test file following project conventions
2. One test per acceptance criterion
3. Use existing test helpers if available
4. Test both happy path and edge cases
5. Run tests and report results
```

### Run E2E and Report

```
Run E2E tests for [#XX or feature]:
1. Execute test command
2. Report results:
   - Passed tests
   - Failed tests with error details
   - Screenshots if failures
3. Suggest fixes for any failures
```

---

## code-simplifier Prompts

### Review and Simplify

```
Review and simplify the recently modified code:

Apply ALL code-review categories:
1. DRY Violations — Find duplicated logic, patterns that could be abstracted
2. SOLID Violations — SRP (oversized files/functions), Open/Closed, Interface Segregation
3. Naming Conventions — Follow project's established patterns
4. Forbidden Patterns — Unsafe types, debug statements, anti-patterns
5. Type Safety — Missing return types, implicit any, unsafe assertions

Focus on clarity, consistency, and maintainability while preserving all functionality.
```

---

## product-ux-designer Prompts

### Design User Flow

```
Design user flow for: {feature description}

Consider:
1. Entry points (how user gets here)
2. Main flow steps
3. Error states
4. Success states
5. Edge cases

Deliverables:
- Flow diagram description
- Key screens/states
- Interaction notes
```

### Review UI Implementation

```
Review UI implementation for [#XX or feature]:

Check against:
1. Accessibility
2. Responsive design
3. Loading states
4. Error handling
5. Consistency with design system

Provide:
- Issues found
- Improvement suggestions
- Approval or rejection
```

---

## Coordination Patterns

### Full Implementation Flow (Ticket Mode)

```
1. agile-ticket-manager: "Get details for [#XX]"
2. agile-ticket-manager: "Set [#XX] to In Progress"
3. [Implementation]
4. agile-ticket-manager: "Set [#XX] to Review"
5. qa-tester: "Create E2E tests for [#XX]"
6. [Run tests]
7. agile-ticket-manager: "Close [#XX] as completed"
```

### Full Implementation Flow (Docs Mode)

```
1. Read all docs in @docs/features/<feature>/
2. [Implementation]
3. qa-tester: "Create E2E tests for feature"
4. [Run tests]
5. Git commit with summary
```
