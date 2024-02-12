# frozen_string_literal: true

# This is the merchant class.
class Merchant < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :disbursements

  enum :disbursement_frequency, %i[DAILY WEEKLY]

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :minimum_monthly_fee, presence: true, numericality: true,
                                  comparison: { greater_than_or_equal_to: 0, only_integer: true }
  validates :reference, presence: true, uniqueness: true

  def minimum_monthly_fee
    minimum_monthly_fee_in_cents / 100
  end

  def orders_to_be_disbursed(date = Time.now)
    span = DAILY? ? 1.day : 1.week
    orders.not_disbursed.created_between(date - span, date)
  end

  def total_monthly_fee_to_date(date = Time.now)
    orders.created_between(date - 1.month, date).sum(&:fee_in_cents)
  end

  def complies_with_fee?(date = Time.now)
    total_monthly_fee_to_date(date) > minimum_monthly_fee_in_cents
  end

  def disbursement_day?(date = Time.now)
    DAILY? || live_on.wday == date.wday
  end
end
