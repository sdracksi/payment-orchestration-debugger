require "rails_helper"

RSpec.describe "Transactions API", type: :request do
  before do
    host! "localhost"
  end

  let(:json) do
    JSON.parse(response.body)
  end

  describe "GET /api/v1/transactions" do
    before do
      get "/api/v1/transactions"
    end

    it "returns HTTP 200 OK" do
      
      expect(response).to have_http_status(:ok)
    end

    it "returns JSON" do
      expect(response.content_type).to include("application/json")
    end

    it "returns an array of transactions" do
      expect(json).to be_an(Array)
    end

    it "returns transactions with all expected attributes" do
      expect(json.first).to include(
        "id",
        "transaction_reference",
        "merchant_reference",
        "merchant_name",
        "gateway",
        "amount",
        "currency",
        "status",
        "payment_method",
        "latency_ms",
        "processed_at"
      )
    end

    it "returns transactions ordered by processed_at descending" do
      processed_dates = json.map do |transaction|
        Time.zone.parse(transaction["processed_at"])
      end

      expect(processed_dates).to eq(processed_dates.sort.reverse)
    end
  end

  describe "GET /api/v1/transactions?status=successful" do
    before do
      get "/api/v1/transactions", params: { status: "successful" }
    end

    it "returns only successful transactions" do
      json.each do |transaction|
        expect(transaction["status"]).to eq("successful")
      end
    end
  end

  describe "GET /api/v1/transactions/:id" do
    it "returns HTTP 200 OK for an existing transaction" do
      transaction = Transaction.first

      get "/api/v1/transactions/#{transaction.id}"

      expect(response).to have_http_status(:ok)
    end

    it "returns the requested transaction" do
      transaction = Transaction.first

      get "/api/v1/transactions/#{transaction.id}"

      expect(json["id"]).to eq(transaction.id)
      expect(json["transaction_reference"]).to eq(transaction.transaction_reference)
      expect(json["merchant_reference"]).to eq(transaction.merchant_reference)
      expect(json["status"]).to eq(transaction.status)
    end
    
    it "returns HTTP 404 when the transaction does not exist" do
      get "/api/v1/transactions/999999"

      expect(response).to have_http_status(:not_found)
    end
  end
end