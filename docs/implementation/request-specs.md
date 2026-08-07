# Request Specs

## Overview

Request specs verify the API from the client's perspective by making HTTP requests against the application.

## First Request Spec

Endpoint:

GET /api/v1/transactions

Verified:

- Endpoint responds successfully
- Returns HTTP 200 OK

## Lesson Learned

The request spec required:

```ruby
before do
  host! "localhost"
end
```

This matches the application's host authorization configuration and ensures the request is accepted during testing.