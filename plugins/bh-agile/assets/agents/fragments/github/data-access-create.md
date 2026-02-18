```bash
# Create an issue
gh issue create --repo REPO \
  --title "Issue title" \
  --label "type:story" \
  --label "status:backlog" \
  --body "Issue description"

# Create with assignee
gh issue create --repo REPO \
  --title "Issue title" \
  --label "type:task" \
  --assignee "@me" \
  --body "Description"
```