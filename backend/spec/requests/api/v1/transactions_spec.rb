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

    it "returns pagination metadata in response headers" do
      get "/api/v1/transactions"

      expect(response.headers["X-Current-Page"]).to eq("1")
      expect(response.headers["X-Per-Page"]).to eq("20")
      expect(response.headers["X-Total-Count"]).not_to be_nil
      expect(response.headers["X-Total-Pages"]).not_to be_nil
    end

    it "supports requesting a specific page and page size" do
      get "/api/v1/transactions", params: { page: 2, per_page: 20 }

      expect(response).to have_http_status(:ok)
      expect(response.headers["X-Current-Page"]).to eq("2")
      expect(response.headers["X-Per-Page"]).to eq("20")
    end

    it "limits the page size to 100 transactions" do
      get "/api/v1/transactions", params: { page: 1, per_page: 500 }

      expect(response).to have_http_status(:ok)
      expect(response.headers["X-Per-Page"]).to eq("100")
      expect(json.length).to be <= 100
    end


    it "returns different transactions on consecutive pages" do
      first_page_response = nil
      second_page_response = nil

      get "/api/v1/transactions", params: { page: 1, per_page: 1 }
      first_page_response = JSON.parse(response.body)

      get "/api/v1/transactions", params: { page: 2, per_page: 1 }
      second_page_response = JSON.parse(response.body)

      expect(first_page_response.length).to eq(1)
      expect(second_page_response.length).to eq(1)
      expect(first_page_response.first["id"]).not_to eq(second_page_response.first["id"])
    end


    it "uses default values for invalid pagination parameters" do
      get "/api/v1/transactions", params: { page: "abc", per_page: "xyz" }

      expect(response).to have_http_status(:ok)
      expect(response.headers["X-Current-Page"]).to eq("1")
      expect(response.headers["X-Per-Page"]).to eq("20")
    end

    it "uses default values for non-positive pagination parameters" do
      get "/api/v1/transactions", params: { page: 0, per_page: 0 }

      expect(response).to have_http_status(:ok)
      expect(response.headers["X-Current-Page"]).to eq("1")
      expect(response.headers["X-Per-Page"]).to eq("20")
    end

    it "returns an empty array and zero total pages when no transactions match" do
      get "/api/v1/transactions", params: { status: "no_matching_status" }

      expect(response).to have_http_status(:ok)
      expect(json).to eq([])
      expect(response.headers["X-Total-Count"]).to eq("0")
      expect(response.headers["X-Total-Pages"]).to eq("0")
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

    it "returns pagination metadata for the filtered results" do
      get "/api/v1/transactions",
          params: { status: "successful", page: 1, per_page: 5 }

      expect(response).to have_http_status(:ok)
      expect(response.headers["X-Current-Page"]).to eq("1")
      expect(response.headers["X-Per-Page"]).to eq("5")

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
