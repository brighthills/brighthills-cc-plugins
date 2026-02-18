```bash
# Create parent/child link between issues
glab api projects/:id/issues/CHILD_NUMBER/links -f target_project_id=:id -f target_issue_iid=PARENT_NUMBER -f link_type=is_child_of
```