---
name: setup
description: Set up BrightHills Agile rules, labels, and ticket manager agent in the current project.
allowed-tools: Read, Write, Glob, Grep, Bash(mkdir:*), Bash(ls:*), Bash(glab:*), Bash(gh:*), Bash(git remote*), Bash(claude *), Bash(command -v*), Bash(npm install*), Bash(agent-browser install*), AskUserQuestion, TaskCreate, TaskUpdate, TaskList
---

# Setup

Install Agile rules, configure issue tracking labels, and generate the ticket manager agent for the current project.

## Progress Tracking

Use `TaskCreate` at the start to create tasks for each step. Update task status with `TaskUpdate` as you progress:

- Set `in_progress` when starting a step
- Set `completed` when done

Create these tasks upfront:

1. Subject: `Explore project structure` / activeForm: `Exploring project structure`
2. Subject: `Generate rules from skeletons` / activeForm: `Generating rules from skeletons`
3. Subject: `Copy static rules` / activeForm: `Copying static rules`
4. Subject: `Set up issue tracking labels` / activeForm: `Setting up issue tracking labels`
5. Subject: `Generate ticket manager agent` / activeForm: `Generating ticket manager agent`
6. Subject: `Scaffold feature documentation directory` / activeForm: `Scaffolding feature docs`
7. Subject: `Install recommended plugins` / activeForm: `Installing recommended plugins`
8. Subject: `Report setup results` / activeForm: `Reporting setup results`

## Process

### Step 1 — Explore Project Structure

Mark task `in_progress`. Thoroughly analyze the project to build a mental model:

- **Languages**: Check for `*.ts`, `*.tsx`, `*.js`, `*.jsx`, `*.py`, `*.go`, `*.rs`, `*.java`, `*.cs`, etc.
- **Source directories**: `src/`, `app/`, `lib/`, `packages/`, `server/`, `client/`, etc.
- **Test directories**: `tests/`, `test/`, `__tests__/`, `e2e/`, `spec/`, `cypress/`, etc.
- **Config files**: `package.json`, `tsconfig.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, etc.
- **Framework indicators**: `next.config.*`, `vite.config.*`, `angular.json`, `nuxt.config.*`, etc.
- **Git remote**: Run `git remote -v` to detect platform (github.com → GitHub, everything else → GitLab)
- **Existing rules**: Check `.claude/rules/` for already installed rules
- **Existing agents**: Check `.claude/agents/` for already installed agents

Summarize findings to the user before proceeding. Mark task `completed`.

### Step 2 — Generate Rules from Skeletons

Mark task `in_progress`. Read each `.md` file in `${CLAUDE_PLUGIN_ROOT}/assets/rules/skeletons/`.

Each skeleton is an instruction set — a guideline describing what a project-specific rule should cover. For each skeleton:

1. Read the skeleton file
2. Using the project context from Step 1, generate a **project-specific rule** that follows the skeleton's guidance
3. Write the generated rule to `.claude/rules/{skeleton-filename}`
4. The generated rule must include a `paths` frontmatter with glob patterns relevant to the project

If `.claude/rules/{skeleton-filename}` already exists, ask the user whether to overwrite or skip.

Mark task `completed`.

### Step 3 — Copy Static Rules

Mark task `in_progress`. Read all `.md` files directly in `${CLAUDE_PLUGIN_ROOT}/assets/rules/` (NOT in `skeletons/`).

For each static rule:

1. Read the rule file
2. Present the current `paths` value to the user
3. Suggest project-specific glob patterns based on Step 1 findings
4. Use `AskUserQuestion` to let the user confirm or customize the paths
5. Write the rule to `.claude/rules/{filename}` with the confirmed paths

If `.claude/rules/{filename}` already exists, ask the user whether to overwrite or skip.

If there are no static rules to copy, skip this step and mark task `completed` immediately.

Mark task `completed`.

### Step 4 — Set up Issue Tracking Labels

Mark task `in_progress`.

#### Detect Platform

Use the git remote from Step 1 to determine the platform:
- `github.com` in remote URL → **GitHub** (use `gh`)
- Anything else → **GitLab** (use `glab`)

#### Required Labels

| Label (GitLab) | Label (GitHub) | Color | Description |
|-----------------|----------------|-------|-------------|
| `type::epic` | `type:epic` | `#7057ff` | Epic-level work item |
| `type::story` | `type:story` | `#1068bf` | User story |
| `type::task` | `type:task` | `#6699cc` | Implementation task |
| `status::backlog` | `status:backlog` | `#e6e6e6` | Not started |
| `status::in-progress` | `status:in-progress` | `#f0ad4e` | Being worked on |
| `status::review` | `status:review` | `#5bc0de` | In QA/review |
| `status::done` | `status:done` | `#5cb85c` | Completed |

#### Idempotent Creation

1. Fetch existing labels:
   - GitLab: `glab label list`
   - GitHub: `gh label list --json name`
2. For each required label, check if it already exists (parse the output text)
3. **Only create labels that don't exist yet** — skip already present ones

**Create syntax per platform:**

GitLab (`glab` uses flags, NOT positional arguments):
```bash
glab label create -n "type::epic" -c "#7057ff" -d "Epic-level work item"
```

GitHub (`gh` uses positional name):
```bash
gh label create "type:epic" --color "7057ff" --description "Epic-level work item"
```

4. Report what was created and what was skipped

Mark task `completed`.

### Step 5 — Generate Ticket Manager Agent

Mark task `in_progress`.

#### 5a. Ask User for Configuration

Use `AskUserQuestion` to confirm:

1. **Platform**: Confirm detected platform (GitHub / GitLab) from Step 1
2. **Repository**: Suggest the repo identifier from git remote (e.g., `org/repo-name`). Let user modify if needed.

#### 5b. Read Template and Fragments

1. Read the template: `${CLAUDE_PLUGIN_ROOT}/assets/agents/agile-ticket-manager.template.md`
2. Based on the confirmed platform, read all fragment files from `${CLAUDE_PLUGIN_ROOT}/assets/agents/fragments/{platform}/`

#### 5c. Replace Placeholders

Mapping from placeholder to fragment file:

| Placeholder | Fragment file |
|-------------|---------------|
| `{{TOOLS}}` | `tools.md` |
| `{{REPO}}` | _(user-confirmed repo identifier)_ |
| `{{PROJECT_CONFIG}}` | `project-config.md` |
| `{{SEP}}` | `:` for GitHub, `::` for GitLab |
| `{{STATUS_SYSTEM}}` | `status-system.md` |
| `{{DATA_ACCESS_QUERY}}` | `data-access-query.md` |
| `{{DATA_ACCESS_CREATE}}` | `data-access-create.md` |
| `{{DATA_ACCESS_UPDATE_STATUS}}` | `data-access-update-status.md` |
| `{{DATA_ACCESS_COMMENT}}` | `data-access-comment.md` |
| `{{DATA_ACCESS_GET_CHILDREN}}` | `data-access-get-children.md` |
| `{{DATA_ACCESS_LINK_CHILD}}` | `data-access-link-child.md` |
| `{{DATA_ACCESS_CHECK_SIBLINGS}}` | `data-access-check-siblings.md` |
| `{{WORKFLOW_START_TASK}}` | `workflow-start-task.md` |
| `{{WORKFLOW_COMPLETE_TASK}}` | `workflow-complete-task.md` |
| `{{DATA_ACCESS_LIST_BY_TYPE}}` | `data-access-list-by-type.md` |

For each placeholder:
1. Read the corresponding fragment file content
2. Replace `{{PLACEHOLDER}}` in the template with the fragment content
3. For `{{REPO}}`, use the user-confirmed repo identifier
4. For `{{SEP}}`, use `:` (GitHub) or `::` (GitLab)

Also replace `REPO` and `OWNER/REPO` references within fragment content with the actual repo identifier.

#### 5d. Write Agent

1. `mkdir -p .claude/agents/`
2. Write the assembled agent to `.claude/agents/agile-ticket-manager.md`

If `.claude/agents/agile-ticket-manager.md` already exists, ask the user whether to overwrite or skip.

Mark task `completed`.

### Step 6 — Scaffold Feature Documentation Directory

Mark task `in_progress`. Create the `docs/features/` directory and populate it with starter files from the plugin assets.

#### 6a. Check if Directory Exists

If `docs/features/` already exists, ask the user whether to overwrite the starter files or skip this step entirely.

#### 6b. Create Directory

```bash
mkdir -p docs/features
```

#### 6c. Copy Starter Files

Copy all files from `${CLAUDE_PLUGIN_ROOT}/assets/docs/features/` into `docs/features/`:

| Source | Destination | Purpose |
|--------|------------|---------|
| `${CLAUDE_PLUGIN_ROOT}/assets/docs/features/README.md` | `docs/features/README.md` | Feature index — lists all documented features |
| `${CLAUDE_PLUGIN_ROOT}/assets/docs/features/CLAUDE.md` | `docs/features/CLAUDE.md` | Folder-level instructions for AI agents and developers |

Read each source file and write it to the destination. If individual files already exist, ask the user whether to overwrite or skip each one.

#### Why This Matters

- The `feature-docs` rule (`.claude/rules/feature-docs.md`) has `paths: docs/features/**` and expects this directory to exist
- `/bh-agile:plan-feature` generates output into `docs/features/[feature-slug]/`
- `/bh-agile:implement @docs/features/...` reads from this directory
- `/bh-agile:create-tickets @docs/features/...` reads from this directory

Mark task `completed`.

### Step 7 — Install Recommended Plugins

Mark task `in_progress`. Offer the user a curated list of external plugins that complement the Agile workflow.

#### 7a. Present Plugin List

Use `AskUserQuestion` with `multiSelect: true` to let the user pick which plugins to install:

| Plugin | Marketplace | Description |
|--------|-------------|-------------|
| code-simplifier | claude-plugins-official | Simplifies and refactors complex code — used during implementation review phase |
| context7 | claude-plugins-official | Up-to-date library documentation lookup via MCP — helps during implementation |
| playwright | claude-plugins-official | Browser automation via Playwright MCP — used by qa-tester agent for E2E tests |
| agent-browser | agent-browser (Vercel) | Headless browser automation for web testing, screenshots, and data extraction. **Requires CLI**: `npm install -g agent-browser && agent-browser install` |

Present all four options. The user may select any combination or skip entirely.

#### 7b. Check Prerequisites for Selected Plugins

If the user selected `agent-browser`, check if the CLI is installed:

```bash
command -v agent-browser
```

If not found, inform the user:

> `agent-browser` plugin requires the CLI to be installed first:
> ```
> npm install -g agent-browser && agent-browser install
> ```
> Install now, or skip the plugin?

Use `AskUserQuestion` to let the user choose: **Install CLI now** or **Skip agent-browser**.

If "Install CLI now", run:

```bash
npm install -g agent-browser && agent-browser install
```

#### 7c. Add External Marketplaces

If the user selected `agent-browser` (and didn't skip), register its marketplace first (the other three are in `claude-plugins-official` which is built-in):

```bash
claude -p "/plugin marketplace add https://github.com/vercel-labs/agent-browser.git"
```

#### 7d. Install Selected Plugins

For each selected plugin, run the install command via headless Claude CLI:

```bash
claude -p "/plugin install code-simplifier@claude-plugins-official"
claude -p "/plugin install context7@claude-plugins-official"
claude -p "/plugin install playwright@claude-plugins-official"
claude -p "/plugin install agent-browser@agent-browser"
```

Run each install sequentially. If an install command fails, log the error and continue with the next one — do not abort the entire step.

#### 7e. Report Install Results

After all installs complete, summarize:
- Marketplaces added (if any)
- CLI tools installed (if any)
- Successfully installed plugins
- Failed installs (with error message)
- Skipped plugins (not selected)

Mark task `completed`.

### Report

Mark report task `in_progress`. After all steps complete, list:

- Generated rules (from skeletons) with their paths
- Copied rules (static) with their paths
- Labels created / already existed (with platform)
- Agent generated (with platform and repo)
- Feature docs scaffolded (docs/features/ with starter files)
- Recommended plugins installed / failed / skipped
- Skipped files (if any)

**Always end with this notice:**

> Setup complete. Please exit Claude Code (`/exit`) and reopen it in this project for the new rules and agents to take effect.

Mark task `completed`.
