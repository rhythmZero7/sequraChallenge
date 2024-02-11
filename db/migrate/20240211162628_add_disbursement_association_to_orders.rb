# frozen_string_literal: true

class AddDisbursementAssociationToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :disbursement, index: true
  end
end
