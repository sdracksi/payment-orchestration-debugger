# ISSUE-007: Transactions API

## Summary

Implement the first version of the Transactions API for the Payment Orchestration Debugger.

This API will expose transaction data for the future React frontend and provide a foundation for filtering, pagination, and monitoring payment activity.

---

## Objectives

- Create transaction seed data
- Implement transaction serializer
- Implement transaction listing endpoint
- Implement transaction details endpoint
- Add filtering support
- Add pagination
- Add request specs

---

## Endpoints

### List Transactions

GET /api/v1/transactions

### Get Transaction

GET /api/v1/transactions/:id

---

## Filtering

Support filtering by:

- Status
- Gateway
- Merchant

---

## Acceptance Criteria

- Transactions can be listed
- Individual transactions can be retrieved
- JSON responses are consistent
- Filters return expected results
- Pagination works correctly
- Request specs pass
- Seed data is available