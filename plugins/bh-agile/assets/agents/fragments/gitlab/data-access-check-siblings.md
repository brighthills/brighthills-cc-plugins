```bash
# Get all child issues of parent and check their state
glab api projects/:id/issues/PARENT_NUMBER/links --jq '[.[] | select(.link_type == "is_child_of")] | .[].state'

# All "closed" = parent can be closed
# Any "opened" = parent stays open
```