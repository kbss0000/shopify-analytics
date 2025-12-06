# Shopify Analytics Dashboard

A multi-tenant Rails SaaS application that allows Shopify store owners to connect their stores and view analytics.

## Features

- **Multi-tenant Architecture**: Each Shopify store is a separate tenant
- **Devise Authentication**: Secure login for store owners
- **Shopify Integration**: Sync customers, orders, and products via Shopify Admin API
- **Analytics Dashboard**: View key metrics including:
  - Total customers, orders, and revenue
  - Orders grouped by date with filters
  - Top 5 customers by spend
- **Background Sync**: Scheduled jobs to keep data fresh
- **Webhook Support**: Real-time updates from Shopify

## Tech Stack

- **Framework**: Ruby on Rails 7.0
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Background Jobs**: Sidekiq
- **HTTP Client**: Faraday
- **Charts**: Chartkick
- **CSS**: Tailwind CSS

## Setup

### Prerequisites

- Ruby 3.2.2
- PostgreSQL
- Redis (for Sidekiq)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd shopify-analytics

# Install dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start Redis (required for Sidekiq)
redis-server

# Start Sidekiq
bundle exec sidekiq

# Start Rails server
rails server
```

Visit `http://localhost:3000` to access the application.

## Environment Variables

Create a `.env` file in the root directory:

```
DATABASE_URL=postgresql://localhost/shopify_analytics_development
REDIS_URL=redis://localhost:6379/0
```

## Deployment

This application is configured for deployment on Render or Railway.

### Render

1. Connect your GitHub repository
2. Set environment variables
3. Deploy

### Railway

1. Connect your GitHub repository
2. Add PostgreSQL and Redis services
3. Set environment variables
4. Deploy

## Usage

1. **Sign Up**: Create a tenant account
2. **Connect Shopify**: Enter your Shopify domain and access token
3. **Sync Data**: Trigger initial data sync
4. **View Dashboard**: Access analytics and insights

## Data Models

- **Tenant**: Store owner account with Shopify credentials
- **Customer**: Shopify customers belonging to a tenant
- **Order**: Shopify orders with revenue data
- **Product**: Shopify products catalog
- **CustomEvent**: Optional custom event tracking

## API Integration

### Getting Shopify Access Token

To connect your Shopify store, you'll need:
1. Shop domain (e.g., `mystore.myshopify.com`)
2. Access token (generated via Shopify Admin API)

## Background Jobs

- `ShopifySyncJob`: Scheduled job to sync all tenant data
- Runs every 6 hours by default

## License

MIT
