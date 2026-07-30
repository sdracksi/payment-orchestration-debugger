# Local Development Guide

**Project:** Payment Orchestration Debugger  
**Version:** 1.0  
**Last Updated:** 2026-07-30

---

# Purpose

This document describes how to set up and run the Payment Orchestration Debugger locally.

The project uses Docker to provide a consistent development environment across all developer machines.

The development environment consists of:

- Ruby on Rails 8 API
- PostgreSQL 17
- Redis 8
- Docker Compose

---

# Prerequisites

Ensure the following tools are installed:

| Tool | Version |
|------|---------|
| Ruby | 3.4.7 |
| Rails | 8.1.1 |
| Docker Desktop | Latest |
| Docker Compose | Latest |
| Git | Latest |

Verify your installation:

```bash
ruby --version
rails --version
docker --version
docker compose version
git --version
```

---

# Repository Structure

```
payment-orchestration-debugger/
│
├── backend/
├── frontend/
├── infrastructure/
├── docs/
└── docker-compose.yml
```

---

# Environment Variables

Copy the example environment file:

```bash
cp backend/.env.example backend/.env
```

The `.env` file is used only for local development.

Do **not** commit this file.

---

# Docker Architecture

The local development environment uses Docker Compose to orchestrate multiple services.

```
                    Docker Compose

      +----------------+      +----------------+
      | Rails API      | ---> | PostgreSQL     |
      +----------------+      +----------------+
               |
               |
               ▼
        +----------------+
        | Redis          |
        +----------------+
```

---

# Docker Services

## Backend

Runs the Ruby on Rails API.

Responsibilities:

- REST API
- Business logic
- Database access
- Background jobs

Container:

```
payment-debugger-api
```

---

## PostgreSQL

Primary relational database.

Container:

```
payment-debugger-db
```

Persistent storage:

```
postgres_data
```

---

## Redis

Used for:

- Caching
- Background jobs
- Temporary application data

Container:

```
payment-debugger-redis
```

Persistent storage:

```
redis_data
```

---

# Dockerfiles

The project contains two Dockerfiles.

## Dockerfile

Purpose:

Production deployments.

Characteristics:

- Optimized image
- Multi-stage build
- Smaller final image
- Suitable for AWS deployment

---

## Dockerfile.dev

Purpose:

Local development.

Characteristics:

- Faster builds
- Includes development dependencies
- Supports source code mounting
- Optimized for developer productivity

---

# Starting the Development Environment

Build the containers:

```bash
docker compose build
```

Start the environment:

```bash
docker compose up
```

Or build and start in one command:

```bash
docker compose up --build
```

Run in the background:

```bash
docker compose up -d
```

---

# Stopping the Environment

Stop the containers:

```bash
docker compose down
```

Remove containers and volumes:

```bash
docker compose down -v
```

---

# Database Setup

Create the database:

```bash
docker compose exec backend bin/rails db:create
```

Run migrations:

```bash
docker compose exec backend bin/rails db:migrate
```

Seed the database (future):

```bash
docker compose exec backend bin/rails db:seed
```

---

# Running the Rails Server

If the containers are already running:

```
http://localhost:3000
```

The API will be accessible from:

```
http://localhost:3000
```

---

# Running Tests

Execute the test suite:

```bash
docker compose exec backend bundle exec rspec
```

Run a single spec:

```bash
docker compose exec backend bundle exec rspec spec/path/to/spec.rb
```

---

# Code Quality

Run RuboCop:

```bash
docker compose exec backend bundle exec rubocop
```

Run Brakeman:

```bash
docker compose exec backend bundle exec brakeman
```

---

# Viewing Logs

View all logs:

```bash
docker compose logs
```

Follow logs:

```bash
docker compose logs -f
```

Backend only:

```bash
docker compose logs -f backend
```

---

# Rebuilding Containers

After changing dependencies or the Dockerfile:

```bash
docker compose down
docker compose build
docker compose up
```

---

# Persistent Volumes

The project uses Docker volumes to persist data between container restarts.

| Volume | Purpose |
|---------|---------|
| postgres_data | PostgreSQL data |
| redis_data | Redis persistence |
| bundle_cache | Installed Ruby gems |

---

# Development Workflow

Every feature should follow the same workflow.

```
Create Issue
      │
      ▼
Create Feature Branch
      │
      ▼
Implement Feature
      │
      ▼
Run Tests
      │
      ▼
Run RuboCop
      │
      ▼
Commit
      │
      ▼
Push
      │
      ▼
GitLab CI Pipeline
      │
      ▼
Merge Request
      │
      ▼
Code Review
      │
      ▼
Merge into develop
```

---

# Troubleshooting

## Rebuild all containers

```bash
docker compose down -v
docker compose up --build
```

---

## Remove unused Docker resources

```bash
docker system prune
```

---

## Verify PostgreSQL connectivity

```bash
docker compose exec postgres pg_isready
```

---

## Verify Redis connectivity

```bash
docker compose exec redis redis-cli ping
```

Expected output:

```
PONG
```

---

# Related Documentation

- `docs/architecture/backend-architecture.md`
- `docs/architecture/technology-decisions.md`
- `docs/adr/ADR-001-backend-framework.md`