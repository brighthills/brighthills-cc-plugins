```bash
# 1. Move task to in-progress (scoped label auto-replaces)
glab issue update TASK --label "status::in-progress"

# 2. Check parent story — if backlog, propagate up
glab issue view STORY --output json | # check labels
glab issue update STORY --label "status::in-progress"

# 3. Check parent epic — same logic
glab issue view EPIC --output json | # check labels
glab issue update EPIC --label "status::in-progress"
```