# frozen_string_literal: true

# rubocop:disable all

# app/services/disbursement_calculator.rb
class DisbursementCalculator < ApplicationService
  attr_reader :disbursement_date

  def initialize(disbursement_date)
    @disbursement_date = disbursement_date
  end

  def call
    Merchant.all.each do |merchant|
      next unless merchant.disbursement_day?(@disbursement_date)

      ActiveRecord::Base.transaction do
        orders = merchant.orders_to_be_disbursed(@disbursement_date)
        amount_in_cents = orders.sum(&:amount_in_cents)
        fee_in_cents = merchant.total_monthly_fee_to_date(@disbursement_date)
        d = merchant.disbursements.create!(amount_in_cents: amount_in_cents, fee_in_cents: fee_in_cents, created_at: @disbursement_date)
        Order.disburse(d.reference, orders)
      end
    end
  end
end
