---
name: create-tickets
description: Create Epic, Stories, and Tasks in the issue tracker from feature documentation or structured input. Triggers: "create tickets", "create issues from docs", "plan tickets", "/create-tickets".
argument-hint: <@docs/features/path/> or <feature-description>
allowed-tools:
  - Task
  - AskUserQuestion
  - Read
  - Glob
  - Grep
model: opus
---

# Create Tickets

Creates a complete ticket hierarchy (Epic → Stories → Tasks) in the issue tracker from feature documentation or structured input.

## Arguments

- `$ARGUMENTS` — Path to feature docs directory or feature description
- **From docs**: `/create-tickets @docs/features/user-auth/`
- **From description**: `/create-tickets "notification system"`

## Context

- Date: !`date +%Y-%m-%d`
- Branch: !`git branch --show-current 2>/dev/null || echo "not a git repo"`

---

## Workflow

```
PHASE 1: READ INPUT       → Parse docs or gather description
PHASE 2: ANALYZE           → Identify scope, vertical slices, dependencies
PHASE 3: DRAFT TICKETS     → Write Epic, Stories, Tasks using story-writer
PHASE 4: USER APPROVAL     → Present plan, get confirmation
PHASE 5: CREATE TICKETS    → Create in issue tracker via ticket-manager
PHASE 6: VERIFY & REPORT   → Verify hierarchy, output links
```

---

## Phase 1: Read Input

### From Documentation (`@` path)

Read all files in the specified directory:

```
Read @docs/features/<feature>/
  - README.md — overview, goals, scope
  - Architecture docs — system design, data models
  - UX/UI specs — wireframes, user flows
  - Any structured task lists or implementation notes
```

Extract:
- Feature goals and scope
- User roles involved
- Technical requirements and constraints
- Acceptance criteria (if pre-defined)

**Record the documentation path** — it will be referenced in every ticket (see Phase 3).

### From Description

If no documentation path provided:

```
AskUserQuestion({
  question: "Can you describe the feature in more detail?",
  options: [
    { label: "I'll describe it", description: "Provide a detailed feature description" },
    { label: "Point to docs", description: "I have documentation to reference" }
  ]
})
```

Gather enough context to define the Epic scope.

---

## Phase 2: Analyze

### 2.1 Vertical Slice Validation

Verify that the planned work follows vertical slice principles:

```
CORRECT (Vertical):              WRONG (Horizontal):
- "User can create account"       - "Backend implementation"
- "User can reset password"       - "Frontend implementation"
- "Admin can manage users"        - "Database schema"
```

Each Story must be:
- [ ] Independently deployable
- [ ] Delivering user-facing value
- [ ] NOT just a technical layer
- [ ] Implementable in 1-3 days

If documentation is NOT vertical slice based, propose restructuring and get user approval.

### 2.2 Dependency Mapping

Identify which Stories depend on others:

```
#1 (Foundation — no dependencies)
  ├──> #2 (depends on #1)
  │     └──> #4 (depends on #1, #2)
  └──> #3 (depends on #1)
```

### 2.3 Codebase Analysis (Optional)

If the feature relates to existing code:

```
Task({
  subagent_type: "feature-dev:code-explorer",
  prompt: "Find existing code related to this feature. Look for:
    - Similar patterns already implemented
    - Reusable components and utilities
    - Integration points and conventions"
})
```

---

## Phase 3: Draft Tickets

### 3.1 Activate Story Writer

Use the `/bh-agile:story-writer` skill templates and principles for all ticket content.

### 3.2 Source Documentation References

**CRITICAL**: When working from documentation (`@` path), every ticket MUST include a "Source Documentation" section. Implementation starts from the ticket — all context needed to implement must be reachable from the ticket body.

Each ticket must contain:

```markdown
## Source Documentation

> Feature docs: `docs/features/<feature>/`

| Document | Path | Relevant sections |
|----------|------|-------------------|
| Overview | `docs/features/<feature>/README.md` | Goals, Scope, User Roles |
| Architecture | `docs/features/<feature>/architecture.md` | [specific sections for this ticket] |
| UX Spec | `docs/features/<feature>/ux-spec.md` | [specific sections for this ticket] |
```

**Rules:**
- The Epic references ALL docs in the feature directory
- Each Story references the specific docs and sections relevant to that slice
- Each Task references the specific docs relevant to its scope
- Always use relative paths from the repo root (e.g. `docs/features/auth/README.md`)
- List which sections within each doc are relevant — do not just link the file

### 3.3 Draft Epic

Write the Epic with:
- **Overview** — Problem description
- **Source Documentation** — Full reference table to all feature docs (see 3.2)
- **Goals** — Measurable objectives
- **Out of Scope** — What we won't do
- **Stories table** — Title, points, dependencies
- **Implementation Order** — Phased breakdown with dependency graph

### 3.4 Draft Stories

For each vertical slice, write a Story with:
- **User Story** — As a [role], I want [action], so that [benefit]
- **Acceptance Criteria** — Given/When/Then format (3-5 per Story)
- **Source Documentation** — Relevant docs and sections for this slice (see 3.2)
- **Technical Notes** — Key interfaces, schema changes, integration points
- **Files to Create/Modify** — Affected files list
- **Estimate** — Story points

### 3.5 Draft Tasks (Optional)

For each Story, optionally break into Tasks:
- Completable in 1-4 hours
- Independently testable
- Clearly scoped
- **Source Documentation** — Relevant docs and sections for this task (see 3.2)

Typical Task types: schema/data, backend logic, UI components, tests, integration.

---

## Phase 4: User Approval

Present the complete plan before creating any tickets:

```markdown
## Draft Plan: [Feature Name]

### Epic Overview
[Brief description]

### Proposed Stories
| # | Story | Points | Depends On |
|---|-------|--------|------------|
| 1 | [Story 1] | 3 | - |
| 2 | [Story 2] | 5 | Story 1 |

### Implementation Order
1. Story 1 — [description]
2. Story 2 — [description]

### Dependency Graph
[visual graph]
```

```
AskUserQuestion({
  question: "Does this plan look correct? Should I create the tickets?",
  options: [
    { label: "Yes, create tickets", description: "Proceed with ticket creation" },
    { label: "Modify plan", description: "I want to change something first" },
    { label: "Cancel", description: "Don't create tickets" }
  ]
})
```

**Only proceed to Phase 5 after explicit user approval.**

---

## Phase 5: Create Tickets

### 5.1 Create Epic

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Create Epic issue:
    Title: [Epic Title]
    Body: [Full Epic content including Source Documentation table]
    Labels: type:epic, status:backlog
    Return the Epic's issue number." })
```

### 5.2 Create Stories

For each Story:

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Create Story issue:
    Title: [Story Title]
    Body: [Full Story content with AC and Source Documentation section]
    Labels: type:story, status:backlog, points:X
    Link as sub-issue to Epic #XX.
    Return the Story's issue number." })
```

### 5.3 Create Tasks (if drafted)

For each Task:

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Create Task issue:
    Title: [Task Title]
    Body: [Task content with Source Documentation section]
    Labels: type:task, status:backlog, estimate:X
    Link as sub-issue to Story #YY.
    Return the Task's issue number." })
```

### 5.4 Update Epic with Final Numbers

After all tickets are created, update the Epic with actual issue numbers:

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Update Epic #XX body with:
    - Stories table with actual issue numbers
    - Implementation Order with correct references
    - Dependency Graph with actual numbers" })
```

---

## Phase 6: Verify & Report

### 6.1 Verify Hierarchy

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Verify hierarchy for Epic #XX:
    - All Stories linked as sub-issues
    - All Tasks linked to their Stories
    - Labels correct on all issues" })
```

### 6.2 Output Summary

```markdown
## Tickets Created: [Feature Name]

### Epic
#XX [Title] — [link]

### Stories (X total, Y story points)
| Issue | Story | Points | Depends On |
|-------|-------|--------|------------|
| #AA | [Title] | 3 | - |
| #BB | [Title] | 5 | #AA |

### Suggested Implementation Order
1. **#AA** — [description] (no dependencies)
2. **#BB** — [description] (after #AA)

### Next Steps
- Run `/implement #AA` to start the first Story
- Implement Stories in order (respect dependencies)
```

---

## Error Handling

| Scenario | Action |
|----------|--------|
| Empty input | Ask for feature description or docs path |
| Documentation incomplete | Note gaps, ask user to fill in |
| Feature too large | Propose splitting into multiple Epics |
| Issue tracker unavailable | Output ticket content for manual creation |
| Non-vertical slices in docs | Propose restructuring, get approval |

---

## Reference

- **Story Writer**: `/bh-agile:story-writer` for ticket content templates
- **Ticket Manager**: `agile-ticket-manager` agent for issue tracker operations
- **Plan Feature**: `/bh-agile:plan-feature` for discovery + documentation generation (upstream)
- **Implement**: `/bh-agile:implement` for feature implementation (downstream)
