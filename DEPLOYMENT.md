# 🚀 Free Deployment Guide - Railway

## Why Railway?
- ✅ **Free Tier**: $5 credit/month (enough for small apps)
- ✅ **Excellent CLI**: Full command-line control
- ✅ **Docker Support**: Works with your existing Dockerfile
- ✅ **PostgreSQL & Redis**: Built-in managed services
- ✅ **Auto-deploy**: From GitHub
- ✅ **Easy Environment Variables**: Simple management

## Quick Deploy (5 minutes)

### Step 1: Install Railway CLI
```bash
npm i -g @railway/cli
# OR
brew install railway
```

### Step 2: Login
```bash
railway login
```
This will open your browser to authenticate.

### Step 3: Create Project
```bash
cd /Users/happy/Code/shopify-analytics
railway init
```
Follow prompts to create a new project.

### Step 4: Add Services
```bash
# Add PostgreSQL database
railway add postgresql

# Add Redis
railway add redis
```

### Step 5: Set Environment Variables
```bash
# Set production environment
railway variables set RAILS_ENV=production

# Set Rails master key (get from config/master.key)
railway variables set RAILS_MASTER_KEY=$(cat config/master.key)

# Set Groq API key
railway variables set GROQ_API_KEY=your_groq_api_key_here

# Link database (automatic)
railway variables set DATABASE_URL=\${{Postgres.DATABASE_URL}}

# Link Redis (automatic)
railway variables set REDIS_URL=\${{Redis.REDIS_URL}}

# Set port (Railway provides this automatically)
railway variables set PORT=3000
```

### Step 6: Deploy
```bash
railway up
```
This will build and deploy your Docker image.

### Step 7: Run Migrations
```bash
railway run rails db:migrate
```

### Step 8: Seed Database
```bash
railway run rails db:seed
```

### Step 9: Get Your URL
```bash
railway domain
```
This will show your live URL. You can also add a custom domain.

## Alternative: Railway Dashboard (No CLI needed)

1. Go to [railway.app](https://railway.app)
2. Sign up/login
3. Click **"New Project"**
4. Select **"Deploy from GitHub repo"**
5. Connect your GitHub account
6. Select this repository
7. Railway will auto-detect Dockerfile and deploy
8. Add **PostgreSQL** service (click + → Database → PostgreSQL)
9. Add **Redis** service (click + → Database → Redis)
10. Go to **Variables** tab and set:
    - `RAILS_ENV=production`
    - `RAILS_MASTER_KEY=<from config/master.key>`
    - `GROQ_API_KEY=<your_key>`
    - `DATABASE_URL` (auto-set from PostgreSQL service)
    - `REDIS_URL` (auto-set from Redis service)
11. Go to **Settings** → **Generate Domain** to get your URL
12. Run migrations: Click on your service → **Deployments** → **View Logs** → Run `rails db:migrate` and `rails db:seed`

## Post-Deployment

### Check Logs
```bash
railway logs
```

### Run Rails Console
```bash
railway run rails console
```

### Update Environment Variables
```bash
railway variables set KEY=value
```

### Redeploy
```bash
railway up
```

## Free Tier Limits

- **$5 credit/month** (usually enough for 1-2 small apps)
- **512MB RAM** per service
- **1GB storage** for database
- **100GB bandwidth/month**

## Troubleshooting

### Database Connection Issues
- Check `DATABASE_URL` is set correctly
- Verify PostgreSQL service is running
- Check logs: `railway logs`

### Build Failures
- Check Dockerfile is correct
- Verify all dependencies in Gemfile
- Check build logs in Railway dashboard

### App Not Starting
- Check `PORT` environment variable (Railway sets this automatically)
- Verify `RAILS_MASTER_KEY` is set
- Check application logs: `railway logs`

## Cost

**Free tier is enough for:**
- Development/testing
- Small personal projects
- Low-traffic applications

**If you need more:**
- Upgrade to Hobby plan ($5/month) for more resources
- Or use Render.com (also has free tier)

## Next Steps After Deployment

1. ✅ Test your live URL
2. ✅ Verify database is working
3. ✅ Test AI Studio with Groq API
4. ✅ Set up custom domain (optional)
5. ✅ Enable auto-deploy from GitHub (optional)

---

**Ready to deploy?** Run the commands above or use the Railway dashboard!
