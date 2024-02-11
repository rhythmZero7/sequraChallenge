# frozen_string_literal: true

# This is the disbursement class.
class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates :reference, uniqueness: true

  validates :amount, numericality: true, comparison: { greater_than_or_equal_to: 0 }
  validates :fee, numericality: true, comparison: { greater_than_or_equal_to: 0 }

  before_create :set_reference, :set_amount, :set_fee

  private

  def set_reference
    self.reference ||= SecureRandom.alphanumeric(16)
  end

  def set_amount
    self.amount ||= 0.00
  end

  def set_fee
    self.fee ||= 0.00
  end
end
