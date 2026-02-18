```bash
# Get all sub-issues of parent and check their state
gh api repos/OWNER/REPO/issues/PARENT_NUMBER/sub_issues --jq '.[].state'

# All closed = parent can be closed
# Any open = parent stays open
```