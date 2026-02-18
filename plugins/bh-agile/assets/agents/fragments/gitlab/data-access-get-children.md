GitLab uses related issues with link type for parent/child hierarchy.

```bash
# List related issues (includes child links)
glab api projects/:id/issues/NUMBER/links

# Parse response for link_type "is_child_of" relationships
```