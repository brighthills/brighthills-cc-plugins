```bash
# 1. Move task to in-progress
gh issue edit TASK --repo REPO --remove-label "status:backlog" --add-label "status:in-progress"

# 2. Check parent story status
STORY_STATE=$(gh issue view STORY --repo REPO --json labels --jq '.labels[].name | select(startswith("status:"))')
# If "status:backlog", propagate up:
gh issue edit STORY --repo REPO --remove-label "status:backlog" --add-label "status:in-progress"

# 3. Check parent epic status (same logic)
EPIC_STATE=$(gh issue view EPIC --repo REPO --json labels --jq '.labels[].name | select(startswith("status:"))')
gh issue edit EPIC --repo REPO --remove-label "status:backlog" --add-label "status:in-progress"
```