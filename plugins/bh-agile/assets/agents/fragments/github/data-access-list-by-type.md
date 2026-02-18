```bash
# List all epics
gh issue list --repo REPO --label "type:epic" --state all --json number,title,state

# List all stories
gh issue list --repo REPO --label "type:story" --state open --json number,title,state,labels

# List all tasks
gh issue list --repo REPO --label "type:task" --state open --json number,title,state,labels

# List tasks under a specific story (via sub-issues)
gh api repos/OWNER/REPO/issues/STORY/sub_issues --jq '.[] | {number, title, state}'
```