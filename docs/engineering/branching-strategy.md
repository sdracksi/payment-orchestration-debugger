# Branching Strategy

This project follows a GitFlow-inspired branching strategy.

## Long-lived Branches

### main

Production-ready code.

Protected branch.

### develop

Integration branch for active development.

Protected branch.

---

## Feature Branches

Format

feature/<feature-name>

Examples

feature/payment-debugger-ui

feature/transaction-search

feature/dashboard

---

## Bug Fixes

Format

bugfix/<bug-name>

Examples

bugfix/request-parser

bugfix/redis-timeout

---

## Hotfixes

Format

hotfix/<issue>

Examples

hotfix/auth-timeout

hotfix/payment-failure

---

## Releases

Format

release/v<major>.<minor>.<patch>

Examples

release/v1.0.0

release/v1.1.0

---

## Rules

- Use lowercase.
- Separate words with hyphens.
- No spaces.
- No underscores.
- Keep names short and descriptive.