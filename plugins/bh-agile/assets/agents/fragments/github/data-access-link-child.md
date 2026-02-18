```bash
# Add sub-issue to parent
# IMPORTANT: sub_issue_id must be the numeric .id (not node_id, not issue number)
# and must be sent as integer — only --input with JSON body works correctly.
# The -f and --raw-field flags always send strings, which the API rejects (422).
CHILD_ID=$(gh api repos/OWNER/REPO/issues/CHILD_NUMBER --jq '.id')
gh api repos/OWNER/REPO/issues/PARENT_NUMBER/sub_issues \
  --method POST \
  --input <(echo "{\"sub_issue_id\": ${CHILD_ID}}")
```