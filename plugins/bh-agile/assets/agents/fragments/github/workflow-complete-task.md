```bash
# 1. Close the task
gh issue close TASK --repo REPO
gh issue edit TASK --repo REPO --remove-label "status:in-progress"

# 2. Check all sibling tasks under parent story
SIBLINGS=$(gh api repos/OWNER/REPO/issues/STORY/sub_issues --jq '.[].state')
# If all "closed":
gh issue close STORY --repo REPO
gh issue edit STORY --repo REPO --remove-label "status:in-progress"

# 3. Check all sibling stories under parent epic
SIBLINGS=$(gh api repos/OWNER/REPO/issues/EPIC/sub_issues --jq '.[].state')
# If all "closed":
gh issue close EPIC --repo REPO
gh issue edit EPIC --repo REPO --remove-label "status:in-progress"
```