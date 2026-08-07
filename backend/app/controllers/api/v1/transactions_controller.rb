class Api::V1::TransactionsController < ApplicationController
  def index
    Rails.logger.info "******** TRANSACTIONS CONTROLLER WAS HIT ********"
    transactions = Transaction.order(processed_at: :desc)

    render json: TransactionSerializer.serialize_collection(transactions)
  end
end
