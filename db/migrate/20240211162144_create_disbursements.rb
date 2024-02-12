# frozen_string_literal: true

class CreateDisbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :disbursements do |t|
      t.string :reference, null: false, index: { unique: true, name: 'unique_disbursements' }
      t.integer :amount_in_cents, null: false
      t.integer :fee_in_cents, null: false
      t.belongs_to :merchant

      t.timestamps
    end
  end
end
