# Technology Decisions

**Project:** Payment Orchestration Debugger  
**Version:** 1.0  
**Last Updated:** 2026-07-30  
**Status:** Draft

---

# Purpose

This document records the key technology decisions made for the Payment Orchestration Debugger project.

For each technology, we document:

- Why it was selected
- Alternatives considered
- Trade-offs
- Future considerations

This helps maintain consistency as the project grows and provides context for future contributors.

---

# Decision Summary

| Area | Technology | Status |
|------|------------|--------|
| Backend Framework | Ruby on Rails 8 (API Mode) | Accepted |
| Frontend Framework | React + TypeScript | Accepted |
| Database | PostgreSQL | Accepted |
| Cache | Redis | Accepted |
| Background Jobs | Solid Queue | Accepted |
| API Style | REST | Accepted |
| Containerization | Docker | Accepted |
| CI/CD | GitLab CI | Accepted |
| Source Control | GitLab (Primary), GitHub (Mirror) | Accepted |
| Testing | RSpec, React Testing Library | Planned |
| Linting | RuboCop, ESLint | Planned |
| Deployment | AWS | Planned |
| Monitoring | CloudWatch, OpenTelemetry | Planned |

---

# Backend Framework

## Selected

**Ruby on Rails 8 (API Mode)**

### Why

Rails provides a mature, opinionated framework that accelerates API development through convention over configuration.

Benefits include:

- Mature ecosystem
- Strong community support
- Excellent PostgreSQL integration
- Built-in ORM (Active Record)
- Robust testing support
- Secure defaults
- Rapid development
- Well suited for business applications

### Alternatives Considered

- Express.js
- NestJS
- Spring Boot
- ASP.NET Core
- Django

### Trade-offs

**Pros**

- Fast development
- Clear conventions
- Rich ecosystem
- Excellent documentation

**Cons**

- Higher memory usage
- Smaller talent pool than JavaScript
- Less flexible than minimal frameworks

---

# Frontend Framework

## Selected

**React + TypeScript**

### Why

React provides a component-based architecture that is ideal for building responsive, data-driven user interfaces.

TypeScript improves reliability through static type checking.

Benefits include:

- Large ecosystem
- Reusable components
- Strong TypeScript support
- Excellent tooling
- Widely adopted

### Alternatives Considered

- Vue.js
- Angular
- Svelte

### Trade-offs

**Pros**

- Flexible architecture
- Large community
- Excellent developer tooling

**Cons**

- Requires additional libraries for routing and state management
- Learning curve for hooks and advanced patterns

---

# Database

## Selected

**PostgreSQL**

### Why

PostgreSQL is a powerful relational database with strong consistency guarantees and advanced data types.

Benefits include:

- ACID compliance
- JSONB support
- Strong indexing
- Excellent performance
- Mature tooling
- Open source

### Alternatives Considered

- MySQL
- MariaDB
- MongoDB

### Trade-offs

**Pros**

- Reliable
- Feature-rich
- Excellent SQL compliance

**Cons**

- More complex administration than lightweight databases

---

# Cache

## Selected

**Redis**

### Why

Redis provides high-performance, in-memory data storage suitable for caching and asynchronous processing.

Planned uses include:

- Background jobs
- Response caching
- Rate limiting
- Temporary data

### Alternatives Considered

- Memcached
- Database caching

### Trade-offs

**Pros**

- Extremely fast
- Mature ecosystem
- Supports multiple data structures

**Cons**

- Data is memory-based
- Requires additional infrastructure

---

# Background Jobs

## Selected

**Solid Queue**

### Why

Solid Queue is the default Active Job backend introduced with modern versions of Rails.

Benefits include:

- Native Rails integration
- Simple configuration
- Database-backed queues
- No additional infrastructure required for initial development

### Future Considerations

As workload grows, the project may evaluate Sidekiq if higher throughput or Redis-backed job processing becomes necessary.

---

# API Design

## Selected

**REST**

### Why

REST is well understood and aligns with the application's CRUD-oriented operations.

Benefits include:

- Simplicity
- Broad tooling support
- Easy integration
- Clear resource modeling

### Alternatives Considered

- GraphQL
- gRPC

### Future Considerations

GraphQL may be introduced for specialized client requirements if needed.

---

# Containerization

## Selected

**Docker**

### Why

Docker provides a consistent execution environment across development, CI, and production.

Benefits include:

- Environment consistency
- Simplified onboarding
- Isolation
- Repeatable builds

### Alternatives Considered

- Native installations
- Podman

---

# CI/CD

## Selected

**GitLab CI**

### Why

GitLab CI integrates directly with the project's primary source repository.

Benefits include:

- Native Merge Request integration
- Pipeline automation
- Self-hosted runner support
- Built-in security scanning
- Artifact management

### Alternatives Considered

- GitHub Actions
- Jenkins
- CircleCI

---

# Source Control

## Selected

**GitLab (Primary)**

**GitHub (Mirror)**

### Why

GitLab serves as the development platform, while GitHub provides a public portfolio mirror.

Benefits include:

- Self-hosted control
- Integrated CI/CD
- Professional portfolio visibility
- Redundancy

---

# Testing

## Planned

Backend

- RSpec
- FactoryBot
- Faker

Frontend

- React Testing Library
- Vitest

Future

- End-to-end testing with Playwright

---

# Code Quality

## Planned

Backend

- RuboCop
- Brakeman

Frontend

- ESLint
- Prettier

Future

- Dependabot (or GitLab Dependency Scanning)
- Secret detection
- SAST scanning

---

# Deployment

## Planned

The application will be deployed on AWS.

Target architecture:

| Component | AWS Service |
|-----------|-------------|
| Containers | Amazon ECS |
| Database | Amazon RDS PostgreSQL |
| Cache | Amazon ElastiCache |
| Images | Amazon ECR |
| Object Storage | Amazon S3 |
| Monitoring | Amazon CloudWatch |
| Secrets | AWS Secrets Manager |

---

# Decision Review Process

Technology decisions should be reviewed when:

- Performance requirements change
- Security requirements change
- Operational complexity increases
- Significant new framework capabilities become available

Major changes should be documented through a new Architecture Decision Record (ADR).

---

# Related Documents

- ADR-001: Backend Framework Selection
- Backend Architecture
- API Design
- Local Development Guide