# frozen_string_literal: true

# This is the merchant class.
class Merchant < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :disbursements

  enum :disbursement_frequency, %i[DAILY WEEKLY]

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :reference, presence: true, uniqueness: true

  def total_monthly_fee_to_date(date = Time.now)
    orders.created_between(date - 1.month, date).sum(&:fee)
  end

  def complies_with_minimum_monthly_fee?(date = Time.now)
    total_monthly_fee_to_date(date) > minimum_monthly_fee
  end

  def disbursement_day?(date = Time.now)
    DAILY? || live_on.wday == date.wday
  end
end
