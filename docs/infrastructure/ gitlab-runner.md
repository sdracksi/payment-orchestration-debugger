# GitLab Runner

## Purpose

GitLab Runner is responsible for executing CI/CD jobs triggered by GitLab pipelines.

Without a registered runner, GitLab can create pipelines but cannot execute them.

---

## Infrastructure

MacBook

↓

GitLab Repository

↓

GitLab Runner

↓

Docker Executor

↓

Ubuntu Server

↓

Application Deployment

---

## Runner Type

Executor

Docker

Operating System

Ubuntu 22.04

Container Runtime

Docker Engine

---

## Responsibilities

The runner executes:

- Repository validation
- Ruby linting
- RSpec tests
- React tests
- Docker builds
- Security scanning
- Deployment

---

## Future Enhancements

- Multiple runners
- Tagged runners
- Separate deployment runner
- Production runner