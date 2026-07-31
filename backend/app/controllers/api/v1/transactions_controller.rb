class Api::V1::TransactionsController < ApplicationController
  def index
    transactions = Transaction.order(processed_at: :desc)

    render json: TransactionSerializer.serialize_collection(transactions)
  end
end
