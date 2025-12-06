# Xeno FDE Internship Assignment - Submission

## 1. Assumptions & Trade-offs
*   **Pagination**: The current Shopify ingestion logic fetches the first 250 items (customers, orders, products) per sync. For a production system, we would implement cursor-based pagination to handle thousands of records. This was a trade-off for simplicity and speed.
*   **Authentication**: We use standard Devise email/password authentication. In a real multi-tenant SaaS, we might implement OAuth for Shopify App Store installation flow.
*   **Security**: Shopify Access Tokens are currently stored in the database. In a production environment, these would be encrypted using `attr_encrypted` or Rails Credentials.
*   **Background Jobs**: For this demo deployment, we are using the `Async` adapter (in-memory) for background jobs to keep the deployment **100% Free** (avoiding Redis costs). In production, we would use Sidekiq + Redis.
*   **AI Features**: The AI Analyst is currently a simulation to demonstrate the UI/UX potential without incurring LLM API costs during the review.

## 2. High-Level Architecture
```mermaid
graph TD
    User[User/Browser] -->|HTTPS| RenderLB[Render Load Balancer]
    RenderLB -->|Request| Rails[Rails Monolith (Web + API)]
    
    subgraph "Render Free Tier"
        Rails -->|Read/Write| PG[(PostgreSQL DB)]
        Rails -->|Async Job| Memory[In-Memory Queue]
    end
    
    subgraph "External APIs"
        Memory -->|Sync| Shopify[Shopify Admin API]
    end
```

## 3. Data Models
*   **Tenant**: Represents a store owner. Holds `shopify_domain` and `access_token`.
*   **Customer**: Synced from Shopify. Linked to Tenant.
*   **Order**: Synced from Shopify. Linked to Tenant & Customer.
*   **Product**: Synced from Shopify. Linked to Tenant.
*   **CustomEvent**: (Bonus) Tracks specific user actions.

## 4. API Endpoints
*   `POST /shopify/sync`: Triggers an immediate data sync.
*   `GET /dashboard`: Main analytics view.
*   `GET /api/ai/ask`: Endpoint for the AI Analyst chat.

## 5. Next Steps for Production
1.  **Redis**: Switch from `Async` to `Sidekiq` backed by Redis for robust job processing.
2.  **Pagination**: Implement full cursor-based pagination for Shopify API.
3.  **Webhooks**: Verify HMAC signatures for incoming Shopify webhooks (security).
4.  **Testing**: Add comprehensive RSpec tests for the Ingestor service.

## 6. Deployment Instructions (Render)
1.  Fork/Push this repo to your GitHub.
2.  Log in to [Render.com](https://render.com).
3.  Click **New +** -> **Blueprint**.
4.  Select this repository.
5.  Click **Apply**.
    *   Render will automatically create the Database and Web Service.
    *   It will use the `render.yaml` configuration included in this repo.
