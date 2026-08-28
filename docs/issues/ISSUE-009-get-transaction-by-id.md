# ISSUE-009 — Get Transaction by ID

## 1. Objective

Implement an API endpoint that retrieves a single transaction by its ID.

### Endpoint

GET `/api/v1/transactions/:id`

Example:

GET `/api/v1/transactions/1`

---

## 2. Current State

The Transactions API currently supports retrieving a collection of transactions:

GET `/api/v1/transactions`

The collection endpoint supports:

- Returning transactions as JSON
- Returning transaction attributes
- Ordering transactions by `processed_at` descending
- Filtering transactions by `status`

The API does not yet provide an endpoint for retrieving a single transaction.

---

## 3. Expected Behaviour

### Existing transaction

When a transaction exists:

```text
GET /api/v1/transactions/:id

## 8. Existing API Structure

Before implementing the `show` endpoint, the existing Transactions API was inspected.

### Existing Route

The application currently has:

```text
GET /api/v1/transactions

## 9. TDD — Red Phase

A request spec was added for retrieving an existing transaction by ID.

### Test

```ruby
it "returns HTTP 200 OK for an existing transaction" do
  transaction = Transaction.first

  get "/api/v1/transactions/#{transaction.id}"

  expect(response).to have_http_status(:ok)
end

## 10. TDD — Green Phase

The Transactions API was updated to support retrieving a single transaction.

### Route Added

```text
GET /api/v1/transactions/:id

## 11. Handling Missing Transactions

A request spec was added to verify the behaviour when a transaction does not exist.

### Test

```ruby
it "returns HTTP 404 when the transaction does not exist" do
  get "/api/v1/transactions/999999"

  expect(response).to have_http_status(:not_found)
end

## 12. Verifying the Returned Transaction

A request spec was added to verify that the API returns the correct transaction.

### Test

```ruby
it "returns the requested transaction" do
  transaction = Transaction.first

  get "/api/v1/transactions/#{transaction.id}"

  expect(json["id"]).to eq(transaction.id)
  expect(json["transaction_reference"]).to eq(transaction.transaction_reference)
  expect(json["merchant_reference"]).to eq(transaction.merchant_reference)
  expect(json["status"]).to eq(transaction.status)
end

## 13. Refactor Review

The controller implementation was reviewed after all tests passed.

No refactoring was required because:

- The `index` action remains responsible for retrieving a collection of transactions.
- The `show` action is responsible for retrieving a single transaction.
- The existing `TransactionSerializer` is reused.
- The controller remains small and easy to understand.

No unnecessary abstractions were introduced.

## 14. Full Test Suite

The complete backend test suite was executed to verify that the changes introduced by ISSUE-009 did not break existing functionality.

### Command

```bash
docker compose exec backend bundle exec rspec