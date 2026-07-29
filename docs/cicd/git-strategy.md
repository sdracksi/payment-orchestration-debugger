# Git Strategy

## Overview

This project follows a Git Flow-inspired branching strategy designed to support professional software development, continuous integration, and continuous deployment.

GitLab serves as the primary engineering platform for source control, code reviews, issue tracking, and CI/CD.

GitHub serves as the public mirror for showcasing the project portfolio.

---

# Repository Strategy

## GitLab

**Purpose**

- Primary source of truth
- Merge Requests
- CI/CD Pipelines
- Issue Tracking
- Deployment Automation
- Private collaboration

Repository

```
git@local:shad/payment-orchestration-debugger.git
```

---

## GitHub

**Purpose**

- Public portfolio
- Documentation
- Open Source showcase
- Recruiter visibility

Repository

```
git@github.com:sdracksi/payment-orchestration-debugger.git
```

GitHub is automatically synchronized from GitLab after successful builds or releases.

---

# Branching Strategy

The project uses a simplified Git Flow model.

```
main
│
develop
│
├── feature/*
├── bugfix/*
├── hotfix/*
└── release/*
```

---

# Main Branch

The **main** branch always represents production-ready code.

Rules

- Protected branch
- No direct commits
- Changes only through Merge Requests
- Every commit must pass CI

Example

```
main
```

---

# Develop Branch

The **develop** branch contains the latest integrated development work.

All feature branches merge into **develop**.

Example

```
develop
```

---

# Feature Branches

Every new feature is developed in its own branch.

Naming Convention

```
feature/dashboard

feature/search

feature/payment-timeline

feature/api-authentication

feature/docker

feature/aws-deployment
```

Example workflow

```
develop

↓

feature/dashboard

↓

Merge Request

↓

develop
```

---

# Bug Fix Branches

Used for fixing defects discovered during development.

Naming Convention

```
bugfix/transaction-search

bugfix/tokenization

bugfix/api-validation
```

---

# Hotfix Branches

Hotfix branches are created directly from **main** when production issues need immediate attention.

Naming Convention

```
hotfix/security-header

hotfix/docker-build
```

After release

```
main

↓

hotfix

↓

main

↓

develop
```

---

# Release Branches

Release branches prepare production deployments.

Naming Convention

```
release/v1.0

release/v1.1

release/v2.0
```

Only

- Documentation
- Version changes
- Minor fixes

should be added during release preparation.

---

# Commit Message Convention

This project follows the Conventional Commits specification.

Examples

```
feat: add payment timeline

feat(api): add transaction endpoint

fix: resolve Redis connection issue

docs: update deployment guide

refactor: simplify payment service

test: add transaction request specs

ci: configure GitLab pipeline

build: update Docker image

chore: initialize project structure
```

---

# Merge Requests

Every change must be submitted through a Merge Request.

Requirements

- CI pipeline passes
- No merge conflicts
- Code reviewed
- Documentation updated when applicable

Merge strategy

- Squash commits
- Delete source branch after merge

---

# Versioning

Semantic Versioning will be used.

```
MAJOR.MINOR.PATCH
```

Example

```
1.0.0

1.1.0

1.1.2

2.0.0
```

---

# GitLab CI/CD

Every push triggers the pipeline.

Pipeline stages

```
Lint

↓

Tests

↓

Security Scan

↓

Docker Build

↓

Deploy

↓

Mirror to GitHub
```

Branches

| Branch | Action |
|---------|--------|
| feature/* | Build + Test |
| develop | Build + Test + Deploy to Development |
| release/* | Build + Test + Staging |
| main | Build + Test + Production Deployment |

---

# GitHub Synchronization

GitHub mirrors the stable state of the repository.

Synchronization occurs after:

- Successful release
- Successful deployment
- Successful pipeline

GitHub is not used for deployment.

GitLab remains the authoritative repository.

---

# Deployment Workflow

```
Developer

↓

Feature Branch

↓

GitLab

↓

Merge Request

↓

CI Pipeline

↓

Docker Image

↓

Ubuntu Server

↓

AWS EC2 (Future)

↓

Mirror to GitHub
```

---

# Repository Protection

Protected branches

- main
- develop

Rules

- No force pushes
- No direct commits
- Merge Requests required
- Successful CI required before merge

---

# Code Ownership

Future development will define CODEOWNERS for:

- API
- Frontend
- Infrastructure
- Documentation

---

# Tags

Production releases will be tagged.

Example

```
v1.0.0

v1.1.0

v1.2.0

v2.0.0
```

---

# Long-Term Vision

The repository should reflect professional engineering practices used by modern software organizations.

Development will emphasize:

- Clean Git history
- Feature isolation
- Automated testing
- Continuous Integration
- Continuous Deployment
- Infrastructure as Code
- Comprehensive documentation
- Secure software delivery