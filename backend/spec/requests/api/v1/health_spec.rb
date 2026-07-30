require "rails_helper"

RSpec.describe "Health API", type: :request do
  before do
    host! "localhost"
  end

  describe "GET /api/v1/health" do
    it "returns a healthy response" do
      get "/api/v1/health"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["status"]).to eq("ok")
      expect(json["service"]).to eq("payment-orchestration-debugger")
      expect(json["version"]).to eq("1.0.0")
      expect(json).to have_key("timestamp")
    end
  end
end
