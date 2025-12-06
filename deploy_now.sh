#!/bin/bash
# Railway Deployment - Correct Syntax

echo "🚀 Starting deployment..."

# Check auth
railway whoami || { echo "Please login: railway login"; exit 1; }

# Initialize project
echo "Creating project..."
railway init

# Add PostgreSQL
echo "Adding PostgreSQL..."
railway add --database postgres

# Add Redis  
echo "Adding Redis..."
railway add --database redis

# Set variables
echo "Setting environment variables..."
railway variables --set RAILS_ENV=production
railway variables --set RAILS_MASTER_KEY=6a4bfccbd0c3bc67e9c7c57c248d358b754dd2ea289fc2bf3b5a2dee23e4f271
railway variables --set GROQ_API_KEY=your_groq_api_key_here
railway variables --set DATABASE_URL='${{Postgres.DATABASE_URL}}'
railway variables --set REDIS_URL='${{Redis.REDIS_URL}}'

# Deploy
echo "Deploying..."
railway up

# Migrations
echo "Running migrations..."
railway run rails db:migrate

# Seed
echo "Seeding database..."
railway run rails db:seed

# Get URL
echo "Getting domain..."
railway domain

echo "✅ Deployment complete!"
