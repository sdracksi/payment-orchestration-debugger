require "rails_helper"

RSpec.describe "Transactions API", type: :request do
  before do
    host! "localhost"
  end

  describe "GET /api/v1/transactions" do
    it "returns HTTP 200 OK" do
      get "/api/v1/transactions"

      expect(response).to have_http_status(:ok)
    end
  end
end