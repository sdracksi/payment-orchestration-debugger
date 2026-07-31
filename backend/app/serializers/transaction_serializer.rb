class TransactionSerializer

    def initialize(transaction)
    @transaction = transaction
    end

    def serialize
    {
      id: @transaction.id,
      transaction_reference: @transaction.transaction_reference,
      merchant_reference: @transaction.merchant_reference,
      merchant_name: @transaction.merchant_name,
      gateway: @transaction.gateway,
      amount: @transaction.amount.to_f,
      currency: @transaction.currency,
      status: @transaction.status,
      payment_method: @transaction.payment_method,
      latency_ms: @transaction.latency_ms,
      processed_at: @transaction.processed_at.iso8601
    }
  end

  def self.serialize_collection(transactions)
    transactions.map do |transaction|
      new(transaction).serialize
    end
  end

end