```bash
# Move to In Progress (scoped labels auto-replace previous status)
glab issue update NUMBER --label "status::in-progress"

# Move to Done: close issue
glab issue close NUMBER

# Reopen
glab issue reopen NUMBER
glab issue update NUMBER --label "status::in-progress"
```