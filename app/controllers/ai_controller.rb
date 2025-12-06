class AiController < ApplicationController
  require 'json'
  require 'faraday'
  
  skip_before_action :verify_authenticity_token, only: [:ask], if: -> { request.format.json? }

  def index
  end

  def ask
    prompt = params[:prompt]
    
    Rails.logger.info("AI request received: #{prompt}")
    
    # Always try Groq API if key is present, fallback to simulated if it fails
    begin
      if ENV['GROQ_API_KEY'].present?
        Rails.logger.info("Using Groq API")
        response_data = ask_groq_api(prompt)
      else
        Rails.logger.info("Using simulated response (no API key)")
        response_data = generate_simulated_response(prompt)
      end
    rescue => e
      Rails.logger.error("AI Controller Error: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.first(5))
      response_data = generate_simulated_response(prompt)
    end
    
    # Ensure we always return valid data
    response_data ||= {
      answer: "I encountered an error. Please try again.",
      sql: "-- Error occurred",
      data: {}
    }
    
    Rails.logger.info("Sending response: #{response_data[:answer][0..50]}...")
    
    respond_to do |format|
      format.json { render json: response_data }
    end
  end

  private

  def ask_groq_api(prompt)
    api_key = ENV['GROQ_API_KEY']
    return generate_simulated_response(prompt) unless api_key.present?

    begin
      # Build the database schema context for the AI
      schema_context = build_schema_context
      
      # Enhanced prompt with schema information
      enhanced_prompt = <<~PROMPT
        You are a helpful data analyst for a Shopify store analytics dashboard. 
        
        Database Schema:
        #{schema_context}
        
        User Question: #{prompt}
        
        IMPORTANT: Provide a detailed, natural language explanation that:
        1. Directly answers the user's question in plain English
        2. Explains what the data shows and what insights can be drawn
        3. Is conversational and helpful (2-4 sentences minimum)
        4. Mentions specific numbers or trends when relevant
        
        Then provide a PostgreSQL query that retrieves the data to answer this question.
        The query MUST filter by tenant_id = #{current_tenant.id}
        
        Respond ONLY in valid JSON format (no markdown, no code blocks):
        {
          "answer": "A detailed natural language explanation answering the user's question with insights and context",
          "sql": "SELECT ... FROM ... WHERE tenant_id = #{current_tenant.id} ..."
        }
        
        Example good answer: "Based on your store data, your top 5 customers have spent a total of $1,234.56. Customer 5 leads with $376.03 in purchases, followed by Customer 3 at $370.63. These customers represent your most valuable relationships and should be prioritized for retention campaigns."
      PROMPT

      # Make HTTP request to Groq API
      response = Faraday.post('https://api.groq.com/openai/v1/chat/completions') do |req|
        req.headers['Authorization'] = "Bearer #{api_key}"
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          model: 'llama-3.3-70b-versatile',
          messages: [
            {
              role: 'system',
              content: 'You are a helpful SQL expert. Always respond with valid JSON containing "answer" and "sql" fields.'
            },
            {
              role: 'user',
              content: enhanced_prompt
            }
          ],
          temperature: 0.7,
          max_tokens: 1000
        }.to_json
      end

      if response.status == 200
        data = JSON.parse(response.body)
        content = data.dig('choices', 0, 'message', 'content')
        
        return generate_simulated_response(prompt) unless content.present?
        
        # Groq may return JSON or plain text, try to parse as JSON first
        begin
          ai_response = JSON.parse(content)
        rescue JSON::ParserError
          # If not JSON, try to extract SQL from markdown code blocks or plain text
          sql_match = content.match(/```sql\s*(.*?)\s*```/m) || content.match(/```\s*(SELECT.*?)\s*```/m) || content.match(/(SELECT.*?);/m)
          sql = sql_match ? sql_match[1] : '-- Could not extract SQL from response'
          
          # Extract answer (everything before code blocks)
          answer = content.split(/```/).first&.strip || content
          
          ai_response = {
            'answer' => answer,
            'sql' => sql
          }
        end
        
        # Execute the SQL query safely (read-only)
        query_result = execute_safe_query(ai_response['sql'])
        
        answer_text = ai_response['answer'] || ai_response[:answer] || 'Analysis complete.'
        
        # If answer is too short or generic, enhance it
        if answer_text.length < 50 || answer_text.downcase.include?('analysis complete')
          answer_text = "Based on your data: #{answer_text}. Here are the detailed results below."
        end
        
        {
          answer: answer_text,
          sql: ai_response['sql'] || ai_response[:sql] || '-- No SQL generated',
          data: query_result
        }
      elsif response.status == 401
        Rails.logger.error("Groq API authentication failed. Check your API key.")
        # Return a helpful error message instead of blank
        {
          answer: "⚠️ API authentication failed. Please check your GROQ_API_KEY. Using simulated response for now.",
          sql: generate_simulated_response(prompt)[:sql],
          data: generate_simulated_response(prompt)[:data]
        }
      else
        Rails.logger.error("Groq API error: #{response.status} - #{response.body}")
        generate_simulated_response(prompt)
      end
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse Groq response: #{e.message}")
      Rails.logger.error("Response body: #{response&.body}")
      generate_simulated_response(prompt)
    rescue Faraday::Error => e
      Rails.logger.error("Network error connecting to Groq API: #{e.message}")
      {
        answer: "⚠️ Could not connect to Groq API. Using simulated response.",
        sql: generate_simulated_response(prompt)[:sql],
        data: generate_simulated_response(prompt)[:data]
      }
    rescue => e
      Rails.logger.error("Groq API request failed: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.first(3))
      generate_simulated_response(prompt)
    end
  end

  def build_schema_context
    <<~SCHEMA
      Tables:
      - tenants (id, email, name, shopify_domain, shopify_access_token)
      - customers (id, tenant_id, shopify_id, email, first_name, last_name, total_spent_cents)
      - orders (id, tenant_id, customer_id, shopify_id, total_price_cents, currency, placed_at, status)
      - products (id, tenant_id, shopify_id, title, sku, price_cents)
      
      Current Tenant ID: #{current_tenant.id}
      All queries must filter by tenant_id = #{current_tenant.id}
    SCHEMA
  end

  def execute_safe_query(sql)
    return {} unless sql.present?
    
    sql = sql.to_s.strip
    # Only allow SELECT queries for safety
    return {} unless sql.upcase.start_with?('SELECT')
    
    # Remove any dangerous patterns
    return {} if sql.match?(/DROP|DELETE|UPDATE|INSERT|ALTER|CREATE|TRUNCATE|EXEC|EXECUTE/i)
    
    begin
      # Ensure tenant_id filter is present and correct
      # If SQL doesn't have tenant_id, add it
      if sql.match?(/WHERE/i)
        # Add tenant_id to WHERE clause if not present
        unless sql.match?(/tenant_id\s*=/i)
          sql = sql.sub(/WHERE/i, "WHERE tenant_id = #{current_tenant.id} AND")
        else
          # Replace any existing tenant_id value
          sql = sql.gsub(/tenant_id\s*=\s*\d+/i, "tenant_id = #{current_tenant.id}")
        end
      else
        # Add WHERE clause with tenant_id
        sql = "#{sql} WHERE tenant_id = #{current_tenant.id}"
      end
      
      result = ActiveRecord::Base.connection.execute(sql)
      
      # Convert to array of hashes
      if result.respond_to?(:columns) && result.respond_to?(:map)
        columns = result.columns
        result.map { |row| columns.zip(row).to_h }
      else
        # Fallback for different result formats
        result.to_a
      end
    rescue => e
      Rails.logger.error("Query execution failed: #{e.message}\nSQL: #{sql}")
      {}
    end
  end

  def generate_simulated_response(prompt)
    prompt_lower = prompt.to_s.downcase
    
    if prompt_lower.include?("revenue")
      revenue_data = current_tenant.orders.group_by_day(:placed_at).sum(:total_price_cents).transform_values { |v| v / 100.0 }
      total_revenue = revenue_data.values.sum
      avg_daily = revenue_data.values.sum / [revenue_data.keys.length, 1].max
      
      {
        answer: "Based on your store data, your revenue trends show a total of $#{sprintf('%.2f', total_revenue)} over the last 30 days, with an average daily revenue of $#{sprintf('%.2f', avg_daily)}. The data indicates consistent sales activity across this period. Here's the day-by-day breakdown:",
        sql: "SELECT date(placed_at) as day, sum(total_price_cents)/100.0 as revenue FROM orders WHERE tenant_id = #{current_tenant.id} AND placed_at > NOW() - INTERVAL '30 days' GROUP BY 1 ORDER BY 1;",
        data: revenue_data
      }
    elsif prompt_lower.include?("customer") || prompt_lower.include?("who") || prompt_lower.include?("top")
      top_customers = current_tenant.customers.order(total_spent_cents: :desc).limit(5)
      total_spent = top_customers.sum(&:total_spent_cents) / 100.0
      top_customer = top_customers.first
      
      {
        answer: "Your top 5 customers have generated $#{sprintf('%.2f', total_spent)} in total revenue. #{top_customer&.full_name || 'The top customer'} leads with $#{sprintf('%.2f', top_customer&.total_spent || 0)} in purchases. These customers represent your most valuable relationships and should be prioritized for retention campaigns and personalized offers.",
        sql: "SELECT id, email, first_name, last_name, total_spent_cents FROM customers WHERE tenant_id = #{current_tenant.id} ORDER BY total_spent_cents DESC LIMIT 5;",
        data: top_customers.map { |c| { id: c.id, email: c.email, first_name: c.first_name, last_name: c.last_name, total_spent_cents: c.total_spent_cents, total_spent: sprintf('%.2f', c.total_spent) } }
      }
    elsif prompt_lower.include?("order") || prompt_lower.include?("sales")
      order_count = current_tenant.orders.count
      avg_order_value = current_tenant.orders.average(:total_price_cents).to_f / 100.0
      
      {
        answer: "Your store has processed #{order_count} orders with an average order value of $#{sprintf('%.2f', avg_order_value)}. This indicates healthy sales activity. The order volume and value suggest good customer engagement with your products.",
        sql: "SELECT COUNT(*) as order_count, AVG(total_price_cents)/100.0 as avg_order_value FROM orders WHERE tenant_id = #{current_tenant.id};",
        data: { order_count: order_count, avg_order_value: sprintf('%.2f', avg_order_value) }
      }
    else
      {
        answer: "I can help you analyze your Shopify store data. Try asking specific questions like 'Show me revenue trends for the last 30 days', 'Who are my top customers?', or 'What's my average order value?' I'll provide detailed insights with the supporting data.",
        sql: "-- Try asking: 'Show me revenue for last week' or 'Who are my top customers?'",
        data: {}
      }
    end
  end
end
