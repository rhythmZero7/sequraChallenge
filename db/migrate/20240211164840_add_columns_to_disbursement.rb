# frozen_string_literal: true

class AddColumnsToDisbursement < ActiveRecord::Migration[7.1]
  def change
    add_column :disbursements, :amount, :decimal, precision: 10, scale: 2
    add_column :disbursements, :fee, :decimal, precision: 10, scale: 2
  end
end
