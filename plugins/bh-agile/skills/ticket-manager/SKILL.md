---
name: ticket-manager
description: >
  This skill should be used when the user asks to "check ticket", "update issue",
  "close ticket", "create issue", "list tickets", "move ticket to in-progress",
  "fetch issue details", "add comment to ticket", "link sub-issue",
  "check ticket status", "what's the status of #XX", or any issue tracker operation.
  Triggers on ticket/issue references like #45, mentions of epics/stories/tasks,
  or any GitHub/GitLab issue management request.
allowed-tools:
  - Task
  - Read
---

# Ticket Manager

All issue tracker operations MUST be delegated to the `agile-ticket-manager` agent. Never attempt to run `gh` or `glab` commands directly — the agent handles platform detection, label conventions, and hierarchy propagation.

## Prerequisites

The `agile-ticket-manager` agent must be installed in the project (`.claude/agents/agile-ticket-manager.md`). If missing, run `/bh-agile:setup` first.

## Usage

Delegate every ticket operation via Task:

```
Task({ subagent_type: "agile-ticket-manager",
  prompt: "<operation description>" })
```

## Common Operations

| Operation | Prompt |
|-----------|--------|
| Fetch ticket | `"Fetch #XX: title, description, AC, status, parent, children"` |
| Set status | `"Set #XX to in-progress. Propagate to parent if needed."` |
| Close ticket | `"Close #XX with summary: [summary]. Propagate hierarchy."` |
| Add comment | `"Add comment to #XX: [content]"` |
| Create issue | `"Create [type] issue: Title: [title], Body: [body], Labels: [labels]"` |
| Link child | `"Link #YY as sub-issue of #XX"` |
| List by type | `"List all [stories/tasks] in [status] status"` |
| Check siblings | `"Check sibling status for #XX — are all siblings closed?"` |

## Hierarchy Rules

The agent enforces Epic > Story > Task hierarchy:

- **Status propagation**: When a Task starts, its parent Story also moves to in-progress
- **Bottom-up closure**: All child Tasks must be closed before closing a Story; all Stories before closing an Epic
- **Label conventions**: Platform-specific separators (`:` for GitHub, `::` for GitLab) are handled automatically
