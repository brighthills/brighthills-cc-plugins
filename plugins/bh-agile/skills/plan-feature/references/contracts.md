# Planning Contracts

Before spawning agents, the lead analyzes the Discovery findings and defines the integration contracts between experts. This focused upfront work is what enables all agents to spawn in parallel without diverging on terminology, scope, or interfaces.

**Why contracts matter for planning:** Without shared definitions, experts will use different terminology for the same concepts, make conflicting assumptions about scope boundaries, and produce deliverables that contradict each other. Contracts prevent this.

## Contract Chain by Focus

Identify which experts need to agree on shared definitions. The contract chain depends on the planning focus:

### Full-stack

```
Product Designer → UI Expert:
  Screen list, interaction patterns, user flow states

Domain Expert → Product Designer + UI Expert:
  Business rules, constraints, regulatory requirements

Target Persona → Product Designer:
  User expectations, mental models, pain points
```

### UX/Design

```
Product Designer → UI Expert:
  Screen list, interaction patterns, user flow states, navigation model

Target Persona → Product Designer + UI Expert:
  User expectations, mental models, pain points

Domain Expert → All:
  Constraints affecting UX decisions
```

### Architecture

```
Software Architect → Domain Expert:
  System boundaries, component ownership, integration points

Software Architect → Security Analyst:
  Attack surface, data flow, trust boundaries

Domain Expert → Software Architect:
  Business rules that constrain architecture
```

### Backend only

```
Software Architect → API Designer:
  Resource model, entity relationships, service boundaries

API Designer → Domain Expert:
  Endpoint structure, data shapes, error taxonomy

Domain Expert → Software Architect + API Designer:
  Business rules, validation rules, domain constraints
```

## Authoring Contracts

From the Discovery findings, define each integration contract with enough specificity that experts can build to it independently. Contracts should include:

### Shared Terminology

- Define key domain terms and their exact meanings (e.g., "session" = a single user interaction, "conversation" = a collection of sessions)
- List entity names and their relationships
- Resolve any ambiguous terms from the Discovery phase

### Scope Boundaries

- Exactly what is in scope for each expert
- What is explicitly out of scope
- Where one expert's responsibility ends and another's begins

### Deliverable Format Agreements

- How user flows should be structured (entry → steps → exit)
- How component hierarchies should be documented
- How API contracts should be specified (exact JSON shapes, not prose)

### Interface Contracts (Focus-Dependent)

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

## Cross-Cutting Concerns

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

## Contract Quality Checklist

Before including contracts in agent prompts, verify:

- [ ] Are domain terms explicitly defined, not assumed?
- [ ] Are scope boundaries clear — each expert knows what they own vs. don't own?
- [ ] Are deliverable formats specified (not "describe the flow" but "document as: Entry → Steps → Exit")?
- [ ] Are interface contracts concrete (exact field names, screen IDs, entity names)?
- [ ] Is every cross-cutting concern assigned to exactly one expert?
- [ ] Are there no orphaned integration points (places where two experts must agree but no contract exists)?
