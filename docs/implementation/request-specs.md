# Request Specs

## Overview

Request specs verify the API from the client's perspective by making HTTP requests against the application.

---

## Transactions Endpoint

Endpoint:

GET /api/v1/transactions

---

## Tests Implemented

### Test 1

Verify the endpoint responds successfully.

```ruby
expect(response).to have_http_status(:ok)
```

---

### Test 2

Verify the endpoint returns JSON.

```ruby
expect(response.content_type).to include("application/json")
```

---

### Test 3

Verify the endpoint returns an array.

```ruby
expect(json).to be_an(Array)
```

---

### Test 4

Verify a transaction contains all expected attributes.

```ruby
expect(json.first).to include(
  "id",
  "transaction_reference",
  "merchant_reference",
  "merchant_name",
  "gateway",
  "amount",
  "currency",
  "status",
  "payment_method",
  "latency_ms",
  "processed_at"
)
```

---

### Test 5

Verify transactions are ordered from newest to oldest.

```ruby
processed_dates = json.map do |transaction|
  Time.zone.parse(transaction["processed_at"])
end

expect(processed_dates).to eq(processed_dates.sort.reverse)
```

Expected Result:

- Transactions are returned in descending order by `processed_at`.

---

## Refactoring

The request was moved into a `before` block.

```ruby
before do
  host! "localhost"
  get "/api/v1/transactions"
end
```

The parsed JSON was moved into a helper.

```ruby
let(:json) do
  JSON.parse(response.body)
end
```

This removes duplicated code and makes each test easier to read.

---

## Lessons Learned

The request spec requires:

```ruby
before do
  host! "localhost"
end
```

Without setting the host, Rails returns HTTP 403 Forbidden.

This matches the application's host authorization configuration.