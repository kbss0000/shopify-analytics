# Groq API Key Setup

## Getting Your Groq API Key

1. Visit: https://console.groq.com/
2. Sign up or log in
3. Navigate to API Keys section
4. Create a new API key
5. Copy the API key

## Setting Up in Docker

1. Edit the `.env` file in the project root:
   ```bash
   GROQ_API_KEY=your_actual_groq_api_key_here
   ```

2. Restart the web container:
   ```bash
   docker-compose restart web
   ```

## Setting Up for Local Development

If running locally (not Docker), add to your `.env` file:
```
GROQ_API_KEY=your_actual_groq_api_key_here
```

## Verifying It Works

1. Go to the AI Studio page: http://localhost:3000/ai
2. Try asking a question about your data
3. If the API key is set, it will use the real Groq API
4. If not set, it will use simulated responses

## ✅ Integration Status

The Groq API integration is **fully implemented** and ready to use!

- Real API calls using HTTP requests (no gem required)
- Uses `llama-3.1-70b-versatile` model
- Provides database schema context to AI
- Executes SQL queries safely (read-only, tenant-scoped)
- Falls back to simulated responses if API fails

## Testing

1. Go to http://localhost:3000/ai
2. Try asking questions like:
   - "Show me revenue trends for the last 30 days"
   - "Who are my top customers?"
   - "What's my average order value?"
3. The AI will generate real SQL queries and execute them against your database

## Troubleshooting

If you see simulated responses:
- Check that `GROQ_API_KEY` is set in your `.env` file
- Restart the web container: `docker-compose restart web`
- Check logs: `docker-compose logs web | grep -i groq`
