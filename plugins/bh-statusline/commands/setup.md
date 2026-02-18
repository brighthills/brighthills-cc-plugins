---
name: setup
description: Install the BrightHills custom status line script and configure Claude Code to use it.
argument-hint: "[--force]"
allowed-tools: ["Read", "Write", "Edit", "Bash", "AskUserQuestion"]
---

# Status Line Setup

Install the BrightHills custom status line into `~/.claude/statusline-command.sh` and configure Claude Code to use it.

## Prerequisites

- `jq` must be installed (used by the status line script to parse JSON input)

## Setup Steps

### Step 1: Check prerequisites

Verify `jq` is available:

```bash
command -v jq
```

If not found, inform the user they need to install it (`brew install jq` on macOS, `apt install jq` on Linux).

### Step 2: Check existing installation

Read `~/.claude/settings.json` and check if `statusLine` is already configured.

Also check if `~/.claude/statusline-command.sh` already exists.

If both exist and `--force` was NOT passed, ask the user:
- **Overwrite** — Replace the existing status line script with the BrightHills version
- **Skip** — Keep the current configuration

If `--force` was passed, proceed without asking.

### Step 3: Copy the status line script

Copy the script from the plugin assets to the fixed install location:

```bash
cp "${CLAUDE_PLUGIN_ROOT}/assets/statusline.sh" ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

### Step 4: Configure Claude Code settings

Read `~/.claude/settings.json`. Update or add the `statusLine` field:

```json
{
  "statusLine": {
    "type": "command",
    "command": "/bin/bash /Users/HOME/.claude/statusline-command.sh"
  }
}
```

Replace `/Users/HOME` with the actual home directory path (`$HOME`).

Use the Edit tool to update `~/.claude/settings.json`. Preserve all existing settings — only add or replace the `statusLine` field.

### Step 5: Report

Print a summary:

```
Status line setup complete.

  Script: ~/.claude/statusline-command.sh
  Config: ~/.claude/settings.json → statusLine.command

  Displays: Model | Git branch | Context left [████░░░░░░] 72% | Directory | Style

Restart Claude Code to activate the new status line.
```
