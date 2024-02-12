# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisbursementCalculator do
  let(:disbursement_date) { Time.parse('09/02/2024 08:00 UTC') }
  let(:merchant) { create(:merchant, :daily) }

  describe '.call' do
    before do
      Order.destroy_all
      create_list(:order, 5, merchant: merchant, created_at: disbursement_date - 5.hours)
    end

    it "creates a disbursement for each merchant who's on a disbursement date" do
      described_class.call(disbursement_date)
      expect(merchant.disbursements.size).to eq(1)
    end

    it 'disburses only for merchants who are on their disbursement date' do
      out_of_scope_merchant = create(:merchant, :weekly, live_on: disbursement_date - 1.day)
      described_class.call(disbursement_date)
      expect(out_of_scope_merchant.disbursements.size).to eq(0)
    end

    it 'creates a disbursement with the expected amount' do
      expected_amount = merchant.orders_to_be_disbursed(disbursement_date).sum(&:amount_in_cents)
      described_class.call(disbursement_date)
      expect(merchant.disbursements.first.amount_in_cents).to eq(expected_amount)
    end

    it 'creates a disbursement with the expected fee amount' do
      expected_fee = merchant.total_monthly_fee_to_date(disbursement_date)
      described_class.call(disbursement_date)
      expect(merchant.disbursements.first.fee_in_cents).to eq(expected_fee)
    end

    it 'updates orders to be disbursed so they are disbursed just once' do
      described_class.call(disbursement_date)
      expect(merchant.orders_to_be_disbursed.empty?).to be(true)
    end
  end
end
