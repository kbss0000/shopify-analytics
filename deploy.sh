#!/bin/bash
# Railway Deployment Script

echo "🚀 Starting Railway Deployment..."

# Step 1: Login (user needs to do this manually)
echo "1. Please run: railway login"
read -p "Press Enter after you've logged in..."

# Step 2: Initialize project
echo "2. Creating Railway project..."
railway init

# Step 3: Add PostgreSQL
echo "3. Adding PostgreSQL database..."
railway add postgresql

# Step 4: Add Redis
echo "4. Adding Redis..."
railway add redis

# Step 5: Set environment variables
echo "5. Setting environment variables..."
MASTER_KEY=$(cat config/master.key)
railway variables set RAILS_ENV=production
railway variables set RAILS_MASTER_KEY=$MASTER_KEY
railway variables set DATABASE_URL=\${{Postgres.DATABASE_URL}}
railway variables set REDIS_URL=\${{Redis.REDIS_URL}}

echo "6. Please set GROQ_API_KEY manually:"
echo "   railway variables set GROQ_API_KEY=your_key_here"

# Step 6: Deploy
echo "7. Deploying application..."
railway up

# Step 7: Run migrations
echo "8. Running database migrations..."
railway run rails db:migrate

# Step 8: Seed database
echo "9. Seeding database..."
railway run rails db:seed

# Step 9: Get URL
echo "10. Getting your live URL..."
railway domain

echo "✅ Deployment complete!"
