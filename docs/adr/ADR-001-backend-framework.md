# ADR-001: Backend Framework Selection

## Status

Accepted

## Date

2026-07-30

## Context

The Payment Orchestration Debugger requires a backend capable of:

- RESTful APIs
- Background jobs
- PostgreSQL support
- Redis integration
- Authentication
- Containerized deployment
- AWS deployment
- Automated testing
- Rapid feature development

## Decision

Ruby on Rails 8 (API Mode) has been selected as the backend framework.

## Rationale

Reasons include:

- Mature ecosystem
- Excellent API support
- Active Record ORM
- Strong testing ecosystem
- Excellent Docker support
- Production-ready architecture
- Rapid development
- Widely used in fintech

## Consequences

Positive

- Fast development
- Strong conventions
- Excellent documentation
- Large community

Negative

- Higher memory usage than lightweight frameworks
- Team members require Ruby knowledge