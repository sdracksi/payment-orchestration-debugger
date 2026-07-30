# Engineering Standards

## Source Control

GitLab is the source of truth.

GitHub is a public mirror.

---

## Development Workflow

Feature Branch

↓

Merge Request

↓

Develop

↓

Release

↓

Main

---

## CI/CD

Every commit must pass the GitLab pipeline.

---

## Documentation

Documentation is required for:

- new features
- architecture changes
- infrastructure changes
- API changes

---

## Testing

Every feature should include automated tests where practical.

---

## Security

Never commit:

- passwords
- API keys
- certificates
- secrets

Secrets belong in GitLab CI Variables.