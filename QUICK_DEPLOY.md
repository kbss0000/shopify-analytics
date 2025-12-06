# ⚡ QUICKEST DEPLOYMENT - 2 MINUTES

## FASTEST METHOD - Railway Dashboard:

1. Go to: https://railway.app/new
2. Click "Deploy from GitHub repo"
3. Authorize GitHub
4. Select: shopify-analytics repo
5. Click "Add PostgreSQL" (left sidebar)
6. Click "Add Redis" (left sidebar)
7. Click your web service → Variables tab
8. Add these variables:
   - RAILS_ENV = production
   - RAILS_MASTER_KEY = 6a4bfccbd0c3bc67e9c7c57c248d358b754dd2ea289fc2bf3b5a2dee23e4f271
   - GROQ_API_KEY = your_groq_api_key_here
   - DATABASE_URL = ${{Postgres.DATABASE_URL}}
   - REDIS_URL = ${{Redis.REDIS_URL}}
9. Railway auto-deploys!
10. Click Settings → Generate Domain
11. In Deployments tab → View Logs → Run: rails db:migrate
12. Run: rails db:seed

DONE! Your app is live in 2 minutes!
