# Backend Architecture

**Project:** Payment Orchestration Debugger  
**Version:** 1.0  
**Last Updated:** 2026-07-30  
**Status:** Draft

---

# Overview

The Payment Orchestration Debugger backend is responsible for ingesting, processing, storing, and exposing payment transaction data through a secure REST API.

The application is designed to help developers, support engineers, and payment operations teams investigate payment failures, visualize transaction flows, and troubleshoot gateway integrations.

The backend follows a modular, API-first architecture built with Ruby on Rails 8 running in API mode.

---

# Architecture Goals

The backend is designed to achieve the following objectives:

- Provide a secure REST API
- Process large numbers of payment transactions
- Support multiple payment gateway integrations
- Maintain clear separation of responsibilities
- Be containerized for local development and deployment
- Support automated testing and continuous integration
- Be cloud-ready for future AWS deployment
- Be easy to extend with new payment providers

---

# High-Level Architecture

```
                        +----------------------+
                        |   React Frontend     |
                        +----------+-----------+
                                   |
                              HTTPS / JSON
                                   |
                                   ▼
+----------------------------------------------------------+
|                 Ruby on Rails API                        |
|----------------------------------------------------------|
| Controllers                                              |
| Services                                                 |
| Models                                                   |
| Background Jobs                                          |
| Authentication                                            |
| Logging                                                  |
+-----------+-------------------------+--------------------+
            |                         |
            |                         |
            ▼                         ▼
    PostgreSQL Database          Redis Cache
            |                         |
            |                         |
            +------------+------------+
                         |
                  Background Jobs
```

---

# Technology Stack

| Component | Technology |
|-----------|------------|
| Framework | Ruby on Rails 8 (API Mode) |
| Language | Ruby 3.4+ |
| Database | PostgreSQL |
| Cache | Redis |
| Background Jobs | Solid Queue (Rails default) |
| Authentication | JWT (planned) |
| Testing | RSpec |
| Linting | RuboCop |
| API Documentation | OpenAPI (planned) |
| Containerization | Docker |
| CI/CD | GitLab CI |
| Deployment | AWS (future) |

---

# Request Lifecycle

Every API request follows the same processing flow.

```
Client

    │

    ▼

Rails Router

    │

    ▼

Controller

    │

Authentication

    │

Validation

    │

Service Object

    │

Business Logic

    │

Database / Redis

    │

Serializer

    │

JSON Response
```

This separation keeps controllers lightweight and business logic reusable.

---

# Application Layers

## Controllers

Controllers are responsible for:

- Accepting HTTP requests
- Validating request parameters
- Invoking service objects
- Returning JSON responses
- Handling HTTP status codes

Controllers should contain minimal business logic.

---

## Service Objects

Business logic belongs inside service objects.

Examples:

```
TransactionImporter
GatewayResponseParser
PaymentDebugger
RetryAnalyzer
TransactionSearch
```

Service objects make functionality reusable and easier to test.

---

## Models

Active Record models represent persistent domain entities.

Examples:

- Transaction
- Merchant
- Gateway
- Customer
- PaymentMethod
- Event

Models contain validation and relationships but avoid complex orchestration logic.

---

## Background Jobs

Long-running tasks execute asynchronously.

Examples include:

- Importing transaction files
- Processing webhook events
- Rebuilding search indexes
- Scheduled cleanup tasks

Background jobs improve responsiveness and scalability.

---

# Database

PostgreSQL is the primary data store.

Reasons for selecting PostgreSQL include:

- ACID compliance
- Excellent indexing
- JSONB support
- Strong performance
- Mature ecosystem
- Widely used in financial systems

Database migrations will be managed using Rails migrations.

---

# Redis

Redis will be used for:

- Caching
- Session storage (if required)
- Rate limiting
- Background job processing
- Temporary transaction state

Redis should never be considered the system of record.

---

# API Design

The backend exposes RESTful endpoints.

Example:

```
GET    /api/v1/transactions
GET    /api/v1/transactions/:id
POST   /api/v1/import
GET    /api/v1/health
```

API versioning will use URL versioning.

Example:

```
/api/v1/
/api/v2/
```

---

# Error Handling

The API returns consistent JSON error responses.

Example:

```json
{
  "error": {
    "code": "transaction_not_found",
    "message": "Transaction could not be located."
  }
}
```

Unexpected exceptions will be logged and return a generic internal server error response.

Sensitive implementation details will never be exposed to clients.

---

# Authentication

Authentication will initially be disabled during early development.

Future implementation will use:

- JWT access tokens
- Role-based authorization
- API keys for service integrations

---

# Logging

Application logs should provide sufficient information for troubleshooting while avoiding sensitive payment data.

Logging principles:

- Structured logs
- Request IDs for correlation
- Log levels (INFO, WARN, ERROR)
- No cardholder data
- No CVV values
- No secrets or API credentials

---

# Security Principles

The backend will follow secure development practices.

Examples include:

- HTTPS only
- Strong parameter validation
- SQL injection protection
- CSRF protection where applicable
- Secure secrets management
- Least privilege access

---

# Testing Strategy

Testing is part of the development workflow.

Test types include:

- Unit tests
- Request specs
- Service object tests
- Model tests
- Integration tests

Every merge request should pass all automated tests before merging.

---

# Containerization

The backend runs inside Docker during development.

Primary containers:

- Rails API
- PostgreSQL
- Redis

Docker Compose orchestrates the local development environment.

---

# Continuous Integration

GitLab CI is responsible for:

- Linting
- Running automated tests
- Validating repository structure
- Building Docker images
- Future security scanning

Pipelines must pass before code is merged into protected branches.

---

# Future AWS Deployment

The backend is designed for cloud deployment.

Target AWS services include:

| Component | AWS Service |
|----------|-------------|
| Compute | Amazon ECS |
| Database | Amazon RDS PostgreSQL |
| Cache | Amazon ElastiCache for Redis |
| Object Storage | Amazon S3 |
| Secrets | AWS Secrets Manager |
| Monitoring | Amazon CloudWatch |
| Container Registry | Amazon ECR |

---

# Design Principles

The backend follows these engineering principles:

- API-first development
- Convention over configuration
- Separation of concerns
- Stateless application design
- Twelve-Factor App methodology
- Automated testing
- Continuous Integration
- Infrastructure as Code (future)

---

# Future Enhancements

Planned capabilities include:

- Payment gateway adapters
- Webhook ingestion
- Transaction replay
- Search and filtering
- Audit history
- Role-based access control
- OpenAPI documentation
- Metrics and observability
- Distributed tracing

---

# References

- ADR-001: Backend Framework Selection
- Technology Decisions
- API Design Specification