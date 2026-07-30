# == Schema Information
#
# Table name: transactions
#
# Represents a payment transaction processed through a payment gateway.
# This is the core business entity of the Payment Orchestration Debugger.
#
class Transaction < ApplicationRecord
  enum :status, {
    pending: 0,
    authorized: 1,
    captured: 2,
    failed: 3,
    refunded: 4
  }

  SUPPORTED_GATEWAYS = %w[
    stripe
    adyen
    worldpay
    checkout_com
    braintree
    cybersource
  ].freeze

  SUPPORTED_PAYMENT_METHODS = %w[
  card
  apple_pay
  google_pay
 paypal
].freeze

  validates :transaction_reference,
            presence: true,
            uniqueness: true

  validates :merchant_name,
            presence: true

  validates :gateway,
            presence: true,
            inclusion: { in: SUPPORTED_GATEWAYS }

  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }

  validates :currency,
            presence: true

  validates :payment_method,
            presence: true,
            inclusion: { in: SUPPORTED_PAYMENT_METHODS }

  validates :latency_ms,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :processed_at,
            presence: true
end
