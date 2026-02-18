```bash
# Create an issue
glab issue create \
  --title "Issue title" \
  --label "type::story" \
  --label "status::backlog" \
  --description "Issue description"

# Create with assignee
glab issue create \
  --title "Issue title" \
  --label "type::task" \
  --assignee "@me" \
  --description "Description"
```