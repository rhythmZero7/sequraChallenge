# frozen_string_literal: true

class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string :email, null: false
      t.string :reference, null: false, index: { unique: true, name: 'unique_references' }
      t.date :live_on
      t.integer :disbursement_frequency, default: 0
      t.integer :minimum_monthly_fee_in_cents, null: false, default: 0

      t.timestamps
    end
  end
end
