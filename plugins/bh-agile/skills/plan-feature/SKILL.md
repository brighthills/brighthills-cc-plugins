---
name: plan-feature
description: Plan a new feature through service design discovery and expert consultation. Generates feature documentation in docs/features/. Triggers: "plan feature", "design feature", "plan new feature", "/plan-feature".
argument-hint: <feature-description> (e.g., "user authentication system")
allowed-tools:
  - Task
  - TeamCreate
  - TeamDelete
  - SendMessage
  - TaskCreate
  - TaskUpdate
  - TaskList
  - AskUserQuestion
  - Read
  - Write
  - Glob
  - Grep
model: opus
---

# Plan Feature

Plans a new feature through interactive service design discovery, expert agent consultation, and structured documentation generation.

## Arguments

- `$ARGUMENTS` — Feature description or name (required)
- Example: `/plan-feature "user authentication system"`
- Example: `/plan-feature "notification preferences"`

## Context

- Date: !`date +%Y-%m-%d`
- Branch: !`git branch --show-current 2>/dev/null || echo "not a git repo"`

---

## Workflow

```
PHASE 1: DISCOVERY         → Interactive exploration with service design methods
PHASE 2: EXPERT CONSULT    → Contract-driven agent team with coordinated parallel work
PHASE 3: DOCUMENTATION     → Generate docs/features/[feature]/ output
PHASE 4: USER APPROVAL     → Review documentation, refine if needed
```

---

## Phase 1: Discovery

Interactive exploration using service design methodology. The goal is to understand the problem space before jumping to solutions.

### 1.1 Problem Framing

```
AskUserQuestion({
  question: "What problem does this feature solve?",
  header: "Problem",
  options: [
    { label: "User need", description: "Users are requesting or struggling with something" },
    { label: "Business goal", description: "Revenue, growth, or operational improvement" },
    { label: "Technical debt", description: "Architecture improvement or modernization" }
  ]
})
```

### 1.2 User Journey Mapping

Identify the key actors and their journeys:

```
AskUserQuestion({
  question: "Who are the primary users of this feature?",
  header: "Users",
  options: [
    { label: "End users", description: "People using the product directly" },
    { label: "Administrators", description: "People managing or configuring the system" },
    { label: "Both", description: "Multiple user roles involved" },
    { label: "System/API", description: "Primarily consumed by other systems" }
  ]
})
```

Map the user journey:
- **Entry point** — How does the user arrive at this feature?
- **Core flow** — What are the main steps?
- **Success state** — What does "done" look like?
- **Error states** — What can go wrong?
- **Edge cases** — Unusual but valid scenarios

### 1.3 Scope Definition

```
AskUserQuestion({
  question: "What is the scope for this feature?",
  header: "Scope",
  options: [
    { label: "MVP", description: "Minimum viable — core functionality only" },
    { label: "Full feature", description: "Complete feature with all planned capabilities" },
    { label: "Phased", description: "MVP first, then iterate with additional phases" }
  ]
})
```

### 1.4 Planning Focus

```
AskUserQuestion({
  question: "What should the planning focus on?",
  header: "Focus",
  options: [
    { label: "Full-stack (Recommended)", description: "End-to-end: UX, UI, architecture, and backend" },
    { label: "UX/Design", description: "User experience, interface design, and interactions" },
    { label: "Architecture", description: "System design, data model, API, and infrastructure" },
    { label: "Backend only", description: "Server-side logic, APIs, data, and integrations" }
  ]
})
```

### 1.5 Context Gathering

Read project context to inform the planning:

- **CLAUDE.md / README.md** — Project conventions, tech stack, architecture
- **Settings file** (e.g., `bh-agile.local.md`) — Project-specific configuration if available
- **Existing features** — Similar patterns already implemented in the codebase

```
Task({
  subagent_type: "feature-dev:code-explorer",
  prompt: "Analyze the codebase for patterns related to '$ARGUMENTS'. Find:
    - Similar features already implemented
    - Architectural patterns and conventions
    - Tech stack and key dependencies
    - Relevant file structure"
})
```

---

## Phase 2: Expert Consultation

Contract-driven expert consultation. The lead defines shared agreements **before** spawning agents, so all experts work in parallel against the same definitions without diverging.

### Core Principle: Discover Before Design

**Never assume — always discover.** Every expert must gather facts and validate assumptions before producing deliverables. The user makes all planning decisions, not the agents.

- **Research first** — Before designing, investigate the codebase, existing patterns, and constraints. No deliverable should be based on an assumption when the answer is discoverable.
- **Surface unknowns to the user** — When an expert encounters a trade-off, ambiguity, or choice between valid approaches: do NOT pick one silently. Formulate the question, present options with trade-offs, and message the lead. The lead escalates to the user via AskUserQuestion.
- **No implicit defaults** — If something wasn't covered in Discovery, flag it as an open question. "Reasonable defaults" are assumptions in disguise.

**The lead enforces this** by rejecting deliverables that contain unjustified assumptions, and escalating all unresolved design decisions to the user.

### 2.1 Complexity & Team Selection

Ask the user about complexity. Based on the **Planning Focus** (from 1.4) and complexity, suggest the appropriate team.

```
AskUserQuestion({
  question: "How complex is this feature? This determines how many experts to consult.",
  header: "Complexity",
  options: [
    { label: "Simple", description: "2 experts — see team below" },
    { label: "Medium (Recommended)", description: "3 experts — see team below" },
    { label: "Complex", description: "4 experts — see team below" }
  ]
})
```

See **references/team-selection.md** for the Focus × Complexity composition table.

### 2.2 Define Planning Contracts

See **references/contracts.md** for the full contract definition process:
1. Map the contract chain for the selected focus
2. Author shared terminology, scope boundaries, deliverable formats, and interface contracts
3. Identify cross-cutting concerns and assign ownership
4. Verify with the contract quality checklist

### 2.3 Create Team

```
TeamCreate({
  team_name: "plan-[feature-slug]",
  description: "Expert consultation for [feature name]"
})
```

### 2.4 Create Tasks

Create one task per selected expert using TaskCreate. Adapt to the selected team composition.

### 2.5 Spawn Teammates

Launch all selected teammates **in a single message** so they start in parallel. Each receives:
- Full Discovery context from Phase 1
- The planning contracts relevant to their role (what they produce, what they consume)
- Cross-cutting concerns they own
- Their assigned task and deliverable expectations

Use the base structure from **references/agent-prompt-template.md** and select agents from **references/agents.md**. Include the authored contracts from 2.2 in each agent's prompt.

### 2.6 Facilitate & Verify

See **references/facilitation.md** for the full facilitation process:
- Active coordination during expert work (relay contract changes, unblock, track progress)
- Pre-completion contract verification
- Cross-review matrix by focus
- Collect results and shutdown

### 2.7 Synthesize Expert Input

See **references/facilitation.md § Synthesize Expert Input** for synthesis approach. Present the synthesis to the user before moving to documentation.

---

## Phase 3: Documentation

Generate feature documentation using templates from **references/doc-templates.md**. Only generate files relevant to the selected planning focus.

---

## Phase 4: User Approval

Present the generated documentation for review:

```
AskUserQuestion({
  question: "I've generated the feature documentation. Please review and let me know how to proceed.",
  header: "Review",
  options: [
    { label: "Looks good", description: "Approve documentation as-is" },
    { label: "Needs changes", description: "I want to modify some parts" },
    { label: "Start over", description: "Let's rethink the approach" }
  ]
})
```

If approved, suggest next steps:

```markdown
## Feature Planning Complete

Documentation generated in `docs/features/[feature-slug]/`.

### Next Steps
1. **Create tickets**: Run `/create-tickets @docs/features/[feature-slug]/`
2. **Start implementing**: Run `/implement @docs/features/[feature-slug]/`
3. **Review with team**: Share the docs for team feedback first
```

---

## Error Handling

| Scenario | Action |
|----------|--------|
| No feature description | Ask user to describe the feature |
| Project context missing | Ask user about tech stack, conventions |
| Expert agents unavailable | Fall back to manual analysis |
| Feature too large | Propose splitting into multiple features |
| Contract deviation requested | Evaluate impact, update contract, notify affected experts |
| Cross-review finds mismatch | Send expert back to fix specific violations |
| Experts use conflicting terminology | Refer back to Shared Definitions, correct the deviator |
| Conflicting expert opinions | Present options to user for decision |

---

## Reference

- **Create Tickets**: `/bh-agile:create-tickets` for ticket creation from docs (downstream)
- **Implement**: `/bh-agile:implement @docs/...` for docs-based implementation (downstream)
- **Story Writer**: `/bh-agile:story-writer` for ticket content templates
