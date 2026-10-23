# Transactions API

## Overview

The Transactions API provides endpoints to retrieve transaction records and individual transactions.

## List Transactions

**Endpoint:** `GET /api/v1/transactions`

Returns a JSON array of transactions. The endpoint supports pagination and an optional status filter.

### Query Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `page` | Integer | `1` | Page number. Values must be positive integers; invalid or non-positive values default to `1`. |
| `per_page` | Integer | `20` | Number of transactions per page. Invalid or non-positive values default to `20`. The maximum is `100`. |
| `status` | String | None | Optional filter to return transactions with the specified status. |

If `per_page` exceeds `100`, the API limits it to `100`.

### Pagination Response Headers

The response includes the following headers:

| Header | Description |
|---|---|
| `X-Current-Page` | Current page number. |
| `X-Per-Page` | Number of transactions requested per page, after applying defaults and limits. |
| `X-Total-Count` | Total number of matching transactions before pagination. The status filter is applied when provided. |
| `X-Total-Pages` | Total number of pages available. Returns `0` when there are no matching transactions. |

### Example Request

```http
GET /api/v1/transactions?page=2&per_page=10
```

### Example Response

The response body remains a JSON array to preserve compatibility with existing clients.

```json
[
  {
    "id": 123,
    "transaction_reference": "txn_example",
    "merchant_reference": "merchant_example",
    "merchant_name": "Example Merchant",
    "gateway": "example_gateway",
    "amount": "100.00",
    "currency": "ZAR",
    "status": "successful",
    "payment_method": "card",
    "latency_ms": 250,
    "processed_at": "2026-10-23T08:00:00Z"
  }
]
```

The values above are illustrative.

Example pagination headers:

```http
X-Current-Page: 2
X-Per-Page: 10
X-Total-Count: 45
X-Total-Pages: 5
```

### Pagination Behaviour

- Transactions are ordered by `processed_at` descending, with `id` descending as a tie-breaker.
- Pagination is performed at the database level.
- The total count reflects the status filter, if supplied.
- Requesting a page beyond the available results returns an empty JSON array with pagination headers.
- Invalid or non-positive `page` and `per_page` values use their respective defaults.

## Retrieve a Transaction

**Endpoint:** `GET /api/v1/transactions/:id`

Retrieves a single transaction by its ID.

- Returns the serialized transaction when it exists.
- Returns HTTP `404 Not Found` when the transaction does not exist.
