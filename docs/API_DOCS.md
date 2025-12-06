# API Documentation

Base URL: `/api/v1` (Concept - currently routes are dashboard based)

## Webhook Endpoints

Shopify sends events to these endpoints. Verification is handled via HMAC signature.

### Orders
*   `POST /shopify/webhooks/orders/create`
    *   **Payload:** JSON Order Object
    *   **Action:** Creates or updates order record.

### Customers
*   `POST /shopify/webhooks/customers/create`
    *   **Payload:** JSON Customer Object
    *   **Action:** Upserts customer profile.

### Products
*   `POST /shopify/webhooks/products/create`
    *   **Payload:** JSON Product Object
    *   **Action:** Syncs product catalog.

## Health Check

*   `GET /up`
    *   **Response:** `200 OK`
    *   **Body:** `{ "status": "ok", "database": true, "redis": true }`
    *   **Use Case:** Load balancer health checks (k8s/AWS).

## AI Studio API (Internal)

*   `POST /ai/ask`
    *   **Params:** `prompt` (String)
    *   **Response:** JSON `{ "answer": "...", "sql": "SELECT...", "data": [...] }`
