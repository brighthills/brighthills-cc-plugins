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
PHASE 2: EXPERT CONSULT    → Agent team with inter-agent communication
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

### 1.4 Context Gathering

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

Create an agent team where experts work in parallel and can communicate with each other. Each expert receives the Discovery context and can message other team members to align on cross-cutting concerns.

```
AskUserQuestion({
  question: "How complex is this feature? This determines how many experts to consult.",
  header: "Complexity",
  options: [
    { label: "Simple", description: "2 experts: Product designer + UI expert" },
    { label: "Medium (Recommended)", description: "3 experts: + Domain expert" },
    { label: "Complex", description: "4 experts: + Target persona simulation" }
  ]
})
```

### 2.1 Create Team

```
TeamCreate({
  team_name: "plan-[feature-slug]",
  description: "Expert consultation for [feature name]"
})
```

### 2.2 Create Tasks

Create one task per expert using TaskCreate:

| Task | Subject | activeForm |
|------|---------|------------|
| 1 | UX design for [feature] | Designing user experience |
| 2 | UI architecture for [feature] | Designing UI architecture |
| 3 | Domain analysis for [feature] (Medium/Complex) | Analyzing domain requirements |
| 4 | User perspective for [feature] (Complex only) | Evaluating user perspective |

### 2.3 Spawn Teammates

Launch all selected teammates **in a single message** so they start in parallel. Each receives:
- Full Discovery context from Phase 1
- Their assigned task
- Instructions to message other teammates when they have findings relevant to cross-cutting concerns

#### Product Designer — UX & Service Design

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "product-designer",
  prompt: "You are a senior Product & UX Designer on an expert consultation team.

  YOUR TASK: Design the user experience for '[feature]'.

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  TEAM MEMBERS (message them via SendMessage when relevant):
  - ui-expert: UI architecture and component design
  - domain-expert: Industry best practices and technical constraints
  - target-persona: End-user perspective and feedback

  DELIVERABLES:
  1. User flow diagram (text-based)
  2. Key screens/states identification
  3. Interaction patterns and micro-interactions
  4. Error handling UX
  5. Accessibility considerations

  COLLABORATION:
  - Message ui-expert about interaction patterns that affect component design
  - Message domain-expert to validate UX against industry standards
  - Message target-persona to check if flows match user expectations
  - When done, mark your task as completed with TaskUpdate"
})
```

#### UI Expert — Interface Patterns & Components

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "ui-expert",
  prompt: "You are a senior UI Frontend Developer on an expert consultation team.

  YOUR TASK: Design the UI architecture for '[feature]'.

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  TEAM MEMBERS (message them via SendMessage when relevant):
  - product-designer: UX flows and interaction design
  - domain-expert: Technical constraints and best practices
  - target-persona: End-user perspective

  DELIVERABLES:
  1. Component hierarchy
  2. State management approach
  3. Responsive design considerations
  4. Design system alignment
  5. Performance considerations

  COLLABORATION:
  - Message product-designer about component feasibility for proposed interactions
  - Message domain-expert about technical constraints affecting UI decisions
  - When done, mark your task as completed with TaskUpdate"
})
```

#### Domain Expert — Industry Best Practices (Medium/Complex)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "domain-expert",
  prompt: "You are a senior Domain Expert and Software Architect on an expert consultation team.

  YOUR TASK: Provide domain expertise for '[feature]'.

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  TEAM MEMBERS (message them via SendMessage when relevant):
  - product-designer: UX design decisions
  - ui-expert: UI architecture and component design
  - target-persona: End-user needs and expectations

  DELIVERABLES:
  1. Industry best practices for this type of feature
  2. Common pitfalls and how to avoid them
  3. Security considerations
  4. Scalability considerations
  5. Regulatory or compliance requirements (if applicable)

  COLLABORATION:
  - Message product-designer if UX patterns conflict with domain constraints
  - Message ui-expert about technical requirements affecting UI architecture
  - When done, mark your task as completed with TaskUpdate"
})
```

#### Target Persona — End-User Perspective (Complex only)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "target-persona",
  prompt: "You represent the TARGET USER of this product on an expert consultation team.

  YOUR TASK: Evaluate '[feature]' from the end-user's perspective.

  PRODUCT CONTEXT:
  [Full Discovery findings from Phase 1, including project README/CLAUDE.md]

  TEAM MEMBERS (message them via SendMessage when relevant):
  - product-designer: UX design proposals
  - ui-expert: Interface and component proposals
  - domain-expert: Technical and domain constraints

  DELIVERABLES:
  1. Would this solve my problem? Why or why not?
  2. What would confuse me?
  3. What's missing that I'd expect?
  4. How does this compare to similar tools I use?
  5. What would make me love this feature?

  COLLABORATION:
  - Message product-designer with feedback on proposed user flows
  - Message ui-expert if UI patterns feel unintuitive from user perspective
  - When done, mark your task as completed with TaskUpdate"
})
```

### 2.4 Monitor and Collect Results

Wait for all team tasks to be completed (check TaskList periodically). The teammates will communicate with each other during execution via SendMessage — their cross-team discussions refine the output.

Once all tasks are completed:

1. Read each teammate's final deliverables
2. Send shutdown requests to all teammates
3. Delete the team with TeamDelete

### 2.5 Synthesize Expert Input

Compile the team's findings into a unified analysis:
- **Consensus** — Points raised by multiple experts → Core requirements
- **Cross-pollinated insights** — Ideas refined through inter-agent discussion → Strongest recommendations
- **Remaining disagreements** — Unresolved differences → Present as decision points for user
- **Risks** — Concerns raised by any expert → Mitigation strategies

Present the synthesis to the user before moving to documentation.

---

## Phase 3: Documentation

Generate feature documentation in `docs/features/[feature-slug]/`.

### 3.1 Directory Structure

```
docs/features/[feature-slug]/
├── README.md              # Overview, goals, scope, decisions
├── architecture.md        # System design (if complex)
├── ux-spec.md             # User flows, screens, interactions
└── TASK-LIST.json         # Optional: pre-planned implementation tasks
```

### 3.2 README.md

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
- **UX**: [Key finding from product designer]
- **UI**: [Key finding from UI expert]
- **Domain**: [Key finding from domain expert]

## Dependencies
- [Dependency 1]
- [Dependency 2]

## Success Metrics
- [Metric 1]
- [Metric 2]
```

### 3.3 architecture.md (if complex)

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

### 3.4 ux-spec.md

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
| Conflicting expert opinions | Present options to user for decision |

---

## Reference

- **Create Tickets**: `/bh-agile:create-tickets` for ticket creation from docs (downstream)
- **Implement**: `/bh-agile:implement @docs/...` for docs-based implementation (downstream)
- **Story Writer**: `/bh-agile:story-writer` for ticket content templates
