# frozen_string_literal: true

# This is the disbursement class.
class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates :reference, uniqueness: true

  validates :amount_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :fee_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_create :set_reference

  scope :within_last_month, lambda { |date|
    where('created_at BETWEEN ? AND ?', date.beginning_of_month, date)
  }

  scope :created_between, lambda { |start_date, end_date|
    where('created_at BETWEEN ? AND ?', start_date, end_date)
  }

  def self.first_of_month?(date = Time.now)
    within_last_month(date).empty?
  end

  def amount
    amount_in_cents / 100
  end

  def fee
    fee_in_cents / 100
  end

  def extra_fee(date = Time.now)
    if merchant.complies_with_fee?(date)
      0
    else
      merchant.minimum_monthly_fee_in_cents - merchant.total_monthly_fee_to_date(date)
    end
  end

  private

  def set_reference
    self.reference ||= SecureRandom.alphanumeric(16)
  end
end
