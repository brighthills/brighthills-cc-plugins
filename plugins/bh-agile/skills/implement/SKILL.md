---
name: implement
description: Implement a feature from a ticket or local documentation with structured phases, quality gates, and optional ticket administration. Triggers: "implement", "work on #XX", "implement from docs", "/implement".
argument-hint: <#issue> or <@docs/path/> ["prompt"]
allowed-tools: "*"
model: sonnet
---

# Implement

Feature implementation with structured phases, quality gates, and optional ticket administration.

## Arguments

`$ARGUMENTS` supports two input modes:

| Mode | Trigger | Example | Source |
|------|---------|---------|--------|
| **Ticket** | `#` prefix | `/implement #45` | Issue tracker (GitHub/GitLab) |
| **Docs** | `@` prefix | `/implement @docs/features/auth/` | Local feature documentation |

Optional: `/implement #45 "use dialog component"` (guidance prompt), `/implement #45 --e2e` (force E2E)

### Input Detection

```
IF $ARGUMENTS starts with "#" → TICKET MODE
IF $ARGUMENTS starts with "@" → DOCS MODE
ELSE → Ask user to clarify
```

## Context

- Date: !`date +%Y-%m-%d`
- Branch: !`git branch --show-current 2>/dev/null || echo "not a git repo"`
- Status: !`git status --short 2>/dev/null | head -3`

---

## Critical Rules

1. **Status FIRST** — Before ANY work (ticket: set in-progress; docs: note start)
2. **TaskList-driven** — Create master TaskList BEFORE coding
3. **Code review is mandatory** — Phase 3.5 MUST complete before QA
4. **Quality gates block** — Tests must pass before completion
5. **Bottom-up closure** — Task → Story → Epic (ticket mode only)

---

## Master TaskList

After reading input (Phase 1), **immediately** create the master TaskList:

```
TaskCreate: "Phase 1: Init — Read input, create branch"
TaskCreate: "Phase 2: Plan — Analyze requirements, create implementation tasks"
TaskCreate: "Phase 3: Implement — Code changes, tests"
TaskCreate: "Phase 3.5: Code Review & Simplification" ← MANDATORY, never skip!
TaskCreate: "Phase 4: QA — Typecheck, lint, test, build"
TaskCreate: "Phase 5: Complete — Close/document, commit"
TaskCreate: "Phase 6: Summary — Generate implementation report"
TaskCreate: "Phase 7: Cleanup — Kill background processes"
```

Dependencies: 3.5 `blockedBy` 3 → 4 `blockedBy` 3.5 → 5 `blockedBy` 4

For each phase: `TaskUpdate` → `in_progress` → execute → `TaskUpdate` → `completed`

**NEVER skip a task. NEVER mark completed without doing the work.**

---

## Phase Overview

| Phase | Purpose | Ticket Mode (`#`) | Docs Mode (`@`) |
|-------|---------|-------------------|-----------------|
| 1. Init | Setup | Fetch ticket, set in-progress, branch | Read docs directory, branch |
| 2. Plan | Design | Analyze ticket AC + parent context | Analyze docs structure + specs |
| 3. Implement | Build | Code from AC requirements | Code from docs specs |
| 3.5. Review | Refine | Code review + simplification | Code review + simplification |
| 4. QA | Verify | Quality checks + E2E | Quality checks + E2E |
| 5. Complete | Close | Close ticket, version bump (Story) | Commit changes |
| 6. Summary | Report | Append summary to ticket | Generate summary |
| 7. Cleanup | Finish | Kill background processes | Kill background processes |

> **Detailed phase instructions**: [references/phases.md](references/phases.md)
> **Checklists**: [references/checklists.md](references/checklists.md)

---

## Ticket Mode (`#`) — Specifics

### Phase 1: Init

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Fetch [#XX]: Title, Description, AC, Status, Parent, Children" })

IF ticket has parent:
  Task({ subagent_type: "agile-ticket-manager",
    prompt: "Fetch parent of [#XX]: Title, Description, AC" })

Task({ subagent_type: "agile-ticket-manager",
  prompt: "Set issue #XX to in-progress. Propagate to parent." })
```

**Load Source Documentation** — Parse the ticket body for a "Source Documentation" section. If present, read ALL referenced files:

```
IF ticket body contains "Source Documentation" table:
  FOR each referenced path (e.g., docs/features/<feature>/README.md):
    Read(path)  — load into context
```

This is critical: tickets created by `/bh-agile:create-tickets` include a Source Documentation table with paths and relevant sections. These references contain architecture decisions, UX specs, and scope definitions needed for implementation.

Create branch from default branch (auto-detect: main, master, develop, etc.):

```bash
git checkout <default-branch> && git pull
git checkout -b feature/XX-<slug>
```

### Phase 5: Complete

```
# Story: verify all child Tasks are closed first
Task({ subagent_type: "agile-ticket-manager",
  prompt: "List child Tasks of #XX — close ALL before Story!" })

Task({ subagent_type: "agile-ticket-manager",
  prompt: "Close [#XX] with implementation summary" })
```

Story only — if project uses package.json versioning:

```bash
npm version patch --no-git-tag-version
```

### Phase 6: Summary

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "Add comment to #XX with implementation summary including visible changes" })
```

### Ticket Type Matrix

| Type | E2E Required | Version Bump | Children |
|------|-------------|-------------|----------|
| Task | Smoke only | No | None |
| Story | Full E2E | Yes (patch) | Check Tasks first |
| Epic | N/A | No | Check Stories first |

---

## Docs Mode (`@`) — Specifics

### Phase 1: Init

Read all documentation in the specified directory:

```
Read all files in @docs/features/<feature>/
  - README.md (overview, goals, scope)
  - Architecture docs
  - UX/UI specs
  - TASK-LIST or implementation notes
```

**Follow external references** — Scan loaded documents for cross-references to files outside the feature directory (e.g., shared architecture docs, API specs, design system references). Read all referenced files:

```
FOR each external reference found in docs:
  Read(referenced_path)  — load into context
```

Create branch from default branch:

```bash
git checkout <default-branch> && git pull
git checkout -b feature/<feature-slug>
```

### Phase 5: Complete

```bash
git add -A && git commit -m "feat: <feature-title>

- Summary of changes
- Tests: unit + E2E

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Shared Phases (Both Modes)

### Phase 2: Plan

1. **Verify all references loaded** — Confirm all Source Documentation (ticket mode) or external references (docs mode) from Phase 1 are in context. If any are missing, load them now.
2. **Analyze requirements** from input source (ticket AC or docs)
3. **Review context** — parent ticket, related docs, and all loaded references
4. **Create implementation tasks** (feature-specific TaskCreate items under Phase 3)
5. **Consider optional prompt** if user provided guidance

### Phase 3: Implement

Execute implementation tasks. Adapt to the project's tech stack:

| Area | Examples |
|------|----------|
| Backend | API routes, server actions, services |
| Database | Schema changes, migrations |
| Frontend | UI components, pages |
| i18n | Translation files (if applicable) |
| Types | Type definitions, interfaces |

### Phase 3.5: Code Review & Simplification

Review changed files against code quality standards:

1. **DRY Violations** — Duplicated logic, patterns that could be abstracted
2. **SOLID Violations** — Single Responsibility, Open/Closed, Interface Segregation
3. **Naming Conventions** — Follow project's established patterns
4. **Forbidden Patterns** — Anti-patterns specific to the project's stack
5. **Type Safety** — Missing return types, implicit any, unsafe assertions

If a `code-simplifier` agent is available, delegate to it. Otherwise, perform review manually.

**BLOCKING: Phase 3.5 MUST complete before Phase 4!**

### Phase 4: QA

Run the project's quality checks. Detect available commands from project config:

```bash
<typecheck-command>       # e.g., tsc --noEmit
<lint-command>            # e.g., eslint
<test-command>            # e.g., jest, vitest
<build-command>           # e.g., next build
<e2e-smoke-command>       # Smoke E2E — BLOCKING for ALL tickets!
```

Story/feature: delegate full E2E to `qa-tester` agent if available.

### Phase 6: Summary Template

```markdown
## Implementation Summary

### What was implemented
- [Brief description of feature/fix]

### Files changed
- `path/to/file` - [What changed]

### Visible Changes
> **Testing guide**: What to look for in the application?

1. **[Where]**: [URL or navigation path]
   - [What to see / do]
   - [Expected behavior]

### Test coverage
- [ ] Unit tests passing
- [ ] E2E smoke tests passing
```

### Phase 7: Cleanup

Kill all background processes (tail -f, dev servers, test watchers).

---

## Reference

- **[Phase Details](references/phases.md)** — Full 7-phase workflow with code examples
- **[Checklists](references/checklists.md)** — Pre-commit, pre-close, error handling
- **[Agent Prompts](references/agent-prompts.md)** — Standard prompts for agents
- **Ticket Manager**: `agile-ticket-manager` agent (generated by `/bh-agile:setup`)
- **Story Writer**: `/bh-agile:story-writer` for creating Epics, Stories, and Tasks
- **Code Review**: `/bh-agile:code-review` for standalone code quality reviews
