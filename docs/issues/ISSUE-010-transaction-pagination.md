# ISSUE-010 — Implement Pagination for the Transactions API

## 1. Issue Details

- **Issue ID:** ISSUE-010
- **Title:** Implement Pagination for the Transactions API
- **Type:** Feature
- **Priority:** High
- **Target Release:** v0.4.0
- **Component:** Backend / Transactions API
- **Status:** Proposed

---

## 2. Background

The Transactions API currently returns all transactions when a client requests:

`GET /api/v1/transactions`

As the number of transactions grows, returning every record in a single response can make the API slower and use more memory and network resources than necessary.

Pagination allows clients to request a smaller group of transactions at a time.

For example, instead of retrieving 1,000 transactions in one request, a client can retrieve 20 transactions per page.

This will help the Payment Orchestration Debugger handle larger transaction datasets as the project grows.

## 3. Problem Statement

The current Transactions API does not support pagination.

This creates the following problems:

- Large datasets can produce unnecessarily large responses.
- Clients cannot request a specific page of transactions.
- The API does not provide pagination metadata, such as the total number of matching transactions.
- Future frontend transaction tables will need a predictable way to navigate through results.

## 4. Objective

Implement pagination for `GET /api/v1/transactions` while preserving the existing JSON array response format.

The API must allow clients to choose a page and page size, return pagination metadata through HTTP response headers, and continue supporting the existing status filter and transaction ordering.

## 5. Scope

### In Scope

- Support the `page` query parameter.
- Support the `per_page` query parameter.
- Use sensible defaults for missing pagination parameters.
- Limit the maximum page size.
- Apply pagination at the database query level.
- Return pagination metadata in HTTP response headers.
- Preserve the existing JSON array response body.
- Preserve the existing transaction serializer and fields.
- Keep the existing status filter working with pagination.
- Preserve the existing `processed_at DESC` ordering.
- Add request specs covering pagination behaviour.
- Update API documentation.

### Out of Scope

- Cursor-based pagination.
- Frontend pagination controls.
- Changes to the transaction database schema.
- Changes to `GET /api/v1/transactions/:id`.
- New transaction filters.
- Custom sorting options.
- Introducing a pagination gem unless implementation needs justify it.

## 6. Proposed API Design

### 6.1 Endpoint

`GET /api/v1/transactions`

### 6.2 Query Parameters

| Parameter | Description | Default | Limit |
|---|---|---|---|
| `page` | The page of transactions to retrieve | `1` | Must be a positive integer |
| `per_page` | The number of transactions per page | `20` | Maximum `100` |

### 6.3 Example Requests

Retrieve the first page using the default page size:

`GET /api/v1/transactions`

Retrieve the second page:

`GET /api/v1/transactions?page=2`

Retrieve 50 transactions per page:

`GET /api/v1/transactions?page=1&per_page=50`

Retrieve the second page of successful transactions:

`GET /api/v1/transactions?status=successful&page=2&per_page=20`

### 6.4 Response Body

**Important design decision:** The API must continue returning a plain JSON array. We will not wrap the transactions inside `data` and `meta` objects.

Example:

```json
[
  {
    "id": 123,
    "transaction_reference": "txn_001",
    "merchant_reference": "merchant_001",
    "merchant_name": "Example Merchant",
    "gateway": "example_gateway",
    "amount": 100.0,
    "currency": "ZAR",
    "status": "successful",
    "payment_method": "card",
    "latency_ms": 250,
    "processed_at": "2026-10-23T08:00:00Z"
  }
]
```

This is an illustrative example. The implementation must use the existing `TransactionSerializer` and retain the actual fields and value formats it currently returns.

### 6.5 Pagination Response Headers

The API must return these headers with the paginated response:

| Header | Meaning | Example |
|---|---|---|
| `X-Current-Page` | The page returned | `2` |
| `X-Per-Page` | The effective page size | `20` |
| `X-Total-Count` | Total matching transactions before pagination | `125` |
| `X-Total-Pages` | Total pages available | `7` |

For example, a request for page 2 with 20 transactions per page could return:

```http
X-Current-Page: 2
X-Per-Page: 20
X-Total-Count: 125
X-Total-Pages: 7
```

The values above are illustrative. Actual metadata must be calculated from the matching database records.

The total count must respect active filters. For example, when `status` is provided, `X-Total-Count` must count only transactions matching that status.

### 6.6 Pagination Behaviour

The implementation must follow these rules:

1. If `page` is missing, use page `1`.
2. If `per_page` is missing, use `20`.
3. A requested page size must never exceed `100`. Values above the limit must be capped at `100`.
4. Pagination must be applied in the database query rather than loading all records into memory first.
5. Transactions must remain ordered by `processed_at DESC`.
6. Add a deterministic secondary ordering by `id DESC` when needed so transactions with identical processing timestamps have a consistent order.
7. The existing `status` filter must work with pagination.
8. The response body must remain a plain JSON array.
9. The existing transaction fields and serialization must remain unchanged.
10. If a requested page is beyond the available results, return an empty array with accurate pagination headers.
11. Invalid or non-positive `page` and `per_page` values must be handled consistently. The implementation and tests must define the chosen behaviour before the feature is considered complete.
12. `X-Total-Pages` must be `0` when there are no matching transactions; otherwise, calculate it from the total count and effective page size.

## 7. Technical Approach

The implementation should:

- Update the existing Transactions controller to read and validate pagination parameters.
- Apply database-level offset and limit to the transaction query.
- Calculate pagination metadata from the filtered query.
- Add the pagination headers to the HTTP response.
- Reuse the existing `TransactionSerializer`.
- Avoid unnecessary dependencies.
- Keep the controller implementation readable and maintainable.

A pagination gem should only be introduced if there is a clear technical reason to use one.

## 8. Testing Requirements

Request specs must cover the following scenarios:

### Default Behaviour

- Returns the first page when no pagination parameters are supplied.
- Uses a default page size of 20.
- Returns the existing JSON array format.
- Preserves the existing transaction fields.
- Includes all required pagination headers.

### Page Navigation

- Returns the correct records for page 1.
- Returns the correct records for page 2.
- Does not return records from another page.
- Returns an empty array when the requested page has no records.

### Page Size

- Supports a custom `per_page` value.
- Never returns more than 100 transactions per page.
- Handles invalid and non-positive page sizes according to the documented behaviour.

### Filtering and Ordering

- Works with the existing `status` filter.
- Reports the total count after filtering.
- Preserves `processed_at DESC` ordering.
- Uses deterministic ordering when multiple transactions share the same processing timestamp.

### Regression Testing

- Existing transaction index request specs continue to pass.
- Existing transaction show request specs continue to pass.
- The full backend test suite passes, excluding any already documented pending examples.

## 9. Acceptance Criteria

This issue is complete when:

- [ ] `page` and `per_page` are supported.
- [ ] The default page is `1`.
- [ ] The default page size is `20`.
- [ ] The maximum page size is `100`.
- [ ] Database-level pagination is implemented.
- [ ] Pagination metadata is returned through the four documented HTTP headers.
- [ ] The response body remains a plain JSON array.
- [ ] Existing transaction serialization remains unchanged.
- [ ] Status filtering continues to work.
- [ ] Transaction ordering remains consistent.
- [ ] Invalid pagination inputs have documented and tested behaviour.
- [ ] Request specs cover normal, boundary, and regression cases.
- [ ] API documentation is updated.
- [ ] All relevant tests pass.
- [ ] The feature is merged into `develop` through a reviewed Merge Request.

## 10. Architecture Impact

- **API:** Yes
- **Backend:** Yes
- **Frontend:** No changes in this issue
- **Database:** No schema changes
- **Infrastructure:** No planned changes
- **Documentation:** Yes

### Architecture Notes

Pagination improves the scalability of the Transactions API by limiting the number of records returned per request.

Pagination must happen in the database query to avoid loading the entire transaction dataset into application memory.

Pagination metadata will be delivered through HTTP response headers to preserve compatibility with clients expecting the existing JSON array response.

If browser-based frontend code needs to read these custom headers across origins, the CORS configuration may need to expose them. Any such change should be assessed separately and added only if required.

## 11. Risk Assessment

**Risk Level:** Low to Medium

### Risks

- Incorrect offset or limit calculations could cause records to be skipped or repeated.
- Incorrect total counts could mislead clients about the number of available pages.
- Changing the response body format would break compatibility, so the existing array format must be preserved.
- Unstable ordering could cause inconsistent results when transactions share timestamps.
- Invalid pagination values could cause unexpected behaviour if they are not handled consistently.

### Mitigation

- Write request specs before implementing the feature.
- Test page boundaries and empty results.
- Test pagination together with status filtering.
- Preserve the existing serializer and response body structure.
- Use deterministic ordering.
- Verify pagination headers and run the full backend test suite.

## 12. Git Workflow

The feature must follow the project's standard workflow:

1. Document ISSUE-010.
2. Start from the latest `develop` branch.
3. Create the feature branch `feature/transaction-pagination`.
4. Write failing request specs first.
5. Implement pagination.
6. Refactor if necessary.
7. Run the relevant specs and full test suite.
8. Update API documentation.
9. Commit the changes.
10. Push the feature branch.
11. Open a feature Merge Request targeting `develop`.
12. Address review feedback and ensure CI passes.
13. Merge only after approval.
14. Include the feature in the appropriate release Merge Request to `main`.

**Important:** Do not merge the feature branch directly into `main`.

## 13. Proposed Commit Messages

- `test(api): define transaction pagination behaviour`
- `feat(api): add transaction pagination`
- `docs(api): document transaction pagination`

These are suggested commit messages; the actual commits should reflect the changes made.

## 14. Future Enhancements

Possible future work includes:

- Cursor-based pagination for very large datasets.
- Additional transaction filters.
- Allowlisted sorting options.
- Pagination links in response headers.
- Frontend pagination controls.

These enhancements are outside the scope of ISSUE-010.

---

## 15. Definition of Done

- [ ] Issue document reviewed and saved.
- [ ] Feature branch created from the latest `develop`.
- [ ] Failing request specs written first.
- [ ] Pagination implemented and tested.
- [ ] Existing API response contract preserved.
- [ ] Documentation updated.
- [ ] Changes committed and pushed.
- [ ] Feature Merge Request targets `develop`.
- [ ] CI passes and review feedback is addressed.
- [ ] Feature is merged into `develop`.
