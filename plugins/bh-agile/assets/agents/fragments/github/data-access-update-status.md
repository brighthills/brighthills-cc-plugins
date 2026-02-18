```bash
# Move to In Progress: remove backlog, add in-progress
gh issue edit NUMBER --repo REPO --remove-label "status:backlog" --add-label "status:in-progress"

# Move to Done: close issue and remove status label
gh issue close NUMBER --repo REPO
gh issue edit NUMBER --repo REPO --remove-label "status:in-progress"

# Reopen
gh issue reopen NUMBER --repo REPO
gh issue edit NUMBER --repo REPO --add-label "status:in-progress"
```