# Feature Documentation Guide

> Path-specific instructions for `docs/features/` folder.

---

## Quick Reference

```bash
# Implement a feature from documentation
/implement @docs/features/feature-name/

# With specific guidance
/implement @docs/features/feature-name/ "start with database schema"

# Create tickets from feature documentation
/create-tickets @docs/features/feature-name/
```

---

## Feature Folder Structure

```
docs/features/
├── README.md                        # Index of all features (REQUIRED)
├── CLAUDE.md                        # This file - folder instructions
├── feature-name/                    # One folder per feature (kebab-case)
│   ├── README.md                    # Feature overview (REQUIRED)
│   ├── TASK-LIST.json               # Machine-readable task tracking (RECOMMENDED)
│   ├── 00-ARCHITECTURE.md           # System design (if complex)
│   ├── 01-DATABASE.md               # Schema documentation
│   ├── 02-IMPLEMENTATION.md         # Implementation details
│   └── IMPLEMENTATION.md            # Generated after /implement completes
└── COMPLETED/                       # Archive for completed features
    └── old-feature/                 # Moved here after status set to Complete
        └── ...
```

---

## Creating New Feature Documentation

### 1. Create Folder

```bash
mkdir docs/features/my-feature-name
```

**Naming rules:**
- kebab-case only
- 2-4 words, descriptive
- No dates or numbers in folder name

### 2. Create README.md (Required)

```markdown
# Feature Name

> One-line description of the feature

## Status: ⚪ Planned

Status options:
- ⚪ Planned - Not started
- 🟡 In Progress - Under development
- 🟢 Complete - Production ready
- 🔴 Critical - Pre-Launch Blocker

## Documents

| Document | Description |
|----------|-------------|
| [00-ARCHITECTURE.md](./00-ARCHITECTURE.md) | System overview |
| [01-DATABASE.md](./01-DATABASE.md) | Database schema |

## Summary

[2-3 paragraph overview of the feature]

## Key Files

| File | Purpose |
|------|---------|
| `src/lib/feature/index.ts` | Main implementation |

## Related

- [GitHub Issue #XX](link) - Original ticket
```

### 3. Add Numbered Docs (Complex Features)

```
00-ARCHITECTURE.md    # System overview, data flow
01-DATABASE.md        # Schema, migrations
02-SERVICE.md         # Backend service
03-API.md             # API endpoints
04-FRONTEND.md        # UI components
```

### 4. Create TASK-LIST.json (Recommended)

Add a machine-readable task list for tracking implementation progress.

> **Full templates & examples**: See the TASK-LIST section below.

**Quick Reference:**

| Template | When to Use | ID Format |
|----------|-------------|-----------|
| **Story-based** | Multi-story features | `S1-01`, `S2-03` |
| **Priority-based** | Technical improvements | `SA-01`, `HOOK-02` |
| **Phase-based** | Simpler features | `UTIL-01`, `COMP-01` |

**Minimal Example:**

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
      "files": ["supabase/migrations/xxx.sql"]
    }
  ]
}
```

### 5. Update Index

Add entry to `docs/features/README.md`:

```markdown
| [My Feature](./my-feature-name/) | ⚪ Planned | Description |
```

---

## Using /implement Command

The `/implement` skill supports docs-based implementation directly from feature documentation.

### Workflow

```
/implement @docs/features/feature-name/
    │
    ├── 1. Init: Read ALL docs, create branch
    ├── 2. Plan: Create TaskList from doc structure
    ├── 3. Implement: Code, tests, i18n
    ├── 3.5. Code Review & Simplification
    ├── 4. QA: typecheck, lint, test, build, e2e
    ├── 5. Complete: Commit changes
    ├── 6. Summary: Report visible changes
    └── 7. Cleanup: Kill background processes
```

### Two Modes

| Aspect | `/implement #45` | `/implement @docs/...` |
|--------|-------------------|------------------------|
| **Input** | Issue tracker ticket | Documentation folder |
| **Ticket admin** | Updates status, closes ticket | None |
| **Output** | Ticket comment | Git commit |
| **Version bump** | Story → yes | Optional |

### Related Commands

| Command | Purpose |
|---------|---------|
| `/plan-feature "feature name"` | Discovery + expert consultation → generates `docs/features/[feature]/` |
| `/create-tickets @docs/features/[feature]/` | Creates Epic/Stories/Tasks from feature docs |
| `/implement @docs/features/[feature]/` | Implements feature from docs |
| `/implement #45` | Implements feature from ticket |

---

## Document Templates

### 00-ARCHITECTURE.md

```markdown
# Feature Name - Architecture

## Overview
[Brief description]

## Why This Feature?
| Problem | Solution |
|---------|----------|
| Problem 1 | How it solves |

## Architecture
┌─────────────┐     ┌─────────────┐
│  Component  │────▶│  Component  │
└─────────────┘     └─────────────┘

## Data Flow
1. Step 1
2. Step 2

## Key Components
### Component 1
[Description]

## Configuration
| Variable | Description | Default |
|----------|-------------|---------|
| `VAR` | What it does | `value` |
```

### 01-DATABASE.md

```markdown
# Feature Name - Database

## Schema Changes

### New Tables
\`\`\`sql
CREATE TABLE feature_table (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
\`\`\`

### Modified Tables
- `existing_table`: Added `new_column`

## Migration
File: `supabase/migrations/YYYYMMDDHHMMSS_feature_name.sql`
```

---

## Status Lifecycle

```
⚪ Planned          # Documentation created
    ↓
🟡 In Progress      # /implement started
    ↓
🟢 Complete         # Implementation done
    ↓
📁 Archived         # Moved to COMPLETED/
```

### Marking Complete

Update the feature's README.md status:

```markdown
## Status: 🟢 Complete

> **Implemented**: 2026-02-12
```

### Archiving Completed Features

When a feature is **Complete**, move its folder to the `COMPLETED/` subdirectory:

```bash
mkdir -p docs/features/COMPLETED
mv docs/features/feature-name/ docs/features/COMPLETED/feature-name/
```

Then update `docs/features/README.md`:
1. Remove the feature from the active **Features** table
2. Add it to the **Completed** table with the updated path

```markdown
## Features

| Feature | Status | Description |
|---------|--------|-------------|
| [Search Index](./search-index/) | ⚪ Planned | Full-text search |

## Completed

| Feature | Description |
|---------|-------------|
| [User Auth](./COMPLETED/user-auth/) | Authentication and authorization |
```

This keeps the active feature list focused on in-progress and planned work.

---

## Best Practices

1. **Read ALL docs before implementing** - The `/implement @docs/...` command reads entire folder
2. **Number docs for sequence** - Use `00-`, `01-`, `02-` prefixes
3. **Keep README.md updated** - Single source of truth for feature status
4. **Document visible changes** - Critical for QA and stakeholders
5. **Link to GitHub issues** - Cross-reference in Related section
6. **Use TASK-LIST.json** - Machine-readable progress tracking
7. **Update task metadata** - Keep counts and completion dates current

---

## Related

- **Rules**: Feature docs rule installed via `/bh-agile:setup`
- **Story Writer**: `/bh-agile:story-writer` for creating Epics, Stories, and Tasks
