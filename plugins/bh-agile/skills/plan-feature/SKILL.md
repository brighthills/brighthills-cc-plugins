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

Ask the user about complexity. Based on the **Planning Focus** (from 1.4) and complexity, suggest the appropriate team:

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

**Team composition by Focus × Complexity:**

| Focus | Simple (2) | Medium (3) | Complex (4) |
|-------|-----------|------------|-------------|
| **Full-stack** | Product Designer + UI Expert | + Domain Expert | + Target Persona |
| **UX/Design** | Product Designer + UI Expert | + Target Persona | + Domain Expert |
| **Architecture** | Software Architect + Domain Expert | + Security Analyst | + Performance Engineer |
| **Backend only** | Software Architect + API Designer | + Domain Expert | + Security Analyst |

Present the proposed team to the user and confirm before proceeding.

### 2.2 Define Planning Contracts

Before spawning agents, the lead analyzes the Discovery findings and defines the integration contracts between experts. This focused upfront work is what enables all agents to spawn in parallel without diverging on terminology, scope, or interfaces.

**Why contracts matter for planning:** Without shared definitions, experts will use different terminology for the same concepts, make conflicting assumptions about scope boundaries, and produce deliverables that contradict each other. Contracts prevent this.

#### 2.2.1 Map the Contract Chain

Identify which experts need to agree on shared definitions. The contract chain depends on the planning focus:

**Full-stack:**
```
Product Designer → UI Expert:
  Screen list, interaction patterns, user flow states

Domain Expert → Product Designer + UI Expert:
  Business rules, constraints, regulatory requirements

Target Persona → Product Designer:
  User expectations, mental models, pain points
```

**UX/Design:**
```
Product Designer → UI Expert:
  Screen list, interaction patterns, user flow states, navigation model

Target Persona → Product Designer + UI Expert:
  User expectations, mental models, pain points

Domain Expert → All:
  Constraints affecting UX decisions
```

**Architecture:**
```
Software Architect → Domain Expert:
  System boundaries, component ownership, integration points

Software Architect → Security Analyst:
  Attack surface, data flow, trust boundaries

Domain Expert → Software Architect:
  Business rules that constrain architecture
```

**Backend only:**
```
Software Architect → API Designer:
  Resource model, entity relationships, service boundaries

API Designer → Domain Expert:
  Endpoint structure, data shapes, error taxonomy

Domain Expert → Software Architect + API Designer:
  Business rules, validation rules, domain constraints
```

#### 2.2.2 Author the Contracts

From the Discovery findings, define each integration contract with enough specificity that experts can build to it independently. Contracts should include:

**Shared terminology:**
- Define key domain terms and their exact meanings (e.g., "session" = a single user interaction, "conversation" = a collection of sessions)
- List entity names and their relationships
- Resolve any ambiguous terms from the Discovery phase

**Scope boundaries:**
- Exactly what is in scope for each expert
- What is explicitly out of scope
- Where one expert's responsibility ends and another's begins

**Deliverable format agreements:**
- How user flows should be structured (entry → steps → exit)
- How component hierarchies should be documented
- How API contracts should be specified (exact JSON shapes, not prose)

**Interface contracts (focus-dependent):**

For UX/Design and Full-stack:
```
Product Designer → UI Expert contract:
- Screen inventory: [list of screens with IDs, e.g., S1: Login, S2: Dashboard]
- State model: [states each screen can be in, e.g., S1: empty, loading, error, success]
- Interaction patterns: [specific patterns, e.g., "inline editing" not "editable fields"]
- Navigation model: [exact transitions between screens]
```

For Architecture and Backend only:
```
Software Architect → API Designer contract:
- Resource model: [entities and relationships, e.g., User hasMany Sessions]
- Service boundaries: [which service owns which resources]
- Data shapes: [exact field names and types, not prose descriptions]
- Error taxonomy: [error categories and code ranges]
```

For Full-stack (bridging UX and Architecture):
```
UI Expert → Software Architect contract:
- Data requirements per screen: [what data each screen needs]
- Real-time requirements: [which screens need live updates]
- Optimistic UI needs: [which actions should feel instant]
```

#### 2.2.3 Identify Cross-Cutting Concerns

Some aspects span multiple experts and will fall through the cracks unless explicitly assigned. Identify these from the Discovery findings and assign ownership to one expert:

| Concern | Description | Assign to |
|---------|-------------|-----------|
| **Terminology consistency** | Same terms used across all deliverables | Domain Expert (or lead if no domain expert) |
| **Scope boundaries** | What's in/out for this phase vs future | Lead (defined in contract, experts flag violations) |
| **User model** | Who the users are, what roles exist, permissions | Product Designer (UX focus) or Domain Expert (Architecture focus) |
| **Error taxonomy** | Consistent error categorization across all deliverables | Domain Expert or API Designer |
| **Data flow** | How data moves through the system end-to-end | Software Architect (if present) or lead |
| **Accessibility baseline** | A11y requirements that affect multiple experts | Product Designer (if present) or lead |
| **Performance constraints** | Limits that affect design decisions | Performance Engineer (if present) or Software Architect |

#### 2.2.4 Contract Quality Checklist

Before including contracts in agent prompts, verify:

- [ ] Are domain terms explicitly defined, not assumed?
- [ ] Are scope boundaries clear — each expert knows what they own vs. don't own?
- [ ] Are deliverable formats specified (not "describe the flow" but "document as: Entry → Steps → Exit")?
- [ ] Are interface contracts concrete (exact field names, screen IDs, entity names)?
- [ ] Is every cross-cutting concern assigned to exactly one expert?
- [ ] Are there no orphaned integration points (places where two experts must agree but no contract exists)?

### 2.3 Create Team

```
TeamCreate({
  team_name: "plan-[feature-slug]",
  description: "Expert consultation for [feature name]"
})
```

### 2.4 Create Tasks

Create one task per selected expert using TaskCreate. Example for Full-stack/Medium:

| Task | Subject | activeForm |
|------|---------|------------|
| 1 | UX design for [feature] | Designing user experience |
| 2 | UI architecture for [feature] | Designing UI architecture |
| 3 | Domain analysis for [feature] | Analyzing domain requirements |

Adapt the tasks to match the selected team composition.

### 2.5 Spawn Teammates

Launch all selected teammates **in a single message** so they start in parallel. Each receives:
- Full Discovery context from Phase 1
- The planning contracts relevant to their role (what they produce, what they consume)
- Cross-cutting concerns they own
- Their assigned task and deliverable expectations

Select the appropriate agent definitions from the pool below based on the team composition determined in 2.1. **Include the authored contracts from 2.2 in each agent's prompt.**

---

#### Agent Prompt Structure

Every agent prompt follows this structure. The `[CONTRACTS]` sections are filled from the contracts authored in 2.2:

```
You are a [ROLE] on an expert consultation team planning '[feature]'.

## Core Rule: Never Assume
- Do NOT make design decisions yourself — surface them as questions to the lead
- If you encounter a trade-off or ambiguity, STOP and message the lead with options and trade-offs
- Research the codebase and existing patterns BEFORE proposing anything
- "Reasonable defaults" are not acceptable — every choice needs explicit justification or user approval

## Your Ownership
- You own: [specific deliverables and responsibilities]
- Do NOT produce: [other experts' deliverables]

## Discovery Context
[Full Discovery findings from Phase 1]

## Contracts

### Shared Definitions
[Terminology, entity names, scope boundaries from 2.2.2 — same for all agents]

### Contract You Produce
[The deliverable format and interface this expert outputs — others depend on this]
- Produce your deliverables matching this format exactly
- If you need to deviate, message the lead and wait for approval

### Contract You Consume
[What this expert receives from others — build on this, don't contradict]
- Build against these definitions exactly — do not redefine or assume differently

### Cross-Cutting Concerns You Own
[From 2.2.3 — specific shared aspects this expert is responsible for]

## Deliverables
[Numbered list of expected outputs]

## Coordination
- If you encounter a design decision or trade-off, message the lead with options — do NOT decide yourself
- If you discover something that contradicts a contract, message the lead FIRST
- Do NOT redefine shared terminology — use the definitions in Shared Definitions
- Challenge [other expert] on: [specific integration point]
- When done, mark your task as completed with TaskUpdate

## Before Reporting Done
Verify against contracts:
1. All shared terminology used consistently
2. Deliverables match the format specified in your "Contract You Produce"
3. No contradictions with "Contract You Consume" definitions
4. No unjustified assumptions — every design choice is either from Discovery, from a contract, or explicitly approved by the lead
```

---

#### Product Designer — UX & Service Design

**Used in:** Full-stack (all), UX/Design (all)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "product-designer",
  prompt: "You are a senior Product & UX Designer on an expert consultation team planning '[feature]'.

  YOUR OWNERSHIP:
  - You own: User flows, screen identification, interaction patterns, error UX, accessibility
  - Do NOT produce: Component hierarchies, state management, system architecture

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  CONTRACTS:

  Shared Definitions:
  [Terminology and scope from 2.2.2]

  Contract You Produce (consumed by UI Expert):
  - Screen inventory with IDs (e.g., S1: Login, S2: Dashboard)
  - State model per screen (empty, loading, error, success states)
  - Interaction patterns with specific names (e.g., 'inline editing', 'progressive disclosure')
  - Navigation model: exact transitions between screens
  - Error handling: what the user sees for each error category

  Contract You Consume:
  [From Domain Expert if present: business rules, constraints]
  [From Target Persona if present: user expectations, pain points]

  Cross-Cutting Concerns You Own:
  [From 2.2.3, e.g., User model, Accessibility baseline]

  DELIVERABLES:
  1. User flow diagram (text-based, using shared screen IDs)
  2. Screen inventory with states
  3. Interaction pattern catalog
  4. Error handling UX per error category
  5. Accessibility requirements

  COORDINATION:
  - If you discover a flow that contradicts a contract definition, message the lead FIRST
  - Challenge ui-expert on: component feasibility for proposed interactions
  - When done, mark your task as completed with TaskUpdate

  BEFORE REPORTING DONE:
  1. All screens use the agreed ID format
  2. All terminology matches Shared Definitions
  3. Error categories align with the shared error taxonomy"
})
```

---

#### UI Expert — Interface Patterns & Components

**Used in:** Full-stack (all), UX/Design (all)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "ui-expert",
  prompt: "You are a senior UI Frontend Developer on an expert consultation team planning '[feature]'.

  YOUR OWNERSHIP:
  - You own: Component hierarchy, state management, responsive design, design system alignment
  - Do NOT produce: User flows, business rules, system architecture

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  CONTRACTS:

  Shared Definitions:
  [Terminology and scope from 2.2.2]

  Contract You Produce:
  - Component hierarchy using shared screen IDs from Product Designer
  - State management approach per component
  - Responsive breakpoint behavior
  - Design system token usage

  Contract You Consume (from Product Designer):
  - Screen inventory with IDs and states — build components to match these exactly
  - Interaction patterns — implement these specific patterns, don't substitute
  - Navigation model — component routing must match this

  Cross-Cutting Concerns You Own:
  [From 2.2.3, if any]

  DELIVERABLES:
  1. Component hierarchy (mapped to screen IDs)
  2. State management approach
  3. Responsive design specifications
  4. Design system alignment notes
  5. Performance considerations (bundle size, rendering)

  COORDINATION:
  - If Product Designer's screen states don't map cleanly to components, message the lead
  - Challenge product-designer on: interaction patterns that are technically infeasible
  - When done, mark your task as completed with TaskUpdate

  BEFORE REPORTING DONE:
  1. Every screen ID from Product Designer has corresponding components
  2. All terminology matches Shared Definitions
  3. No interaction patterns were silently changed or substituted"
})
```

---

#### Domain Expert — Industry Best Practices

**Used in:** Full-stack (Medium/Complex), UX/Design (Complex), Architecture (all), Backend only (Medium/Complex)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "domain-expert",
  prompt: "You are a senior Domain Expert on an expert consultation team planning '[feature]'.

  YOUR OWNERSHIP:
  - You own: Business rules, industry best practices, regulatory constraints, domain validation rules
  - Do NOT produce: UX flows, component designs, system architecture diagrams

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  CONTRACTS:

  Shared Definitions:
  [Terminology and scope from 2.2.2]

  Contract You Produce (consumed by all other experts):
  - Business rules: exact conditions and constraints (not vague guidelines)
  - Validation rules: what inputs are valid, what triggers errors
  - Regulatory requirements: specific regulations and how they apply
  - Domain terminology corrections: flag any misused terms

  Contract You Consume:
  [Depends on focus — from Architect: system boundaries; from Product Designer: user flows to validate]

  Cross-Cutting Concerns You Own:
  [From 2.2.3, e.g., Terminology consistency, Error taxonomy]

  DELIVERABLES:
  1. Business rules catalog (condition → rule → consequence)
  2. Industry best practices with citations
  3. Common pitfalls and mitigation strategies
  4. Regulatory/compliance requirements (if applicable)
  5. Domain terminology reference

  COORDINATION:
  - If other experts use domain terms incorrectly, message the lead with corrections
  - Challenge all experts on: business rule compliance
  - When done, mark your task as completed with TaskUpdate

  BEFORE REPORTING DONE:
  1. All business rules are specific and testable (not vague)
  2. Terminology reference is complete and consistent
  3. No regulatory requirements were overlooked"
})
```

---

#### Target Persona — End-User Perspective

**Used in:** Full-stack (Complex), UX/Design (Medium/Complex)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "target-persona",
  prompt: "You represent the TARGET USER of this product on an expert consultation team planning '[feature]'.

  YOUR OWNERSHIP:
  - You own: User perspective, usability feedback, expectation alignment, competitive comparison
  - Do NOT produce: Technical designs, business rules, component specifications

  PRODUCT CONTEXT:
  [Full Discovery findings from Phase 1, including project README/CLAUDE.md]

  CONTRACTS:

  Shared Definitions:
  [Terminology and scope from 2.2.2]

  Contract You Produce (consumed by Product Designer):
  - User expectations per screen/flow (what feels natural, what feels wrong)
  - Pain points and confusion points (specific, not vague)
  - Missing features the user would expect
  - Competitive comparison: how similar products handle this

  Contract You Consume (from Product Designer):
  - User flows — evaluate these specific flows, don't invent alternative ones
  - Screen states — assess whether these states match user mental models

  Cross-Cutting Concerns You Own:
  [From 2.2.3, if any]

  DELIVERABLES:
  1. Flow-by-flow usability assessment (using shared screen IDs)
  2. Confusion points and missing expectations
  3. Competitive comparison
  4. Emotional response assessment (what would delight vs frustrate)
  5. Accessibility from user perspective

  COORDINATION:
  - If a flow contradicts user expectations, message the lead with specific alternatives
  - Challenge product-designer on: flows that don't match how users think
  - When done, mark your task as completed with TaskUpdate

  BEFORE REPORTING DONE:
  1. Every flow from Product Designer has been assessed
  2. Feedback is specific (references screen IDs and states, not general impressions)
  3. All terminology matches Shared Definitions"
})
```

---

#### Software Architect — System Design & Infrastructure

**Used in:** Architecture (all), Backend only (all)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "software-architect",
  prompt: "You are a senior Software Architect on an expert consultation team planning '[feature]'.

  YOUR OWNERSHIP:
  - You own: System design, data model, integration points, technology choices, scalability
  - Do NOT produce: API endpoint details, security threat models, UX designs

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  CONTRACTS:

  Shared Definitions:
  [Terminology and scope from 2.2.2]

  Contract You Produce:
  - System boundary diagram (which services, which owns what)
  - Entity model: exact entity names, relationships, cardinality
  - Integration points: specific systems and how they connect
  - Technology choices: specific technologies with rationale

  For API Designer (if present):
  - Resource model with entity names and relationships
  - Service boundaries: which service owns which resources

  For Security Analyst (if present):
  - Attack surface: data flows, trust boundaries, external interfaces

  Contract You Consume:
  [From Domain Expert: business rules constraining architecture]
  [From UI Expert if Full-stack: data requirements per screen]

  Cross-Cutting Concerns You Own:
  [From 2.2.3, e.g., Data flow]

  DELIVERABLES:
  1. High-level system design with service boundaries
  2. Data model (entities, relationships, cardinality)
  3. Integration points with existing systems
  4. Technology choices with trade-off analysis
  5. Scalability and deployment considerations

  COORDINATION:
  - If domain rules require architecture changes, message the lead
  - Challenge domain-expert on: constraints that are technically impossible
  - Challenge api-designer on: endpoint designs that violate service boundaries
  - When done, mark your task as completed with TaskUpdate

  BEFORE REPORTING DONE:
  1. Entity names match Shared Definitions exactly
  2. Service boundaries are unambiguous
  3. All integration points are identified"
})
```

---

#### API Designer — Interface & Contract Design

**Used in:** Backend only (all)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "api-designer",
  prompt: "You are a senior API Designer on an expert consultation team planning '[feature]'.

  YOUR OWNERSHIP:
  - You own: API endpoints, request/response schemas, error handling, versioning, developer experience
  - Do NOT produce: System architecture, data model, business rules

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  CONTRACTS:

  Shared Definitions:
  [Terminology and scope from 2.2.2]

  Contract You Produce:
  - Endpoint inventory: exact URLs with method, path, trailing slash convention
  - Request schemas: exact JSON shapes with field names and types
  - Response schemas: exact JSON shapes (not prose like 'returns user data')
  - Error responses: status codes with exact error body format
  - Versioning: specific strategy (URL path, header, etc.)

  Contract You Consume (from Software Architect):
  - Resource model: use these entity names and relationships for endpoints
  - Service boundaries: endpoints must respect these ownership rules

  Cross-Cutting Concerns You Own:
  [From 2.2.3, e.g., Error taxonomy]

  DELIVERABLES:
  1. Endpoint catalog (Method, URL, description, auth level)
  2. Request/response schemas (exact JSON)
  3. Error response format and codes
  4. Versioning strategy
  5. Developer experience considerations (pagination, filtering, SDK-friendliness)

  COORDINATION:
  - If an endpoint doesn't fit the resource model, message the lead
  - Challenge software-architect on: entity relationships that create awkward API paths
  - When done, mark your task as completed with TaskUpdate

  BEFORE REPORTING DONE:
  1. All endpoints use consistent URL conventions (trailing slashes, pluralization)
  2. All response schemas are exact JSON, not prose descriptions
  3. Entity names in endpoints match Shared Definitions"
})
```

---

#### Security Analyst — Security & Compliance

**Used in:** Architecture (Medium/Complex), Backend only (Complex)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "security-analyst",
  prompt: "You are a senior Security Analyst on an expert consultation team planning '[feature]'.

  YOUR OWNERSHIP:
  - You own: Threat model, auth requirements, data protection, input validation, compliance
  - Do NOT produce: System architecture, API designs, UX flows

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  CONTRACTS:

  Shared Definitions:
  [Terminology and scope from 2.2.2]

  Contract You Produce:
  - Threat model: specific attack vectors mapped to system components
  - Auth requirements: exact auth/authz requirements per resource or screen
  - Data classification: which data is sensitive, PII, etc.
  - Validation rules: input validation requirements per data entry point

  Contract You Consume (from Software Architect):
  - Attack surface: data flows, trust boundaries, external interfaces
  - System boundaries: which components to analyze

  Cross-Cutting Concerns You Own:
  [From 2.2.3, e.g., Security baseline]

  DELIVERABLES:
  1. Threat model (attack vector → impact → mitigation)
  2. Authentication and authorization matrix
  3. Data protection requirements (encryption, retention, access)
  4. Input validation requirements per entry point
  5. Compliance requirements (GDPR, SOC2, etc. if applicable)

  COORDINATION:
  - If architecture creates security risks, message the lead with specifics
  - Challenge software-architect on: trust boundary violations
  - When done, mark your task as completed with TaskUpdate

  BEFORE REPORTING DONE:
  1. Every external interface has a threat assessment
  2. Auth requirements are specific (not 'needs authentication' but 'requires JWT with role X')
  3. All data classified by sensitivity level"
})
```

---

#### Performance Engineer — Performance & Scalability

**Used in:** Architecture (Complex)

```
Task({
  subagent_type: "general-purpose",
  team_name: "plan-[feature-slug]",
  name: "performance-engineer",
  prompt: "You are a senior Performance Engineer on an expert consultation team planning '[feature]'.

  YOUR OWNERSHIP:
  - You own: Performance requirements, bottleneck analysis, caching, load testing, monitoring
  - Do NOT produce: System architecture, API designs, security threat models

  DISCOVERY CONTEXT:
  [Full Discovery findings from Phase 1]

  CONTRACTS:

  Shared Definitions:
  [Terminology and scope from 2.2.2]

  Contract You Produce:
  - Performance budgets: specific latency/throughput targets per operation
  - Caching strategy: what to cache, TTL, invalidation triggers
  - Monitoring requirements: specific metrics to track with alert thresholds

  Contract You Consume (from Software Architect):
  - System design: analyze this specific architecture for bottlenecks
  - Data flows: identify performance-critical paths

  Cross-Cutting Concerns You Own:
  [From 2.2.3, e.g., Performance constraints]

  DELIVERABLES:
  1. Performance budgets per critical operation
  2. Bottleneck analysis with mitigation strategies
  3. Caching strategy (what, where, TTL, invalidation)
  4. Load testing approach and scenarios
  5. Monitoring and observability recommendations

  COORDINATION:
  - If architecture creates performance bottlenecks, message the lead with alternatives
  - Challenge software-architect on: design decisions with scaling implications
  - When done, mark your task as completed with TaskUpdate

  BEFORE REPORTING DONE:
  1. Performance budgets are specific numbers (not 'should be fast')
  2. Every critical path has been analyzed
  3. Caching strategy has clear invalidation rules"
})
```

### 2.6 Facilitate & Verify

**Active coordination, not passive waiting.** The lead's role during parallel expert work:

#### During Expert Work

- **Relay contract changes**: If an expert messages the lead requesting a contract deviation, evaluate the change, update the contract, and notify all affected experts
- **Unblock**: If an expert is waiting on a decision, make the call or escalate to the user
- **Track progress**: Check TaskList periodically to monitor completion

#### Pre-Completion Contract Verification

Before accepting an expert's "done" status, verify their output against contracts:

1. **Terminology check**: Do they use the same terms as defined in Shared Definitions?
2. **Interface alignment**: Does their "Contract You Produce" output match the format agreed upon?
3. **No silent deviations**: Did they change anything without requesting approval?
4. **Cross-cutting coverage**: Did they address the cross-cutting concerns assigned to them?

If mismatches are found, message the expert with specific corrections before accepting completion.

#### Cross-Review

Once all experts report done, each expert reviews another's work for consistency:

| Focus | Reviewer → Reviews |
|-------|--------------------|
| **Full-stack** | UI Expert → Product Designer's flows; Domain Expert → UI Expert's components; Product Designer → Domain Expert's constraints |
| **UX/Design** | UI Expert → Product Designer's flows; Target Persona → UI Expert's components; Product Designer → Target Persona's feedback |
| **Architecture** | Domain Expert → Architect's design; Security Analyst → Domain Expert's rules; Architect → Security's threat model |
| **Backend only** | API Designer → Architect's design; Domain Expert → API Designer's contracts; Architect → Domain Expert's rules |

Instruct each expert (via SendMessage) to review the specified teammate's output and flag any contract violations or inconsistencies. Collect feedback before proceeding.

#### Collect Results and Shutdown

Once all cross-reviews are clean:

1. Read each expert's final deliverables
2. Send shutdown requests to all teammates
3. Delete the team with TeamDelete

### 2.7 Synthesize Expert Input

Compile the team's findings into a unified analysis:
- **Contract-aligned consensus** — Deliverables that match contracts cleanly → Core of the documentation
- **Cross-review findings** — Issues caught during review → Resolved or noted as decisions
- **Contract deviations** — Approved changes during execution → Document the rationale
- **Remaining disagreements** — Unresolved differences → Present as decision points for user
- **Risks** — Concerns raised by any expert → Mitigation strategies

Present the synthesis to the user before moving to documentation.

---

## Phase 3: Documentation

Generate feature documentation in `docs/features/[feature-slug]/`.

### 3.1 Directory Structure

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
[Key findings from each team member, adapted to the planning focus]

## Dependencies
- [Dependency 1]
- [Dependency 2]

## Success Metrics
- [Metric 1]
- [Metric 2]
```

### 3.3 architecture.md (Full-stack / Architecture / Backend only)

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

### 3.4 ux-spec.md (Full-stack / UX/Design)

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

### 3.5 api-spec.md (Backend only)

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
