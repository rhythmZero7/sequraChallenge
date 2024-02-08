# frozen_string_literal: true

# This is the merchant class.
class Order < ApplicationRecord
  belongs_to :merchant

  validates :amount, presence: true, numericality: true, comparison: { greater_than_or_equal_to: 0 }

  def merchant_reference
    merchant.reference
  end
end
