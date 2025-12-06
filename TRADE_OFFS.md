# Trade-offs & Known Limitations

## Security Considerations

### Shopify Access Token Storage

**Current Implementation:** Access tokens are stored in plain text in the database.

**Production Recommendation:** 
- Use `attr_encrypted` gem for field-level encryption
- Or use Rails 7+ `ActiveRecord::Encryption` (requires master key setup)
- Or store in Rails encrypted credentials file
- Ensure database access is restricted and credentials are secure

**Note:** For this assignment, plain text storage is acceptable but should be documented.

## Known Limitations

### 1. Pagination Support

**Status:** ✅ **FIXED** - Now fully implemented

**Previous Limitation:** The sync would only fetch the first 250 items per resource type.

**Current Implementation:** 
- Full cursor-based pagination support via Link header parsing
- Handles multiple pages automatically
- Works for customers, orders, and products

### 2. Order Status Field

**Status:** ✅ **FIXED** - Now fully implemented

**Previous Limitation:** Order status was not tracked in the database.

**Current Implementation:**
- Added `status` field to orders table
- Status is synced from Shopify's `fulfillment_status` and `financial_status`
- Supports: `pending`, `fulfilled`, `paid`, `cancelled`
- Status is displayed in order views and analytics

### 3. Groq API Integration

**Status:** ✅ **FIXED** - Real API integration implemented

**Previous Limitation:** AI responses were hardcoded/simulated.

**Current Implementation:**
- Real Groq API integration using HTTP requests
- Uses `llama-3.1-70b-versatile` model
- Provides database schema context to AI
- Executes SQL queries safely (read-only, tenant-scoped)
- Falls back to simulated responses if API fails or key is missing

**Setup Required:**
1. Get API key from https://console.groq.com/
2. Add to `.env`: `GROQ_API_KEY=your_key_here`
3. Restart the application

## Future Enhancements

1. **Rate Limiting:** Add rate limiting for Groq API calls
2. **Query Caching:** Cache common AI queries to reduce API calls
3. **Error Handling:** Enhanced error messages for failed API calls
4. **Token Encryption:** Implement proper encryption for access tokens
5. **Webhook Retry Logic:** Enhanced retry mechanism for failed webhooks
6. **Real-time Updates:** WebSocket support for live dashboard updates

