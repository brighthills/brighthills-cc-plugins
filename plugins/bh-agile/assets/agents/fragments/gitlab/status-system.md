Status is tracked via scoped labels. Issues are `opened` or `closed` (GitLab state).

| Status | Label | GitLab State |
|--------|-------|--------------|
| Backlog | `status::backlog` | opened |
| In Progress | `status::in-progress` | opened |
| Done | _(no status label)_ | closed |

Scoped labels (`status::`) are mutually exclusive — adding one removes the other automatically.
When moving to "Done", close the issue. The status label is removed automatically.