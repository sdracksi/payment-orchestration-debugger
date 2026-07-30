# Dashboard API

**Version:** v1
**Status:** Draft
**Related Issue:** ISSUE-005
**Milestone:** v0.2.0

---

# Overview

The Dashboard API provides high-level metrics and recent transaction activity for the Payment Orchestration Debugger.

This endpoint is intended to power the application's landing dashboard.

---

# Endpoint

```
GET /api/v1/dashboard
```

---

# Authentication

Authentication is not yet implemented.

Future versions will require JWT authentication.

---

# Request

No request body is required.

Example:

GET /api/v1/dashboard

---

# Successful Response

HTTP Status

```
200 OK
```

Example

```json
{
  "summary": {
    "total_transactions": 12458,
    "successful_transactions": 12031,
    "failed_transactions": 427,
    "average_latency_ms": 438,
    "gateway_success_rate": 96.57
  },
  "recent_transactions": [
    {
      "id": "txn_100001",
      "merchant": "Acme Electronics",
      "gateway": "Stripe",
      "status": "AUTHORIZED",
      "amount": 120.00,
      "currency": "USD",
      "processed_at": "2026-07-30T09:41:18Z"
    }
  ]
}
```

---

# Response Fields

## summary

| Field | Type | Description |
|--------|------|-------------|
| total_transactions | Integer | Total number of transactions |
| successful_transactions | Integer | Successful transactions |
| failed_transactions | Integer | Failed transactions |
| average_latency_ms | Float | Average gateway latency |
| gateway_success_rate | Float | Overall success rate |

---

## recent_transactions

Returns the latest processed transactions ordered by processing time descending.

Each transaction contains:

| Field | Type |
|--------|------|
| id | String |
| merchant | String |
| gateway | String |
| status | String |
| amount | Decimal |
| currency | String |
| processed_at | Timestamp |

---

# Errors

Currently:

```
500 Internal Server Error
```

Future versions will support:

- 401 Unauthorized
- 403 Forbidden
- 422 Validation Error

---

# Notes

This endpoint aggregates data from the transaction store.

No payment card data, CVV, or sensitive authentication information is returned.