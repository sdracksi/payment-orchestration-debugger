class Api::V1::TransactionsController < ApplicationController
  def index
    transactions = Transaction.order(processed_at: :desc)

    if params[:status].present?
      transactions = transactions.where(status: params[:status])
    end

    render json: TransactionSerializer.serialize_collection(transactions)
  end
end
