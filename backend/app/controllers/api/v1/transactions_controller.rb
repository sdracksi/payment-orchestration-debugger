class Api::V1::TransactionsController < ApplicationController
  def index
    transactions = Transaction.order(processed_at: :desc, id: :desc)

    if params[:status].present?
      transactions = transactions.where(status: params[:status])
    end

    total_count = transactions.count

    page = positive_integer_param(params[:page], default: 1)
    per_page = positive_integer_param(params[:per_page], default: 20)
    per_page = [ per_page, 100 ].min

    total_pages = (total_count.to_f / per_page).ceil

    transactions = transactions.offset((page - 1) * per_page).limit(per_page)

    response.set_header("X-Current-Page", page.to_s)
    response.set_header("X-Per-Page", per_page.to_s)
    response.set_header("X-Total-Count", total_count.to_s)
    response.set_header("X-Total-Pages", total_pages.to_s)

    render json: TransactionSerializer.serialize_collection(transactions)
  end

  def show
    transaction = Transaction.find(params[:id])

    render json: TransactionSerializer.new(transaction).serialize
  end

  private

  def positive_integer_param(value, default:)
    return default if value.blank?

    number = Integer(value, 10)
    number.positive? ? number : default
  rescue ArgumentError, TypeError
    default
  end
end
