class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_reference, null: false
      t.string :merchant_reference
      t.string :merchant_name, null: false
      t.string :gateway, null: false

      t.decimal :amount,
                precision: 10,
                scale: 2,
                null: false

      t.string :currency, null: false

      t.integer :status,
                default: 0,
                null: false

      t.string :payment_method, null: false

      t.integer :latency_ms, null: false

      t.datetime :processed_at, null: false

      t.timestamps
    end

    add_index :transactions, :transaction_reference, unique: true
    add_index :transactions, :merchant_reference
    add_index :transactions, :gateway
    add_index :transactions, :status
    add_index :transactions, :processed_at
  end
end