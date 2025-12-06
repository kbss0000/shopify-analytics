module Shopify
  class Client
    attr_reader :domain, :access_token

    def initialize(domain:, access_token:)
      @domain = domain
      @access_token = access_token
      @base_url = "https://#{domain}/admin/api/2024-01"
    end

    def get(path, params: {})
      response = connection.get(path) do |req|
        req.params = params
      end
      
      # Store response object for pagination parsing
      @last_response = response
      handle_response(response)
    end

    def post(path, body: {})
      response = connection.post(path) do |req|
        req.body = body.to_json
      end
      
      handle_response(response)
    end

    # API endpoints
    def customers(params: {})
      get('/customers.json', params: params)
    end

    def customer(id)
      get("/customers/#{id}.json")
    end

    def orders(params: {})
      get('/orders.json', params: params)
    end

    def order(id)
      get("/orders/#{id}.json")
    end

    def products(params: {})
      get('/products.json', params: params)
    end

    def product(id)
      get("/products/#{id}.json")
    end

    private

    def connection
      @connection ||= Faraday.new(url: @base_url) do |faraday|
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.response :raise_error
        faraday.headers['X-Shopify-Access-Token'] = @access_token
        faraday.headers['Content-Type'] = 'application/json'
        faraday.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      case response.status
      when 200..299
        response.body
      when 429
        raise RateLimitError, "Shopify API rate limit exceeded"
      when 401, 403
        raise AuthenticationError, "Invalid Shopify credentials"
      when 404
        raise NotFoundError, "Resource not found"
      else
        raise APIError, "Shopify API error: #{response.status} - #{response.body}"
      end
    end

    # Extract pagination info from Link header
    # Shopify uses cursor-based pagination with Link headers
    def extract_page_info_from_response
      return nil unless @last_response
      
      # Check both header formats (case-insensitive)
      link_header = @last_response.headers['Link'] || 
                    @last_response.headers['link'] ||
                    @last_response.headers['LINK']
      
      return nil unless link_header
      
      # Parse Link header format:
      # <https://domain.myshopify.com/admin/api/2024-01/orders.json?page_info=abc123&limit=250>; rel="next"
      # or multiple links separated by commas
      links = link_header.split(',')
      
      links.each do |link|
        if link.include?('rel="next"') || link.include?("rel='next'")
          # Extract page_info parameter from URL
          match = link.match(/page_info=([^&>\"\']+)/)
          return match[1] if match
        end
      end
      
      nil
    end
  end

  # Custom exceptions
  class APIError < StandardError; end
  class RateLimitError < APIError; end
  class AuthenticationError < APIError; end
  class NotFoundError < APIError; end
end
