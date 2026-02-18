---
name: session
description: Create session summary before compact, or organize existing sessions into a year/month/day hierarchy.
argument-hint: [topic-slug] | --organize
allowed-tools: Read, Write, Bash(ls:*), Bash(mkdir:*), Bash(mv:*), Bash(find:*)
model: haiku
---

# Session

Two modes of operation:

1. **Default**: Create a new session summary file
2. **--organize**: Organize existing session files into daily directories

---

## Mode Detection

Check `$ARGUMENTS`:

- If contains `--organize` → Execute **Organize Mode**
- Otherwise → Execute **Create Mode**

---

## Create Mode (Default)

Create a session summary file to preserve development context before compact.

### Current Context

- Date: !`date +%Y-%m-%d`
- Existing sessions: !`ls -1t .claude/sessions/*.md 2>/dev/null | head -5 || echo "none"`
- Git status: !`git status --short 2>/dev/null | head -10 || echo "not a git repo"`
- Recent commits: !`git log --oneline -5 2>/dev/null || echo "no commits"`

### Instructions

1. **Determine sequence number**: Based on existing sessions today, calculate the next sequence (01, 02, 03...)

2. **Generate filename**:

   - Format: `YYYY-MM-DD-NN-topic.md`
   - Topic: Use `$ARGUMENTS` if provided, otherwise ask or infer from conversation
   - Location: `.claude/sessions/`

3. **Create session file** with this structure:

```markdown
---
title: [Descriptive title based on work done]
date: [today's date]
sequence: [number]
type: Feature | Bugfix | Refactor | Infrastructure
---

## Summary

[1-2 sentences about what was accomplished - from conversation context]

## Completed Tasks

[Checkbox list of completed work - from conversation context]

- [x] Task 1
- [x] Task 2

## Key Files

### New Files

[List files created in this session]

### Modified Files

[List files modified in this session]

## Key Decisions

[Important technical/architectural decisions made]

## Next Steps

[What should be done next - incomplete tasks, follow-ups]

- [ ] Next task 1
- [ ] Next task 2

## Notes

[Any additional context, blockers, or important information]
```

4. **Fill in content** based on the conversation context - this is the valuable part that would be lost after compact

5. **Confirm** the file was created and show its path

---

## Organize Mode (`--organize`)

Organize session files into a **hierarchical year/month/day** directory structure.
Today's sessions remain in the `.claude/sessions/` root for easy access.

### Target Structure

```
.claude/sessions/
├── README.md
├── 2026-02-05-01-today-session.md          ← today's files stay in root
├── 2026/                                    ← past months get hierarchy
│   ├── 2026-01/
│   │   ├── 2026-01-01/
│   │   │   ├── 2026-01-01-01-session.md
│   │   │   └── 2026-01-01-02-session.md
│   │   ├── 2026-01-02/
│   │   │   └── ...
│   │   └── ...
│   └── 2026-02/                             ← current month: day-level only
│       ├── 2026-02-01/
│       │   └── 2026-02-01-01-session.md
│       └── ...
└── 2025/
    └── 2025-12/
        ├── 2025-12-27/
        │   └── ...
        └── ...
```

### Rules

| Scope | Structure | Example |
|-------|-----------|---------|
| **Today** | Root (flat) | `.claude/sessions/2026-02-05-01-topic.md` |
| **Current month (not today)** | `YYYY/YYYY-MM/YYYY-MM-DD/` | `.claude/sessions/2026/2026-02/2026-02-01/` |
| **Past months** | `YYYY/YYYY-MM/YYYY-MM-DD/` | `.claude/sessions/2025/2025-12/2025-12-27/` |

### Current State

- Today's date: !`date +%Y-%m-%d`
- Current month: !`date +%Y-%m`
- Sessions directory: !`ls -la .claude/sessions/ 2>/dev/null | head -25 || echo "directory not found"`
- Unorganized files in root: !`find .claude/sessions -maxdepth 1 -name "*.md" -type f ! -name "README.md" 2>/dev/null | wc -l || echo "0"`

### Instructions

1. **Find items to organize**:

   - Look for `*.md` files directly in `.claude/sessions/` (not in subdirectories, not README.md)
   - Look for flat `YYYY-MM-DD/` directories directly in `.claude/sessions/` (legacy structure)
   - **EXCLUDE today's files** (keep `$(date +%Y-%m-%d)-*.md` in root)

2. **Migrate legacy flat directories**:

   If there are `YYYY-MM-DD/` directories directly under `.claude/sessions/`:
   - Extract year (`YYYY`) and month (`YYYY-MM`) from each directory name
   - Create hierarchy: `.claude/sessions/YYYY/YYYY-MM/`
   - Move `YYYY-MM-DD/` into `.claude/sessions/YYYY/YYYY-MM/YYYY-MM-DD/`

3. **Organize loose files**:

   For any `*.md` files (except README.md and today's) directly in `.claude/sessions/`:
   - Extract date (`YYYY-MM-DD`) from filename
   - Create hierarchy: `.claude/sessions/YYYY/YYYY-MM/YYYY-MM-DD/`
   - Move file into the day directory

4. **Create or update README.md** in `.claude/sessions/` with this structure:

```markdown
# Session Archive

Development session summaries organized by year/month/day.

## Directory Structure

### YYYY
| Month | Days | Sessions | Topics |
|-------|------|----------|--------|
| [YYYY-MM](./YYYY/YYYY-MM/) | N days | N sessions | topic1, topic2, ... |

## Today's Sessions (in root)

- [YYYY-MM-DD-NN-topic.md](./YYYY-MM-DD-NN-topic.md) - Description

## Recent Archived Sessions

### YYYY-MM
- [YYYY-MM-DD-NN-topic.md](./YYYY/YYYY-MM/YYYY-MM-DD/YYYY-MM-DD-NN-topic.md) - Description

## Statistics

- Total sessions: N
- Date range: YYYY-MM-DD to YYYY-MM-DD
- Most active day: YYYY-MM-DD (N sessions)
```

5. **Report results**:
   - Show how many files/directories were organized
   - List the created year/month directories
   - Confirm README.md creation
