# frozen_string_literal: true

# rubocop:disable all

# app/services/disbursement_calculator.rb
class DisbursementCalculator < ApplicationService
  attr_reader :disbursement_date

  def initialize(disbursement_date)
    @disbursement_date = disbursement_date
  end

  def call
    disbursements = []
    Merchant.all.each do |merchant|
      next unless merchant.disbursement_day?(@disbursement_date)

      ActiveRecord::Base.transaction do
        puts "Creating disbursement for merchant #{merchant.reference}"
        orders = merchant.orders_to_be_disbursed(@disbursement_date)
        amount = orders.sum(&:amount)
        fee = merchant.total_monthly_fee_to_date(@disbursement_date)
        d = merchant.disbursements.create!(amount: amount, fee: fee, created_at: @disbursement_date)
        orders.each do |order|
          order.disbursed_at = d.created_at
          order.disbursement_id = d.id
        end

        disbursements << d
      end
    end
  end
end
