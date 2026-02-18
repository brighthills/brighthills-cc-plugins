GitHub sub-issues are linked via tasklist syntax in the parent body or via the sub-issues API.

```bash
# Get sub-issues of a parent issue
gh api repos/OWNER/REPO/issues/NUMBER/sub_issues --jq '.[].number'

# Get parent body to find tasklist references
gh issue view NUMBER --repo REPO --json body
```