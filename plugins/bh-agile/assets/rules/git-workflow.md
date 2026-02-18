# Git Workflow Rules

## Branching Strategy

| Branch | Purpose | Deploy Target | CI Tests |
|--------|---------|---------------|----------|
| `main` | Production-ready code | Production | - |
| `staging` | CI validation | Staging URL | Unit + Smoke |
| `develop` | Local integration hub | Vercel Preview | Unit + Typecheck |
| `feature/*` | Feature development | Vercel Preview | - |

### Flow

```
feature/XX-desc → develop → staging → main
                      ↓           ↓         ↓
                  Preview    CI Tests   Production
```

### PR Targets

- Feature branches → `develop` (default)
- Develop → `staging` (merge/sync)
- Staging → `main` (after CI passes)
- Hotfixes → `main` (urgent), then sync back

## Git Conventions

```bash
# Branch (from develop)
git checkout develop && git pull
git checkout -b feature/45-description

# Commit
git commit -m "feat: description (#45)"

# Push & open PR to develop (default target)
git push -u origin feature/45-description

# Sync to staging (after develop merge)
git checkout staging && git pull && git merge develop && git push

# Commit types: feat, fix, refactor, docs, test, chore
```

## PR Format

```markdown
## Summary
- Bullet points

## Test plan
- [ ] Tests passing
- [ ] Linting passing

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```
