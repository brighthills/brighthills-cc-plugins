# Implementation Phases — Detailed Reference

Detailed instructions for each phase of the implementation workflow. Both ticket (`#`) and docs (`@`) modes share the same phases with mode-specific variations in Init and Complete.

---

## Phase 1: Initialization

### Ticket Mode (`#`)

#### 1.1 Fetch Ticket

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Fetch [#XX]: Title, Description, AC, Status, Parent, Children" })
```

#### 1.2 Fetch Parent Context

```
IF ticket has parent (Task→Story or Story→Epic):
  Task({ subagent_type: "agile-ticket-manager",
    prompt: "Fetch parent of [#XX]: Title, Description, AC.
             Context for understanding the ticket's role." })
```

#### 1.3 Load Source Documentation

Parse the ticket body for a "Source Documentation" section (created by `/bh-agile:create-tickets`). If present, read ALL referenced files into context:

```
IF ticket body contains "Source Documentation" table:
  Extract all file paths from the table (e.g., docs/features/<feature>/README.md)
  FOR each path:
    Read(path)  — load full file into context
  Note which sections are marked as relevant per the table
```

**This step is mandatory.** Source Documentation references contain architecture decisions, UX specs, scope definitions, and other context critical for correct implementation. Skipping this step leads to incomplete understanding and implementation errors.

If a referenced file does not exist, log a warning and continue with remaining files.

#### 1.4 Validate & Update Status

- **CLOSED** → Ask to reopen
- **BACKLOG/OPEN** → Set to IN-PROGRESS immediately:

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Set issue #XX status to in-progress. Propagate to parent if needed." })
```

#### 1.5 Create Branch

```bash
git checkout <default-branch> && git pull
git checkout -b feature/XX-<slug>
```

Auto-detect the default branch name from git (e.g., `main`, `master`, `develop`).

### Docs Mode (`@`)

#### 1.1 Read Documentation

Read all files in the specified directory:

```
Read @docs/features/<feature>/
  - README.md — overview, goals, scope
  - Architecture docs — system design, data models
  - UX/UI specs — wireframes, user flows
  - TASK-LIST.json — pre-planned tasks (if exists)
```

#### 1.2 Follow External References

Scan loaded documents for cross-references to files outside the feature directory. Common patterns:

- Links to shared architecture docs (e.g., `docs/architecture/api-design.md`)
- References to design system or component library docs
- Links to API specifications or schema definitions
- References to other feature docs (dependencies)

```
FOR each external file reference found in the loaded docs:
  Read(referenced_path)  — load into context
```

If a referenced file does not exist, log a warning and continue with remaining files.

#### 1.3 Create Branch

```bash
git checkout <default-branch> && git pull
git checkout -b feature/<feature-slug>
```

---

## Phase 2: Planning

1. **Verify all references loaded** — Confirm all external references from Phase 1 are in context:
   - Ticket mode: All Source Documentation table paths loaded
   - Docs mode: All cross-referenced external files loaded
   - If any are missing, load them now before proceeding
2. **Analyze requirements** from input source:
   - Ticket mode: Parse Acceptance Criteria, review description
   - Docs mode: Parse documentation structure, identify specs
3. **Review context**:
   - Ticket: Parent Story/Epic for vertical slice context
   - Docs: Related documents, architecture decisions
   - Both: All loaded external references and their relevant sections
4. **Consider optional prompt** — user-provided guidance overrides defaults
5. **Create implementation tasks** — specific `TaskCreate` items under Phase 3
6. **Story/feature: Check children** — verify child task status if applicable

---

## Phase 3: Implementation

Execute implementation tasks from Phase 2 (`in_progress` → `completed`).

Adapt to the project's tech stack:

| Area | Examples |
|------|----------|
| Backend | API routes, server actions, services |
| Database | Schema changes, migrations |
| Frontend | UI components, pages |
| i18n | Translation files (if applicable) |
| Types | Type definitions, interfaces |

---

## Phase 3.5: Code Review & Simplification

After implementation, review and simplify changed files. Apply these categories:

1. **DRY Violations** — Duplicated logic, copy-pasted blocks, patterns that could be abstracted
2. **SOLID Violations** — Single Responsibility (oversized files/functions), Open/Closed (hard-coded conditionals), Interface Segregation (bloated interfaces)
3. **Naming Conventions** — Follow the project's established naming patterns
4. **Forbidden Patterns** — Identify anti-patterns specific to the project's stack (e.g., unsafe type casts, debug statements, magic numbers, deeply nested ternaries)
5. **Type Safety** — Missing return types, implicit any, unjustified non-null assertions, type assertions that could be narrowed

If a `code-simplifier` agent is available, delegate:

```
Task({ subagent_type: "code-simplifier",
  prompt: "Review and simplify the recently modified code.
           Focus on clarity, consistency, and maintainability while preserving all functionality." })
```

**BLOCKING: Phase 3.5 MUST complete before Phase 4 starts!**
The code review may modify source code — QA must validate the FINAL code, not the pre-review version.

---

## Phase 4: Quality Assurance

### 4.1 Static Checks

Run the project's type checking and linting. Detect commands from project config (package.json scripts, Makefile, etc.):

```bash
<typecheck-command>       # e.g., tsc --noEmit, npx tsc
<lint-command>            # e.g., eslint, npx eslint .
```

### 4.2 Unit Tests

```bash
<test-command>            # e.g., jest, vitest, pytest
```

### 4.3 Build

```bash
<build-command>           # e.g., next build, vite build, go build
```

### 4.4 E2E Tests

**Story/feature (MANDATORY):**

```
Task({ subagent_type: "qa-tester",
  prompt: "Create and run E2E tests based on requirements.
    - Read AC or documentation
    - Create test file following project conventions
    - Run tests, report results" })
```

### 4.5 Smoke E2E (ALL tickets — BLOCKING)

```bash
<e2e-smoke-command>       # e.g., playwright test --grep @smoke
```

### 4.6 E2E Gate

```
IF smoke E2E fails:
  BLOCK — Fix smoke tests first

IF Story/feature AND (E2E missing OR failing):
  BLOCK — Create/fix E2E tests first

IF Story/feature AND E2E passing:
  Proceed

IF Task AND smoke passing:
  Proceed
```

---

## Phase 5: Completion

### Ticket Mode (`#`)

#### 5.1 Document Implementation

Prepare closing comment with implementation approach, key files changed, and architectural decisions.

#### 5.2 Handle Partial Implementation

```
IF partially completed:
  1. AskUserQuestion: "Create follow-up ticket?"
  2. Create related issue with remaining work
```

#### 5.3 Pre-close Validation (STORY ONLY)

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "List all child Tasks of #XX with status" })

IF any child Tasks OPEN:
  BLOCK — Close child Tasks first!
```

#### 5.4 Close Ticket

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Close [#XX] with:
    - Implementation summary
    - Files changed
    - Propagate hierarchy (sibling Tasks → Story → Epic)" })
```

#### 5.5 Version Bump (STORY ONLY)

If the project uses package.json versioning:

```bash
npm version patch --no-git-tag-version
```

#### 5.6 Git Commit

```bash
git add -A && git commit -m "feat: <title> (#XX)

- Summary of changes
- Tests: unit + E2E

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### Docs Mode (`@`)

#### 5.1 Git Commit

```bash
git add -A && git commit -m "feat: <feature-title>

- Summary of changes
- Tests: unit + E2E

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Phase 6: Summary

### 6.1 Generate Summary

Always generate an implementation summary:

```markdown
## Implementation Summary

### What was implemented
- [Brief description of feature/fix]
- [Key technical changes]

### Files changed
- `path/to/file` - [What changed]

### Visible Changes
> **Testing guide**: What to look for in the application?

1. **[Where]**: [URL or navigation path]
   - [What to see / do]
   - [Expected behavior]

2. **[Where]**: [Another location]
   - [What to see / do]
   - [Expected behavior]

### Test coverage
- [ ] Unit tests passing
- [ ] E2E smoke tests passing
- [ ] Feature-specific tests (if applicable)
```

### 6.2 Append to Ticket (Ticket Mode Only)

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Add closing comment to [#XX]:
    - Implementation summary
    - Files changed
    - Visible Changes (WHERE + WHAT TO SEE + EXPECTED BEHAVIOR)
    - Test coverage
    - Branch: feature/XX-slug" })
```

---

## Phase 7: Cleanup

### 7.1 Kill Background Processes

```
List running background tasks and kill each one:
- tail -f processes
- Background test watchers
- Temporary dev servers
```
