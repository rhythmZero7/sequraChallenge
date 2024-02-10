# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant do
  ######### VALIDATIONS ###########
  describe '.validations' do
    let(:merchant) { build(:merchant) }

    it 'must have an email' do
      expect do
        merchant.email = nil
      end.to change(merchant, :valid?).from(true).to(false)
    end

    it 'must have a unique email' do
      expect do
        create(:merchant, email: merchant.email)
      end.to change(merchant, :valid?).from(true).to(false)
    end

    it 'must have an email in the correct format' do
      expect do
        merchant.email = 'This is not an email'
      end.to change(merchant, :valid?).from(true).to(false)
    end

    it 'must have a reference' do
      expect do
        merchant.reference = nil
      end.to change(merchant, :valid?).from(true).to(false)
    end

    it 'must have a unique reference' do
      expect do
        create(:merchant, reference: merchant.reference)
      end.to change(merchant, :valid?).from(true).to(false)
    end
  end

  ######### TOTAL MONTHLY FEE TO DATE ###########
  describe '.total_monthly_fee_to_date' do
    let(:merchant) { create(:merchant) }

    before do
      Order.destroy_all
      create_list(:order, 5, merchant: merchant, created_at: 1.day.ago)
    end

    it 'successfully sums all fees for merchants created within range' do
      expect(merchant.total_monthly_fee_to_date).to eq(merchant.orders.sum(&:fee))
    end

    it 'does not sum fees for orders created out of range' do
      order = create(:order, merchant: merchant, amount: 30_000.00, created_at: 2.months.ago)
      # expect(merchant.total_monthly_fee_to_date).not_to eq(merchant.orders.sum(&:fee))
      expect(merchant.total_monthly_fee_to_date).to eq(merchant.orders.sum(&:fee) - order.fee)
    end

    it 'compares to minimum_monthly_fee as expected' do
      total_monthly_fee = merchant.total_monthly_fee_to_date
      merchant.minimum_monthly_fee = total_monthly_fee + 100
      expect(merchant.complies_with_minimum_monthly_fee?).to be(false)
    end
  end

  ######### IS DISBURSEMENT DATE ? ###########
  describe '.disbursement_day?' do
    it 'is true for merchants disbursed daily' do
      merchant = create(:merchant, :daily)
      expect(merchant.disbursement_day?).to be(true)
    end

    it 'is true for merchants disbursed weekly if live_on weekday equals disbursement day' do
      merchant = create(:merchant, :weekly, live_on: Date.today.beginning_of_week)
      disbursement_date = Date.today.beginning_of_week - 1.week
      expect(merchant.disbursement_day?(disbursement_date)).to be(true)
    end

    it 'is false for merchants disbursed weekly if live_on weekday is not equal to disbursement day' do
      merchant = create(:merchant, :weekly, live_on: Date.today.beginning_of_week)
      disbursement_date = Date.today.beginning_of_week - 1.day
      expect(merchant.disbursement_day?(disbursement_date)).to be(false)
    end
  end
end
