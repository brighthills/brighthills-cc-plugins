```bash
# Add sub-issue to parent
gh api repos/OWNER/REPO/issues/PARENT_NUMBER/sub_issues -f sub_issue_id=CHILD_NODE_ID

# Alternative: Edit parent body to include tasklist
gh issue view PARENT --repo REPO --json body
# Append to body: - [ ] #CHILD_NUMBER
```