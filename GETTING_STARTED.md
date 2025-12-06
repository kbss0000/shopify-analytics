# Getting Started - Shopify Analytics Dashboard

Welcome! This guide will get you from zero to a running application in **under 10 minutes**.

---

## 🚀 Quick Start (Choose Your Path)

### Path A: Simple Local Setup (Recommended for Beginners)

```bash
# 1. Install dependencies
bundle install

# 2. Setup database
rails db:setup

# 3. Start everything
gem install foreman
foreman start -f Procfile.dev
```

**That's it!** Open http://localhost:3000 and login with:
- Email: `demo@example.com`
- Password: `password123`

---

### Path B: Docker Setup (Recommended for Consistency)

```bash
# Start everything with Docker
docker-compose up

# In another terminal, setup database
docker-compose exec web rails db:setup
```

Open http://localhost:3000

---

### Path C: Manual Setup (Full Control)

**Prerequisites:** PostgreSQL and Redis must be running

```bash
# 1. Install gems
bundle install

# 2. Setup environment
cp .env.example .env

# 3. Create and migrate database
rails db:create
rails db:migrate
rails db:seed

# 4. Start services (3 separate terminals)
# Terminal 1:
rails server

# Terminal 2:
bundle exec sidekiq

# Terminal 3 (optional):
rails tailwindcss:watch
```

---

## 📋 Prerequisites Check

Before you start, verify you have the required software:

```bash
# Check Ruby version (need 3.2.2)
ruby -v

# Check PostgreSQL
psql --version
pg_isready

# Check Redis
redis-cli --version
redis-cli ping  # Should return PONG

# Check Bundler
bundle -v
```

**Don't have these installed?** See [INSTALLATION.md](INSTALLATION.md) for detailed instructions.

---

## 🎯 What You'll Get

After setup, you'll have:

✅ A working Rails application on http://localhost:3000  
✅ A demo tenant account with sample data  
✅ Working authentication system  
✅ Dashboard with charts and analytics  
✅ Background job processing (Sidekiq)  
✅ Ready to connect to Shopify  

---

## 🏗️ System Architecture (Simple View)

```
┌─────────────────────────────────────────────────────────┐
│                    Your Computer                        │
│                                                         │
│  ┌──────────────┐    ┌──────────────┐   ┌──────────┐  │
│  │   Browser    │───▶│  Rails App   │──▶│PostgreSQL│  │
│  │ (localhost:  │    │  (Port 3000) │   │  (Data)  │  │
│  │    3000)     │◀───│              │◀──│          │  │
│  └──────────────┘    └──────┬───────┘   └──────────┘  │
│                             │                           │
│                             │                           │
│                      ┌──────▼────────┐   ┌──────────┐  │
│                      │    Sidekiq    │──▶│  Redis   │  │
│                      │ (Background   │   │ (Queue)  │  │
│                      │    Jobs)      │   │          │  │
│                      └───────────────┘   └──────────┘  │
│                             │                           │
└─────────────────────────────┼───────────────────────────┘
                              │
                              │ (Syncs data)
                              ▼
                      ┌───────────────┐
                      │  Shopify API  │
                      │ (Your Store)  │
                      └───────────────┘
```

---

## 📁 Key Files to Know

| File | Purpose | When to Edit |
|------|---------|--------------|
| `app/controllers/dashboard_controller.rb` | Dashboard logic | Adding new metrics |
| `app/views/dashboard/index.html.erb` | Dashboard UI | Customizing layout |
| `app/services/analytics_service.rb` | Analytics calculations | New analytics features |
| `app/services/shopify/ingestor.rb` | Shopify data sync | Syncing new data types |
| `app/models/` | Database models | Adding fields/validations |
| `config/routes.rb` | URL routing | Adding new pages |
| `db/migrate/` | Database schema | Changing data structure |

---

## 🧪 Verify Everything Works

### 1. Check the Web Server

```bash
# Visit in browser
http://localhost:3000

# You should see the login page
```

### 2. Login to Demo Account

```
Email: demo@example.com
Password: password123
```

### 3. Check Dashboard

You should see:
- 5 customers
- 20 orders
- Revenue metrics
- Charts with data

### 4. Check Sidekiq

```bash
# Visit Sidekiq dashboard
http://localhost:3000/sidekiq

# You should see:
# - 0 or more processed jobs
# - No failed jobs
```

### 5. Test Database Connection

```bash
rails console

# Run these commands:
> Tenant.count
# => 1

> Order.count
# => 20

> Customer.count
# => 5

> exit
```

---

## 🛍️ Connect Your Shopify Store

Now that the app is running, connect your real Shopify store:

### Step 1: Get Shopify Credentials

1. **Go to your Shopify Admin**
   ```
   https://YOUR-STORE.myshopify.com/admin
   ```

2. **Navigate to:**
   ```
   Settings → Apps and sales channels → Develop apps
   ```

3. **Create a new app:**
   - Click "Create an app"
   - Name: "Analytics Dashboard"
   - Click "Create app"

4. **Configure API scopes:**
   - Click "Configure Admin API scopes"
   - Enable these scopes:
     - ☑️ `read_customers`
     - ☑️ `read_orders`
     - ☑️ `read_products`
   - Click "Save"

5. **Install the app:**
   - Click "Install app"
   - Click "Install" in the confirmation
   - **Copy the Admin API access token** (starts with `shpat_`)
   - ⚠️ Save this token securely - you'll only see it once!

### Step 2: Connect in Application

1. **Sign out of demo account** (if logged in)

2. **Create your own account:**
   - Click "Sign up"
   - Enter your store name, email, and password
   - Click "Sign up"

3. **Connect Shopify:**
   - You'll be redirected to "Connect Your Shopify Store"
   - Enter your Shopify domain: `your-store.myshopify.com`
   - Paste your access token: `shpat_xxxxx...`
   - Click "Connect Store"

### Step 3: Sync Your Data

1. **Click "Sync Data"** button in the navbar

2. **Wait for sync** (may take 1-5 minutes depending on data volume)

3. **Refresh the page** to see your real data!

---

## 🎨 Customize the Dashboard

### Change the Title

```ruby
# app/views/dashboard/index.html.erb
<h1 class="text-3xl font-bold text-gray-900">
  My Custom Dashboard  <!-- Change this -->
</h1>
```

### Add a New Metric

```ruby
# app/services/analytics_service.rb
def total_revenue_this_month
  orders = tenant.orders.this_month
  revenue_cents = orders.sum(:total_price_cents)
  Money.new(revenue_cents, 'USD')
end
```

```erb
<!-- app/views/dashboard/index.html.erb -->
<div class="bg-white rounded-lg shadow p-6">
  <h3>Revenue This Month</h3>
  <p><%= format_currency(@analytics.total_revenue_this_month) %></p>
</div>
```

### Change the Color Scheme

```ruby
# app/views/shared/_navbar.html.erb
# Change from indigo to blue:
class="bg-indigo-600"  →  class="bg-blue-600"
```

---

## 🐛 Common Issues & Solutions

### "Database does not exist"

```bash
rails db:create
rails db:migrate
```

### "Could not connect to server (PostgreSQL)"

```bash
# macOS
brew services start postgresql

# Linux
sudo systemctl start postgresql

# Verify it's running
pg_isready
```

### "Error connecting to Redis"

```bash
# macOS
brew services start redis

# Linux
sudo systemctl start redis

# Verify it's running
redis-cli ping
```

### "Port 3000 is already in use"

```bash
# Find and kill the process
kill -9 $(lsof -ti:3000)

# Or use a different port
rails server -p 3001
```

### "Bundler version mismatch"

```bash
gem install bundler
bundle install
```

### "No data showing after sync"

```bash
# Check Sidekiq logs
tail -f log/sidekiq.log

# Check if jobs are processing
http://localhost:3000/sidekiq

# Manually trigger sync
rails console
> ShopifySyncJob.perform_now(Tenant.first.id)
```

---

## 📚 Next Steps

### Learn the Codebase

1. **Read the documentation:**
   - [README.md](README.md) - Overview
   - [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Architecture
   - [INSTALLATION.md](INSTALLATION.md) - Detailed setup

2. **Explore the code:**
   ```bash
   # Open in your editor
   code .
   
   # Or
   atom .
   
   # Or
   vim .
   ```

3. **Run the test suite:**
   ```bash
   bundle exec rspec
   ```

### Add Features

Start with these beginner-friendly enhancements:

1. **Add a new chart** (Easy)
   - Edit `app/views/dashboard/index.html.erb`
   - Use Chartkick documentation

2. **Add customer filtering** (Medium)
   - Add search form to dashboard
   - Filter by email or name

3. **Export data to CSV** (Medium)
   - Add export button
   - Use Rails CSV library

4. **Email reports** (Advanced)
   - Setup Action Mailer
   - Create weekly summary emails

### Deploy to Production

When you're ready to go live:

1. **Read [DEPLOYMENT.md](DEPLOYMENT.md)**

2. **Choose a platform:**
   - Render (easiest)
   - Railway (simple)
   - Heroku (mature)

3. **Deploy and test**

4. **Setup monitoring**

---

## 💡 Tips for Success

### Development Workflow

```bash
# Daily routine:
git pull                    # Get latest changes
bundle install              # Update gems
rails db:migrate           # Run migrations
bin/dev                    # Start app

# Before committing:
bundle exec rspec          # Run tests
git add .
git commit -m "message"
git push
```

### Rails Console Tricks

```ruby
# Reload code without restarting
> reload!

# Find tenant
> tenant = Tenant.first

# Get analytics
> analytics = AnalyticsService.new(tenant)
> analytics.dashboard_stats

# Manually sync
> ShopifySyncJob.perform_now(tenant.id)

# Check last order
> Order.last

# Count records
> Order.count
> Customer.count
```

### Debugging Tips

1. **Use `binding.pry` or `debugger`:**
   ```ruby
   def some_method
     debugger  # Execution stops here
     # Inspect variables, run code
   end
   ```

2. **Check logs:**
   ```bash
   tail -f log/development.log
   tail -f log/sidekiq.log
   ```

3. **Use Rails logger:**
   ```ruby
   Rails.logger.info "Debug: #{variable.inspect}"
   ```

---

## 🆘 Getting Help

### Self-Help Resources

1. **Check logs first:**
   ```bash
   tail -f log/development.log
   ```

2. **Search error messages:**
   - Google the error
   - Stack Overflow
   - Rails Guides

3. **Use Rails console to debug:**
   ```bash
   rails console
   ```

### Community Help

1. **GitHub Issues:** Open an issue with:
   - What you tried to do
   - What happened instead
   - Error messages
   - Steps to reproduce

2. **Rails Community:**
   - [Rails Forum](https://discuss.rubyonrails.org/)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/ruby-on-rails)
   - [Reddit r/rails](https://reddit.com/r/rails)

---

## ✅ Success Checklist

You're all set when you can:

- [ ] Application runs at http://localhost:3000
- [ ] You can login to the demo account
- [ ] Dashboard shows metrics and charts
- [ ] Sidekiq dashboard is accessible
- [ ] You can create a new account
- [ ] You can connect a Shopify store
- [ ] You can trigger a data sync
- [ ] Background jobs are processing

---

## 🎉 You're Ready!

Congratulations! You now have a fully functional Shopify analytics dashboard.

**What's next?**
- Customize the dashboard to your needs
- Add new features
- Deploy to production
- Share with others

**Happy coding!** 🚀

---

**Need more help?** Check out:
- [INSTALLATION.md](INSTALLATION.md) - Detailed installation
- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Complete walkthrough
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Architecture details
- [DEPLOYMENT.md](DEPLOYMENT.md) - Production deployment

---

**Built with Ruby on Rails** | **MIT License** | **Open Source**
