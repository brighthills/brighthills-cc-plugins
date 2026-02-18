```bash
# List all epics
glab issue list --label "type::epic" --all

# List all stories
glab issue list --label "type::story"

# List all tasks
glab issue list --label "type::task"

# List tasks under a specific story (via child links)
glab api projects/:id/issues/STORY/links --jq '[.[] | select(.link_type == "is_child_of")] | .[] | {iid, title, state}'
```