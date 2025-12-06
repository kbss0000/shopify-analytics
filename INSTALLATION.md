# Installation Guide

## Prerequisites

Before you begin, ensure you have the following installed:

- **Ruby 3.2.2** - Install via rbenv or rvm
- **PostgreSQL 12+** - For database
- **Redis 6+** - For Sidekiq background jobs
- **Node.js** - For asset compilation (optional with importmap)

## Local Development Setup

### 1. Clone the Repository

```bash
cd shopify-analytics
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# If you get errors, you may need to install system dependencies first:
# On macOS:
brew install postgresql redis

# On Ubuntu/Debian:
sudo apt-get install postgresql postgresql-contrib redis-server
```

### 3. Setup Environment Variables

```bash
# Copy the example env file
cp .env.example .env

# Edit .env and update if needed (defaults should work for local development)
```

### 4. Setup Database

```bash
# Create and setup the database
rails db:create
rails db:migrate

# Load seed data (creates a demo tenant)
rails db:seed
```

After seeding, you can login with:
- Email: `demo@example.com`
- Password: `password123`

### 5. Start Redis

Redis is required for Sidekiq background jobs.

```bash
# On macOS
brew services start redis

# On Linux
sudo systemctl start redis

# Or run in foreground
redis-server
```

### 6. Start the Application

You'll need to run multiple processes. Open separate terminal windows/tabs:

**Terminal 1 - Rails Server:**
```bash
rails server
# Or with specific port
rails server -p 3000
```

**Terminal 2 - Sidekiq:**
```bash
bundle exec sidekiq
```

**Terminal 3 (Optional) - Tailwind Watch:**
```bash
rails tailwindcss:watch
```

Alternatively, use a process manager like Foreman:
```bash
# Install foreman
gem install foreman

# Run all processes
foreman start -f Procfile.dev
```

### 7. Access the Application

Open your browser and navigate to:
```
http://localhost:3000
```

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/tenant_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

## Connecting to Shopify

To connect your Shopify store:

1. **Create a Custom App in Shopify:**
   - Go to your Shopify Admin
   - Navigate to: Settings → Apps and sales channels → Develop apps
   - Click "Create an app"
   - Give it a name like "Analytics Dashboard"

2. **Configure API Scopes:**
   - Click "Configure Admin API scopes"
   - Enable the following scopes:
     - `read_customers`
     - `read_orders`
     - `read_products`
   - Save the configuration

3. **Install the App:**
   - Click "Install app"
   - Copy the "Admin API access token" (starts with `shpat_`)

4. **Enter Credentials in the Application:**
   - Sign in to your account
   - Click "Connect Shopify"
   - Enter your Shopify domain (e.g., `mystore.myshopify.com`)
   - Paste the access token
   - Click "Connect Store"

5. **Sync Data:**
   - After connecting, click "Sync Data" button
   - Wait a few minutes for the initial sync to complete
   - Refresh the dashboard to see your data

## Troubleshooting

### Database Connection Issues

```bash
# Check if PostgreSQL is running
pg_isready

# Start PostgreSQL
# macOS:
brew services start postgresql

# Linux:
sudo systemctl start postgresql
```

### Redis Connection Issues

```bash
# Check if Redis is running
redis-cli ping
# Should return: PONG

# Start Redis if not running
redis-server
```

### Bundler Issues

```bash
# Update bundler
gem install bundler

# Clean bundle
bundle clean --force
bundle install
```

### Migration Issues

```bash
# Reset database (WARNING: destroys all data)
rails db:drop db:create db:migrate db:seed
```

### Sidekiq Not Processing Jobs

```bash
# Check Sidekiq is running
ps aux | grep sidekiq

# View Sidekiq web UI
# Visit: http://localhost:3000/sidekiq
```

## Development Tools

### Rails Console

```bash
rails console
# or
rails c
```

Useful console commands:
```ruby
# Find a tenant
tenant = Tenant.first

# Check if Shopify is connected
tenant.shopify_connected?

# Manually trigger sync
ShopifySyncJob.perform_now(tenant.id)

# View orders
tenant.orders.count

# Get analytics
analytics = AnalyticsService.new(tenant)
analytics.dashboard_stats
```

### Database Console

```bash
rails dbconsole
# or
rails db
```

### View Logs

```bash
# Development log
tail -f log/development.log

# Sidekiq log
tail -f log/sidekiq.log
```

## Next Steps

- Customize the dashboard views in `app/views/dashboard/`
- Add more analytics features in `app/services/analytics_service.rb`
- Set up webhooks for real-time updates
- Configure email notifications
- Add custom events tracking

## Need Help?

- Check the [README.md](README.md) for project overview
- Review the [DEPLOYMENT.md](DEPLOYMENT.md) for production deployment
- Open an issue on GitHub
