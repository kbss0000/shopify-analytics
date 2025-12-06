# Complete Setup Guide - Shopify Analytics Dashboard

This is your complete guide to getting the Shopify Analytics Dashboard up and running.

## 🚀 Quick Start (5 minutes)

```bash
# 1. Install dependencies
bundle install

# 2. Setup database
rails db:create db:migrate db:seed

# 3. Start services (requires Redis)
# Option A: Use foreman
gem install foreman
foreman start -f Procfile.dev

# Option B: Manual (open 3 terminals)
# Terminal 1: rails server
# Terminal 2: bundle exec sidekiq
# Terminal 3: rails tailwindcss:watch (optional)
```

**Login credentials after seeding:**
- Email: `demo@example.com`
- Password: `password123`

## 📋 Table of Contents

1. [System Requirements](#system-requirements)
2. [Installation Steps](#installation-steps)
3. [Configuration](#configuration)
4. [Connecting to Shopify](#connecting-to-shopify)
5. [Running the Application](#running-the-application)
6. [Testing](#testing)
7. [Troubleshooting](#troubleshooting)

---

## System Requirements

### Required Software

| Software | Version | Installation |
|----------|---------|--------------|
| Ruby | 3.2.2 | `rbenv install 3.2.2` or `rvm install 3.2.2` |
| PostgreSQL | 12+ | `brew install postgresql` (macOS) |
| Redis | 6+ | `brew install redis` (macOS) |
| Bundler | 2.0+ | `gem install bundler` |

### Optional

- **Node.js** (for asset compilation)
- **Foreman** (for running multiple processes)
- **ImageMagick** (for image processing, if needed)

---

## Installation Steps

### Step 1: Clone and Navigate

```bash
cd shopify-analytics
```

### Step 2: Install Ruby Dependencies

```bash
bundle install
```

**If you encounter issues:**

```bash
# Update bundler
gem update --system
gem install bundler

# Retry
bundle install
```

### Step 3: Setup Environment

```bash
# Copy environment file
cp .env.example .env

# Edit if needed (defaults work for local dev)
nano .env
```

**Default `.env` contents:**
```env
DATABASE_URL=postgresql://localhost/shopify_analytics_development
REDIS_URL=redis://localhost:6379/0
RAILS_ENV=development
RAILS_MAX_THREADS=5
```

### Step 4: Start PostgreSQL

```bash
# macOS (Homebrew)
brew services start postgresql

# Linux (systemd)
sudo systemctl start postgresql

# Check if running
pg_isready
```

### Step 5: Start Redis

```bash
# macOS (Homebrew)
brew services start redis

# Linux (systemd)
sudo systemctl start redis

# Check if running
redis-cli ping
# Should return: PONG
```

### Step 6: Create and Setup Database

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Load seed data (optional but recommended)
rails db:seed
```

**What seed data creates:**
- 1 demo tenant account
- 5 sample customers
- 10 sample products
- 20 sample orders
- 15 sample custom events

### Step 7: Verify Installation

```bash
# Run Rails console
rails console

# Test database connection
> Tenant.count
# Should return: 1

> Order.count
# Should return: 20

# Exit console
> exit
```

---

## Configuration

### Email Settings (Development)

By default, emails are not sent in development. To test email:

```ruby
# config/environments/development.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  user_name: ENV['GMAIL_USERNAME'],
  password: ENV['GMAIL_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}
```

### Tailwind CSS

The app uses Tailwind CSS for styling. To customize:

```bash
# Watch for CSS changes
rails tailwindcss:watch

# Build for production
rails tailwindcss:build
```

### Sidekiq Configuration

Background jobs are configured in:
- `config/initializers/sidekiq.rb`
- `config/sidekiq_schedule.yml`

To change sync frequency:

```yaml
# config/sidekiq_schedule.yml
sync_all_tenants:
  cron: '0 */6 * * *'  # Every 6 hours
  # Change to: '0 0 * * *'  # Daily at midnight
```

---

## Connecting to Shopify

### Step 1: Create Shopify Custom App

1. **Login to Shopify Admin**
   - Go to your store admin panel
   - URL format: `https://your-store.myshopify.com/admin`

2. **Navigate to Apps**
   - Click **Settings** (bottom left)
   - Click **Apps and sales channels**
   - Click **Develop apps** (top right)

3. **Create New App**
   - Click **Create an app**
   - Name it "Analytics Dashboard"
   - Click **Create app**

### Step 2: Configure API Scopes

1. **Click "Configure Admin API scopes"**

2. **Enable these scopes:**
   ```
   ✓ read_customers
   ✓ read_orders
   ✓ read_products
   ```

3. **Click "Save"**

### Step 3: Install and Get Token

1. **Click "Install app"**
2. **Click "Install" in the confirmation dialog**
3. **Copy the Admin API access token**
   - Starts with `shpat_`
   - **IMPORTANT:** Save this token securely - you can only see it once!

### Step 4: Connect in Application

1. **Sign in to your dashboard**
   - Go to `http://localhost:3000`
   - Sign in with your account

2. **Click "Connect Shopify"**

3. **Enter your details:**
   - **Shopify Domain:** `your-store.myshopify.com`
   - **Access Token:** `shpat_xxxxxxxxxxxxx`

4. **Click "Connect Store"**

### Step 5: Sync Data

1. **Click "Sync Data" button** in the navbar
2. **Wait for sync to complete** (may take a few minutes)
3. **Refresh the page** to see your data

**Monitor sync progress:**
```bash
# Check Sidekiq logs
tail -f log/sidekiq.log

# Or in Rails console
rails console
> ShopifySyncJob.perform_now(Tenant.first.id)
```

---

## Running the Application

### Method 1: Using Foreman (Recommended)

```bash
# Install foreman
gem install foreman

# Start all services
foreman start -f Procfile.dev
```

This starts:
- Rails server on port 3000
- Sidekiq worker
- Tailwind CSS watcher

**Access application:**
- App: http://localhost:3000
- Sidekiq dashboard: http://localhost:3000/sidekiq

### Method 2: Manual (Multiple Terminals)

**Terminal 1 - Rails Server:**
```bash
rails server
# or
rails s -p 3000
```

**Terminal 2 - Sidekiq:**
```bash
bundle exec sidekiq
```

**Terminal 3 - Tailwind (optional):**
```bash
rails tailwindcss:watch
```

### Accessing the Application

1. **Main Dashboard:** http://localhost:3000
2. **Sign Up:** http://localhost:3000/tenants/sign_up
3. **Sign In:** http://localhost:3000/tenants/sign_in
4. **Sidekiq Dashboard:** http://localhost:3000/sidekiq

---

## Testing

### Run All Tests

```bash
bundle exec rspec
```

### Run Specific Tests

```bash
# Models
bundle exec rspec spec/models

# Controllers
bundle exec rspec spec/controllers

# Specific file
bundle exec rspec spec/models/tenant_spec.rb

# Specific line
bundle exec rspec spec/models/tenant_spec.rb:15
```

### Run with Documentation

```bash
bundle exec rspec --format documentation
```

### Code Coverage (Optional)

Add to `Gemfile`:
```ruby
gem 'simplecov', require: false, group: :test
```

Then in `spec/spec_helper.rb`:
```ruby
require 'simplecov'
SimpleCov.start 'rails'
```

---

## Troubleshooting

### PostgreSQL Issues

**"Database does not exist"**
```bash
rails db:create
rails db:migrate
```

**"Could not connect to server"**
```bash
# Check if PostgreSQL is running
pg_isready

# Start PostgreSQL
brew services start postgresql  # macOS
sudo systemctl start postgresql # Linux

# Check PostgreSQL logs
tail -f /usr/local/var/postgres/server.log  # macOS
```

**"Role does not exist"**
```bash
# Create PostgreSQL user
createuser -s postgres
```

### Redis Issues

**"Could not connect to Redis"**
```bash
# Check if Redis is running
redis-cli ping

# Start Redis
brew services start redis  # macOS
sudo systemctl start redis # Linux

# Manual start
redis-server
```

**"Connection refused"**
```bash
# Check Redis port
netstat -an | grep 6379

# Update REDIS_URL in .env
REDIS_URL=redis://localhost:6379/0
```

### Bundler Issues

**"Could not find gem"**
```bash
bundle install
```

**"Bundle install fails"**
```bash
# Update bundler
gem update --system
gem install bundler

# Clean and retry
bundle clean --force
rm Gemfile.lock
bundle install
```

### Migration Issues

**"PendingMigrationError"**
```bash
rails db:migrate
```

**"Reset database completely"**
```bash
# WARNING: Destroys all data!
rails db:drop db:create db:migrate db:seed
```

### Sidekiq Issues

**"Jobs not processing"**
```bash
# Check if Sidekiq is running
ps aux | grep sidekiq

# Restart Sidekiq
# Stop with Ctrl+C, then restart
bundle exec sidekiq
```

**"Check job status"**
```bash
rails console
> Sidekiq::Queue.new.size
> Sidekiq::Workers.new.size
```

### Asset Issues

**"Tailwind styles not loading"**
```bash
# Rebuild Tailwind
rails tailwindcss:build

# Or watch for changes
rails tailwindcss:watch
```

**"JavaScript not loading"**
```bash
# Clear cache
rails tmp:clear

# Restart server
```

### Port Already in Use

```bash
# Find process using port 3000
lsof -ti:3000

# Kill the process
kill -9 $(lsof -ti:3000)

# Or use different port
rails s -p 3001
```

---

## Useful Commands

### Rails Console

```bash
rails console
# or
rails c
```

**Useful console commands:**
```ruby
# Find tenant
tenant = Tenant.first

# Check Shopify connection
tenant.shopify_connected?

# Get analytics
analytics = AnalyticsService.new(tenant)
stats = analytics.dashboard_stats

# Manually sync
ingestor = Shopify::Ingestor.new(tenant)
ingestor.sync_all

# Count records
Tenant.count
Customer.count
Order.count
Product.count
```

### Database

```bash
# Rails database console
rails dbconsole
# or
rails db

# PostgreSQL directly
psql shopify_analytics_development
```

### Logs

```bash
# Development log
tail -f log/development.log

# Sidekiq log (create if doesn't exist)
tail -f log/sidekiq.log

# Clear logs
rails log:clear
```

### Cache

```bash
# Clear all cache
rails tmp:clear

# Clear specific caches
rails tmp:cache:clear
```

---

## Next Steps

✅ **Application is running!** Here's what to do next:

1. **Customize the Dashboard**
   - Edit `app/views/dashboard/index.html.erb`
   - Modify analytics in `app/services/analytics_service.rb`

2. **Add More Features**
   - Customer segmentation
   - Product performance analytics
   - Revenue forecasting
   - Email reports

3. **Setup Webhooks**
   - Real-time updates from Shopify
   - See `app/controllers/webhooks/`

4. **Deploy to Production**
   - Read [DEPLOYMENT.md](DEPLOYMENT.md)
   - Choose Render, Railway, or Heroku

5. **Improve Security**
   - Enable webhook HMAC verification
   - Add rate limiting
   - Setup monitoring

---

## Getting Help

- **Documentation:** See [README.md](README.md)
- **Installation:** See [INSTALLATION.md](INSTALLATION.md)
- **Deployment:** See [DEPLOYMENT.md](DEPLOYMENT.md)
- **Issues:** Check logs first, then open GitHub issue

---

## Project Structure

```
shopify-analytics/
├── app/
│   ├── controllers/      # Request handlers
│   ├── models/           # Database models
│   ├── services/         # Business logic
│   ├── jobs/             # Background jobs
│   ├── views/            # Templates
│   └── helpers/          # View helpers
├── config/               # Configuration
├── db/
│   ├── migrate/          # Database migrations
│   └── seeds.rb          # Sample data
├── spec/                 # Tests
├── public/               # Static files
└── lib/                  # Custom libraries
```

---

**Happy coding! 🎉**
