# Documentation Templates

Generate feature documentation in `docs/features/[feature-slug]/`.

## Directory Structure

Generate docs based on the planning focus:

```
docs/features/[feature-slug]/
├── README.md              # Always: overview, goals, scope, decisions
├── architecture.md        # Full-stack, Architecture, Backend only
├── ux-spec.md             # Full-stack, UX/Design
├── api-spec.md            # Backend only (API contracts and schemas)
└── TASK-LIST.json         # Optional: pre-planned implementation tasks
```

Only generate the files relevant to the selected focus.

## README.md

```markdown
# [Feature Name]

## Overview
[Problem statement and solution summary from Discovery]

## Goals
- [Goal 1 — measurable]
- [Goal 2 — measurable]
- [Goal 3 — measurable]

## Scope

### In Scope
- [Item 1]
- [Item 2]

### Out of Scope
- [Item 1]
- [Item 2]

## User Roles
- **[Role 1]** — [How they interact with this feature]
- **[Role 2]** — [How they interact with this feature]

## Key Decisions
| Decision | Choice | Rationale |
|----------|--------|-----------|
| [Decision 1] | [Choice] | [Why] |

## Expert Insights
[Key findings from each team member, adapted to the planning focus]

## Dependencies
- [Dependency 1]
- [Dependency 2]

## Success Metrics
- [Metric 1]
- [Metric 2]
```

## architecture.md (Full-stack / Architecture / Backend only)

```markdown
# [Feature Name] — Architecture

## System Design
[High-level architecture description]

## Data Model
[Schema changes, new entities, relationships]

## API Design
[Endpoints, request/response formats]

## Integration Points
[How this connects to existing systems]

## Security Considerations
[Auth, authorization, data protection]
```

## ux-spec.md (Full-stack / UX/Design)

```markdown
# [Feature Name] — UX Specification

## User Flow
[Step-by-step user journey]

## Screens / States
### [Screen 1]
- Entry: [How user arrives]
- Content: [What they see]
- Actions: [What they can do]
- Exit: [Where they go next]

## Error States
- [Error 1]: [How it's handled]

## Accessibility
- [A11y consideration 1]
- [A11y consideration 2]

## Responsive Behavior
- Desktop: [Layout]
- Mobile: [Layout]
```

## api-spec.md (Backend only)

```markdown
# [Feature Name] — API Specification

## Endpoints

### [Method] /api/[resource]
- **Description**: [What this endpoint does]
- **Auth**: [Required auth level]
- **Request**: [Body/params schema]
- **Response**: [Response schema]
- **Errors**: [Error codes and meanings]

## Data Models
[New or modified entities and their schemas]

## Error Handling
[Standard error format and codes]

## Versioning
[API versioning strategy]
```
