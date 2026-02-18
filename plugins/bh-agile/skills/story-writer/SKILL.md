---
name: story-writer
description: Create professional Agile Epics, Stories, and Tasks with proper structure. Use when the user asks to "create epic", "write story", "add user story", "define acceptance criteria", "plan feature". Provides templates and best practices following vertical slice principles.
---

# Story Writer Skill

Expert skill for writing professional Agile Epics, Stories, and Tasks with proper structure, Acceptance Criteria, and Definition of Done.

## When to Activate

- User asks to "create an epic" or "plan a feature"
- User asks to "write a story" or "user story"
- User asks for "acceptance criteria"
- When breaking down features into deliverable units

## Core Principles

### 1. Vertical Slice Approach

Every Story must be a **self-contained vertical slice** — see `references/vertical-slice.md` for details.

```
✅ GOOD: "User can view their TODO list"
   - Backend: API endpoint
   - Frontend: List component
   - Tests: Unit + E2E

❌ BAD: "Implement TODO database schema"
   - Only data layer
   - No user-facing deliverable
```

### 2. INVEST Criteria for Stories

| Criterion | Description |
|-----------|-------------|
| **I**ndependent | Can be developed separately |
| **N**egotiable | Details can be discussed |
| **V**aluable | Delivers user value |
| **E**stimable | Can estimate effort |
| **S**mall | Fits in one sprint |
| **T**estable | Has clear AC |

### 3. Acceptance Criteria Format (Given-When-Then)

See `references/acceptance-criteria.md` for full guide and examples.

```markdown
### AC1: [Descriptive Name]
**Given** [initial context or precondition]
**When** [action is performed by user or system]
**Then** [expected outcome or result]
```

## Templates and Examples

Templates are located in the `templates/` directory. Each has a matching filled-out example in `templates/examples/` using a TODO management app as the sample project.

| Template | Example |
|----------|---------|
| `templates/epic.md` | `templates/examples/epic-example.md` |
| `templates/story.md` | `templates/examples/story-example.md` |
| `templates/task.md` | `templates/examples/task-example.md` |

Use the template as structure, refer to the example to see how it should be filled out.

### Quick Reference

**User Story Format:**
```
As a [role],
I want to [capability],
so that [benefit].
```

**Example:**
```
As a busy professional,
I want to mark a TODO as complete,
so that I can track my progress.
```

**AC Format (Given-When-Then):**
```
Given [context]
When [action]
Then [outcome]
```

## Writing Guidelines

### User Story Roles

Adapt roles to the project context. Common examples:
- authenticated user
- admin
- guest / visitor
- domain-specific roles (identify from project context)

**Example roles for a TODO app:**
- registered user
- team member
- workspace admin

### Good vs Bad AC

**Good:**
```markdown
### AC1: TODO List Display
**Given** I am logged in and have 3 pending TODOs
**When** I navigate to "My TODOs"
**Then** I see all 3 TODOs with their title, due date, and priority
**And** they are sorted by due date ascending
```

**Bad:**
```markdown
### AC1: TODOs Work
The TODO page should display TODOs properly.
```

### Breaking Down Stories

When a Story is too large, split by:
1. **User Flow**: Different paths through the feature
2. **CRUD Operations**: Create, Read, Update, Delete separately
3. **User Roles**: Different user types
4. **Data Variations**: Different states or types

**Example — "TODO Management" is too big, split into:**
- User can view their TODO list (Read)
- User can add a new TODO (Create)
- User can edit a TODO title and due date (Update)
- User can mark a TODO as complete (Update — status)
- User can delete a TODO (Delete)

## References

- `references/acceptance-criteria.md` - AC format guide with examples
- `references/vertical-slice.md` - Vertical slice architecture guide
