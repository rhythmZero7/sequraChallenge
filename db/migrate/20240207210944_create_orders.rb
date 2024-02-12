# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.integer :amount_in_cents, null: false
      t.datetime :disbursed_at
      t.belongs_to :merchant

      t.timestamps
    end
  end
end
