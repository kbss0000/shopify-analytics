#!/bin/bash
# Auto-deploy script - Run this AFTER railway login

echo "🚀 AUTO-DEPLOYING TO RAILWAY..."

# Verify login
if ! railway whoami > /dev/null 2>&1; then
    echo "❌ Not logged in. Run: railway login"
    exit 1
fi

echo "✅ Authenticated! Starting deployment..."

# Create project
railway init --name shopify-analytics

# Add services
railway add --database postgres
railway add --database redis

# Set variables
railway variables --set RAILS_ENV=production
railway variables --set RAILS_MASTER_KEY=6a4bfccbd0c3bc67e9c7c57c248d358b754dd2ea289fc2bf3b5a2dee23e4f271
railway variables --set GROQ_API_KEY=your_groq_api_key_here

# Deploy
railway up

# Migrations
railway run rails db:migrate
railway run rails db:seed

# Get URL
railway domain

echo "✅ DEPLOYED!"
