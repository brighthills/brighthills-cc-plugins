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

**CRITICAL**: This phase is where ALL ticket content is written. You (running on opus) write every ticket body here using the story-writer skill's templates and quality standards. The ticket-manager agent in Phase 5 receives finished text — it does NOT write content.

### 3.1 Write Content Using Story Writer

Apply `/bh-agile:story-writer` templates, AC format (Given/When/Then), INVEST criteria, and vertical slice principles to write the **complete markdown body** for every ticket.

### 3.2 Source Documentation References

When working from documentation (`@` path), the **docs are the source of truth** for requirements, architecture, and design decisions. But **implementation always starts from the ticket** — a developer picks up a ticket and works from there.

This means every ticket must be **self-contained enough to start work**, while pointing back to docs for full details. The ticket body must:
1. Contain all key information inline (goals, AC, technical notes, relevant data models, API contracts)
2. Reference the specific doc files and sections for deeper context
3. **Require the implementer to read the referenced docs** before starting work

Each ticket must contain:

```markdown
## Source Documentation

> **Before starting implementation, read the referenced documents below.** The ticket summarizes key requirements, but the docs contain full architectural decisions, data models, and design rationale that are essential for correct implementation.

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
- **Inline key details** — do not just say "see architecture.md"; summarize the relevant data model, API shape, or design decision in the ticket, then reference the doc for full context

### 3.3 Write Epic Body

Write the **complete markdown body** for the Epic:
- **Overview** — Problem description
- **Source Documentation** — Full reference table to all feature docs (see 3.2)
- **Goals** — Measurable objectives
- **Out of Scope** — What we won't do
- **Stories table** — Title, points, dependencies (placeholder numbers, updated in Phase 5.4)
- **Implementation Order** — Phased breakdown with dependency graph

Store the finished Epic body — it will be passed verbatim to the ticket-manager in Phase 5.

### 3.4 Write Story Bodies

For each vertical slice, write the **complete markdown body**:
- **User Story** — As a [role], I want [action], so that [benefit]
- **Acceptance Criteria** — Given/When/Then format (3-5 per Story)
- **Source Documentation** — Relevant docs and sections for this slice (see 3.2), with "Before starting" instruction
- **Technical Notes** — Key interfaces, schema changes, integration points. **Inline the relevant details** from the docs: data model fields, API endpoints/contracts, component hierarchy. The developer should understand *what* to build from the ticket alone — the docs provide the *why* and full context.
- **Files to Create/Modify** — Affected files list
- **Estimate** — Story points

Store each finished Story body — they will be passed verbatim to the ticket-manager in Phase 5.

### 3.5 Write Task Bodies (Optional)

For each Story, optionally write **complete markdown bodies** for Tasks:
- Completable in 1-4 hours
- Independently testable
- Clearly scoped
- **Source Documentation** — Relevant docs and sections for this task (see 3.2), with "Before starting" instruction
- **Implementation Details** — Inline the specific technical details from docs that this task needs (e.g. exact schema fields, API request/response shape, component props)

Typical Task types: schema/data, backend logic, UI components, tests, integration.

### 3.6 Self-Check Before Proceeding

Before moving to Phase 4, verify every drafted body against the story-writer quality bar:

| Check | Requirement |
|-------|-------------|
| User Story format | "As a [role], I want..., so that..." present on every Story |
| Acceptance Criteria | 3-5 Given/When/Then ACs per Story |
| Source Documentation | Every ticket references relevant docs with specific sections |
| "Before starting" instruction | Every ticket with doc refs includes the read-docs-first instruction |
| Key details inlined | Technical notes contain actual data models, API shapes, not just "see docs" |
| Vertical slice | Each Story delivers user-facing value end-to-end |
| Task granularity | Each Task completable in 1-4 hours |

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

**The ticket-manager agent is a CRUD tool.** Pass it finished content — do not ask it to write, rephrase, or generate anything. Every `Body:` below must contain the exact markdown written in Phase 3.

### 5.0 Set Up Task Tracking

Create tasks with dependencies to enforce the correct order:

```
TaskCreate({ subject: "Create Epic in issue tracker",
  description: "Create the Epic issue with the body drafted in Phase 3.",
  activeForm: "Creating Epic issue" })                                    → task A

TaskCreate({ subject: "Create Stories and link to Epic",
  description: "Create all Story issues, link each as sub-issue to Epic.",
  activeForm: "Creating Story issues" })                                  → task B
TaskUpdate({ taskId: B, addBlockedBy: [A] })

TaskCreate({ subject: "Create Tasks and link to Stories",
  description: "Create all Task issues, link each as sub-issue to its Story.",
  activeForm: "Creating Task issues" })                                   → task C
TaskUpdate({ taskId: C, addBlockedBy: [B] })

TaskCreate({ subject: "Update Epic with final issue numbers",
  description: "Replace placeholder numbers in Epic body with actual issue numbers.",
  activeForm: "Updating Epic with final numbers" })                       → task D
TaskUpdate({ taskId: D, addBlockedBy: [C] })

TaskCreate({ subject: "Verify hierarchy and links",
  description: "Verify all sub-issue links exist and labels are correct.",
  activeForm: "Verifying ticket hierarchy" })                             → task E
TaskUpdate({ taskId: E, addBlockedBy: [D] })
```

### 5.1 Create Epic (task A)

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Create issue with EXACTLY this content. Do not modify the body.
    Title: [Epic Title]
    Labels: type:epic, status:backlog
    Body:
    ---
    [paste the complete Epic markdown from Phase 3 verbatim]
    ---
    Return the issue number." })
```

Save the returned Epic number — needed for Story linking.

### 5.2 Create Stories (task B)

For each Story, create the issue and **immediately link** it to the Epic:

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Do these two steps:
    1. Create issue with EXACTLY this content. Do not modify the body.
       Title: [Story Title]
       Labels: type:story, status:backlog, points:X
       Body:
       ---
       [paste the complete Story markdown from Phase 3 verbatim]
       ---
    2. Link the created issue as sub-issue to Epic #XX.
    Return the issue number." })
```

### 5.3 Create Tasks (task C)

For each Task, create the issue and **immediately link** it to its Story:

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Do these two steps:
    1. Create issue with EXACTLY this content. Do not modify the body.
       Title: [Task Title]
       Labels: type:task, status:backlog, estimate:X
       Body:
       ---
       [paste the complete Task markdown from Phase 3 verbatim]
       ---
    2. Link the created issue as sub-issue to Story #YY.
    Return the issue number." })
```

### 5.4 Update Epic with Final Numbers (task D)

After all tickets are created, update the Epic body with actual issue numbers:

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Update Epic #XX body:
    - Replace placeholder Story numbers with actual issue numbers
    - Update Implementation Order with correct references
    - Update Dependency Graph with actual numbers" })
```

---

## Phase 6: Verify & Report (task E)

### 6.1 Verify Hierarchy

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Verify the ticket hierarchy for Epic #XX. Run these checks:

    1. EPIC SUB-ISSUES: Run gh api repos/OWNER/REPO/issues/XX/sub_issues --jq '.[].number'
       Expected Story numbers: #AA, #BB, #CC, ...
       Report: found N of M expected.

    2. STORY SUB-ISSUES: For each Story, run gh api repos/OWNER/REPO/issues/STORY/sub_issues --jq '.[].number'
       Report found vs expected Task count per Story.

    3. LABELS: For each issue, verify type:* and status:backlog labels exist.

    4. FIX MISSING LINKS: If any sub-issue link is missing, link it now.

    Return a verification report with pass/fail per check." })
```

**Do not skip this step.** The ticket-manager must run the actual API calls and report concrete numbers — not just confirm from memory.

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
