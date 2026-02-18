---
paths:
  - docs/features/**
---

# Feature Documentation Conventions

Rules for organizing and structuring feature documentation in the `docs/features/` folder.

---

## Folder Structure

```
docs/features/
├── README.md                        # Index of all features
├── CLAUDE.md                        # Folder-level instructions
├── feature-name/                    # One folder per feature (kebab-case)
│   ├── README.md                    # Feature overview (REQUIRED)
│   ├── TASK-LIST.json               # Machine-readable task tracking (RECOMMENDED)
│   ├── 00-ARCHITECTURE.md           # System design (if complex)
│   ├── 01-DATABASE.md               # Schema documentation
│   ├── 02-IMPLEMENTATION.md         # Implementation details
│   └── ...                          # Additional numbered docs
├── another-feature/
│   ├── README.md                    # Feature overview
│   ├── TASK-LIST.json               # Task tracking
│   └── ANALYSIS.md                  # Research/analysis docs
└── COMPLETED/                       # Archive for completed features
    └── old-feature/                 # Moved here after status set to Complete
        ├── README.md
        └── ...
```

**Purpose**: Feature documentation captures technical specifications, architecture decisions, and implementation details for major features.

---

## Folder Naming Convention

### Format

```
[feature-slug]/
```

### Rules

| Part | Rules | Example |
|------|-------|---------|
| **Name** | kebab-case, 2-4 words, descriptive | `user-auth`, `payment-flow`, `search-index` |
| **No prefixes** | Don't use dates or numbers in folder names | `auth-system` not `01-auth-system` |

### Examples

**CORRECT**
```
docs/features/
├── user-auth/
├── payment-flow/
├── notification-system/
├── file-upload/
└── search-index/
```

**INCORRECT**
```
docs/features/
├── UserAuth/              # Wrong case
├── 01-payment/            # Numbered folder
├── file_upload/           # Underscore
└── auth/                  # Too generic
```

---

## File Naming Convention

### Numbered Documents (for complex features)

Use numbered prefixes for features with multiple sequential documentation:

```
00-ARCHITECTURE.md          # System overview, data flow diagrams
01-DATABASE.md              # Schema, migrations, queries
02-SERVICE.md               # Internal service documentation
03-API.md                   # API reference
04-USAGE.md                 # Code examples, integration guide
05-DEPLOYMENT.md            # Deployment, configuration, env vars
```

**Rules:**
- Two-digit prefix: `00-`, `01-`, `02-`, etc.
- SCREAMING-KEBAB-CASE after prefix
- Always start with `00-ARCHITECTURE.md` for system overview
- README.md serves as index to numbered docs

### Thematic Documents (for simpler features)

For features without complex sequential documentation:

```
README.md                   # Overview + main content
ANALYSIS.md                 # Technical analysis, research
IMPLEMENTATION-CHECKLIST.md # Step-by-step implementation guide
UX-DESIGN.md                # UX decisions, wireframes
FRONTEND-ARCHITECTURE.md    # Frontend-specific architecture
```

**Rules:**
- SCREAMING-KEBAB-CASE
- `.md` extension always
- Descriptive, purpose-clear names

---

## TASK-LIST.json (Recommended)

Machine-readable task tracking for implementation progress.

### Quick Reference

| Template | When to Use | ID Format |
|----------|-------------|-----------|
| **Story-based** | Multi-story features with vertical slices | `S1-01`, `S2-03` |
| **Priority-based** | Technical improvements, cross-cutting | `P0-01`, `P1-02` |
| **Phase-based** | Simpler features with linear phases | `PHASE1-01`, `PHASE2-01` |

### Task Categories

| Category | Description |
|----------|-------------|
| `database` | Schema changes, migrations |
| `types` | Type definitions, interfaces |
| `validation` | Validation schemas, rules |
| `service` | Business logic services |
| `api` | API routes, endpoints |
| `ui` | UI components |
| `test` | Unit, integration, E2E tests |

### Minimal Example

```json
{
  "metadata": {
    "feature": "Feature Name",
    "totalTasks": 5,
    "completedTasks": 0,
    "lastUpdated": "2026-01-27"
  },
  "tasks": [
    {
      "id": "1",
      "category": "database",
      "description": "Create migration",
      "completed": false,
      "files": ["db/migrations/xxx.sql"]
    }
  ]
}
```

---

## README.md Template (Required)

Every feature folder MUST have a `README.md`:

```markdown
# [Feature Name]

> [One-line description of the feature]

## Status: [Status Text]

Status options:
- Complete - Production ready
- In Progress - Under development
- Critical - Pre-Launch Blocker
- Planned - Not started

## Documents

| Document | Description |
|----------|-------------|
| [TASK-LIST.json](./TASK-LIST.json) | Task tracking |
| [00-ARCHITECTURE.md](./00-ARCHITECTURE.md) | System overview |
| [01-DATABASE.md](./01-DATABASE.md) | Database schema |
| ... | ... |

## Summary

[2-3 paragraph overview of the feature, its purpose, and key decisions]

## Key Files

| File | Purpose |
|------|---------|
| `path/to/main/module` | Main implementation |
| `db/migrations/xxx.sql` | Database migration |

## Quick Start

[Code example showing basic usage]

## Related

- [Issue #XX](link) - Original ticket
- [Research Doc](link) - Related research
```

---

## Architecture Document Template (00-ARCHITECTURE.md)

```markdown
# [Feature Name] - Architecture

## Overview

[Brief description of what the system does]

## Why [Feature]?

| Problem | Solution |
|---------|----------|
| Problem 1 | How this feature solves it |
| Problem 2 | How this feature solves it |

## Architecture

[ASCII diagram of the system]

## Data Flow

1. Step 1 description
2. Step 2 description
3. ...

## Key Components

### Component 1

[Description and responsibility]

### Component 2

[Description and responsibility]

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `VAR_NAME` | What it does | `default` |

## Error Handling

[How errors are handled, retry logic, etc.]
```

---

## Archiving Completed Features

When a feature's status is set to **Complete**, move its folder to the `COMPLETED/` subdirectory:

```bash
mkdir -p docs/features/COMPLETED
mv docs/features/feature-name/ docs/features/COMPLETED/feature-name/
```

Then update `docs/features/README.md`:
1. Remove the feature from the active **Features** table
2. Add it to the **Completed** table with the updated path

This keeps the active feature list focused on in-progress and planned work while preserving completed documentation for reference.

---

## Document Index (docs/features/README.md)

Maintain `docs/features/README.md` as a master index:

```markdown
# Feature Documentation

Technical documentation for project features.

## Features

| Feature | Status | Description |
|---------|--------|-------------|
| [Payment Flow](./payment-flow/) | In Progress | Payment processing pipeline |
| [Search Index](./search-index/) | Planned | Full-text search system |

## Completed

| Feature | Description |
|---------|-------------|
| [User Auth](./COMPLETED/user-auth/) | Authentication and authorization |

## Adding New Feature Documentation

1. Create folder: `docs/features/[feature-name]/`
2. Add `README.md` with overview
3. Add `TASK-LIST.json` for progress tracking
4. Add numbered docs for complex features
5. Update this index
6. When complete: move folder to `docs/features/COMPLETED/` and update this index
```

---

## When to Use Each Style

### Use Numbered Docs When:

- Feature has multiple distinct subsystems
- Implementation spans database, backend, API, frontend
- Feature requires deployment/ops documentation
- Documentation order matters for understanding

**Example**: Email queue system (database → service → API → usage → deployment)

### Use Thematic Docs When:

- Feature is self-contained
- Documentation doesn't have natural sequence
- Feature is primarily analysis/research-based
- Simpler implementation scope

**Example**: Configuration refactor (analysis → checklist)

### TASK-LIST.json Template Selection

| Template | When to Use | Example |
|----------|-------------|---------|
| **Story-based** | Multi-story features with vertical slices | Waitlist feature (6 stories, 35 tasks) |
| **Priority-based** | Technical improvements, cross-cutting | Test coverage (P0/P1/P2 priorities) |
| **Phase-based** | Simpler features with linear phases | Config migration (7 tasks) |

---

## Diagram Conventions

Use ASCII art for architecture diagrams:

```
Box drawing characters:
┌──────┐  ┌──────┐
│ Box1 │──│ Box2 │
└──────┘  └──────┘

Arrows:
→ ← ↑ ↓ ↔ ⟶ ⟵
│ ─ ┤ ├ ┴ ┬ ┼

Flow:
▶ ▷ ◀ ◁ ▲ △ ▼ ▽
```

---

## Integration with Research

| Aspect | Research | Feature Docs |
|--------|----------|--------------|
| **Purpose** | Exploration, analysis | Permanent specification |
| **Timing** | Before/during implementation | After decisions made |
| **Audience** | Developer during development | All developers, onboarding |
| **Content** | Questions, options, tradeoffs | Final architecture, usage |

**Flow**: Research → Decision → Feature Documentation
