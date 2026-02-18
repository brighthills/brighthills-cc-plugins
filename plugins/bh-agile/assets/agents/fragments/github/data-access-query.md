```bash
# List issues by label
gh issue list --repo REPO --label "type:story" --state open --json number,title,labels,state

# Get single issue details
gh issue view NUMBER --repo REPO --json number,title,body,labels,state,comments

# Search issues
gh issue list --repo REPO --search "QUERY" --json number,title,labels,state
```