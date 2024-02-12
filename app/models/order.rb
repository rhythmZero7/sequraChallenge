# frozen_string_literal: true

# This is the merchant class.
class Order < ApplicationRecord
  belongs_to :merchant

  validates :amount_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :not_disbursed, -> { where(disbursed_at: nil) }

  scope :created_between, lambda { |start_date, end_date|
    where('created_at BETWEEN ? AND ?', start_date, end_date)
  }

  def self.disburse(reference, orders_to_disburse)
    disbursement = Disbursement.find_by(reference: reference)
    orders_to_disburse.each do |o|
      o.update(disbursed_at: disbursement.created_at, disbursement_id: disbursement.id)
    end
  end

  def merchant_reference
    merchant.reference
  end

  def amount
    amount_in_cents / 100
  end

  def fee
    fee_in_cents / 100
  end

  # The disbursed amount has the following fee per order:
  # 1% fee for amounts smaller than 50 €
  # 0.95% for amounts between 50€ - 300€
  # 0.85% for amounts over 300€
  def fee_in_cents
    if amount_in_cents < 5000
      (amount_in_cents * 0.01).round
    elsif amount_in_cents < 30_000
      (amount_in_cents * 0.0095).round
    else
      (amount_in_cents * 0.0085).round
    end
  end
end
