```bash
# 1. Close the task
glab issue close TASK

# 2. Check all sibling tasks under parent story
glab api projects/:id/issues/STORY/links --jq '[.[] | select(.link_type == "is_child_of")] | all(.state == "closed")'
# If true:
glab issue close STORY

# 3. Check all sibling stories under parent epic
glab api projects/:id/issues/EPIC/links --jq '[.[] | select(.link_type == "is_child_of")] | all(.state == "closed")'
# If true:
glab issue close EPIC
```