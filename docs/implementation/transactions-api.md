# Transactions API Implementation

## Controller Flow

The `GET /api/v1/transactions` endpoint follows this flow:

1. Receive the HTTP request.
2. Query the transactions from the database.
3. Order transactions by `processed_at` in descending order.
4. Convert the transactions into the API response format.
5. Return an HTTP 200 response containing JSON.

## Routing

The Transactions API is exposed through a versioned API namespace.

Route:

GET /api/v1/transactions

Controller:

Api::V1::TransactionsController#index

## Routing Decision

The Transactions API uses Rails RESTful routing.

```ruby
resources :transactions, only: [:index]
```

Using `only: [:index]` exposes just the endpoint required for this release and avoids generating unnecessary routes.

## Serialization

A dedicated serializer class will be responsible for converting Transaction objects into the API response format.

Responsibilities:

- Select which attributes are exposed
- Format values where necessary
- Keep controllers focused on request handling

This keeps the API response contract separate from the controller implementation.

## TransactionSerializer

The TransactionSerializer is responsible for converting a Transaction model into the JSON response defined in the API contract.

The serializer does not query the database.

Its only responsibility is formatting data for API responses.

## Returning Multiple Transactions

### Problem

The endpoint currently returns a single transaction.

The API contract defines the endpoint as returning a collection of transactions.

### Design

The controller will retrieve all transactions ordered by `processed_at` in descending order.

The serializer will support serializing collections while reusing the existing single-transaction serialization logic.

### Verification

Calling:

GET /api/v1/transactions

returns a JSON array containing all transactions ordered by the newest processed transaction first.