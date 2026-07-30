FactoryBot.define do
  factory :transaction do
    transaction_reference { "MyString" }
    merchant_reference { "MyString" }
    merchant_name { "MyString" }
    gateway { "MyString" }
    amount { "9.99" }
    currency { "MyString" }
    status { 1 }
    payment_method { "MyString" }
    latency_ms { 1 }
    processed_at { "2026-07-30 18:51:20" }
  end
end
