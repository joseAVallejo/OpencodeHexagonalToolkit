# Permissions

Document every permission introduced or changed by a feature and record its
frontend/backend locations, protected operation and policy reference.

## Template

```markdown
## PERMISSION.NAME
### Client
- `path/to/component`
### Server
- `path/to/controller-or-handler`
- Operation: `METHOD /path` or equivalent protocol action
- Policy: `PolicyName`
```

Use the names and authorization mechanisms defined by the active repository.
Do not document secrets or sensitive configuration values.
