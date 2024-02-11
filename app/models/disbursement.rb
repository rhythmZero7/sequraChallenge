# frozen_string_literal: true

# This is the disbursement class.
class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates :reference, uniqueness: true

  validates :amount, numericality: true, comparison: { greater_than_or_equal_to: 0 }
  validates :fee, numericality: true, comparison: { greater_than_or_equal_to: 0 }

  before_create :set_reference

  scope :within_last_month, lambda { |date|
    where('created_at BETWEEN ? AND ?', date.beginning_of_month, date)
  }

  def self.first_of_month?(date = Time.now)
    within_last_month(date).empty?
  end

  def extra_fee(date = Time.now)
    if merchant.complies_with_minimum_monthly_fee?(date)
      BigDecimal('0.00')
    else
      merchant.minimum_monthly_fee - merchant.total_monthly_fee_to_date(date)
    end
  end

  private

  def set_reference
    self.reference ||= SecureRandom.alphanumeric(16)
  end
end
