require 'rails_helper'

RSpec.describe "Ais", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/ai/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /ask" do
    it "returns http success" do
      get "/ai/ask"
      expect(response).to have_http_status(:success)
    end
  end

end
