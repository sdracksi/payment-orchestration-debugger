# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# frozen_string_literal: true

puts "🌱 Seeding Payment Orchestration Debugger..."

MERCHANTS = [
  "Amazon",
  "Netflix",
  "Spotify",
  "Uber",
  "Airbnb",
  "Takealot",
  "Mr D",
  "Checkers",
  "Woolworths",
  "Apple"
].freeze

GATEWAYS = Transaction::SUPPORTED_GATEWAYS

PAYMENT_METHODS = Transaction::SUPPORTED_PAYMENT_METHODS

CURRENCIES = [
  "USD",
  "EUR",
  "GBP",
  "ZAR"
].freeze

STATUSES = Transaction.statuses.keys.freeze

puts "Deleting existing transactions..."

Transaction.delete_all

NUMBER_OF_TRANSACTIONS = 100

puts "Creating #{NUMBER_OF_TRANSACTIONS} sample transactions..."

NUMBER_OF_TRANSACTIONS.times do
  Transaction.create!(
    transaction_reference: "txn_#{SecureRandom.hex(8)}",
    merchant_reference: "ORD-#{rand(100000..999999)}",
    merchant_name: MERCHANTS.sample,
    gateway: GATEWAYS.sample,
    amount: rand(10.0..1000.0).round(2),
    currency: CURRENCIES.sample,
    status: STATUSES.sample,
    payment_method: PAYMENT_METHODS.sample,
    latency_ms: rand(50..2000),
    processed_at: rand(30).days.ago
  )
end

