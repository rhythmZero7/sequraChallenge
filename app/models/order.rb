# frozen_string_literal: true

# This is the merchant class.
class Order < ApplicationRecord
  belongs_to :merchant

  validates :amount, presence: true, numericality: true, comparison: { greater_than_or_equal_to: 0 }

  scope :not_disbursed, -> { where(disbursed_at: nil) }

  scope :created_between, lambda { |start_date, end_date|
    where('created_at BETWEEN ? AND ?', start_date, end_date)
  }

  def merchant_reference
    merchant.reference
  end

  # The disbursed amount has the following fee per order:
  # 1% fee for amounts smaller than 50 €
  # 0.95% for amounts between 50€ - 300€
  # 0.85% for amounts over 300€
  def fee
    if amount < BigDecimal('50.00')
      amount * BigDecimal('0.01')
    elsif amount < BigDecimal('300.00')
      amount * BigDecimal('0.0095')
    else
      amount * BigDecimal('0.0085')
    end
  end

  def disbursed?
    disbursed_at.present?
  end
end
