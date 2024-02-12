# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursement do
  ######### VALIDATIONS ###########
  describe '.validations' do
    let(:disbursement) { build(:disbursement) }

    it 'must have a unique alphanumeric reference' do
      disbursement.save
      new_disbursement = build(:disbursement, reference: disbursement.reference)
      expect(new_disbursement.valid?).to be(false)
    end

    it 'must have a numeric amount' do
      expect do
        disbursement.amount_in_cents = 'two cents'
      end.to change(disbursement, :valid?).from(true).to(false)
    end

    it 'must have an amount greater than zero' do
      expect do
        disbursement.amount_in_cents = -19
      end.to change(disbursement, :valid?).from(true).to(false)
    end

    it 'must have a numeric fee' do
      expect do
        disbursement.fee_in_cents = 'two cents'
      end.to change(disbursement, :valid?).from(true).to(false)
    end

    it 'must have a fee greater than zero' do
      expect do
        disbursement.fee_in_cents = -12
      end.to change(disbursement, :valid?).from(true).to(false)
    end
  end

  ####### FIRST OF MONTH #########
  describe '.first_of_month?' do
    it 'must be true if there are no other disbursements created that month' do
      expect(described_class.first_of_month?).to be(true)
    end

    it 'must be true even if there are disbursements created on a later data the same month' do
      # This function might be useful in case we'd like to (re)calculate a prev. disbursement
      date = Date.parse('2024-02-09')
      create(:disbursement, created_at: date)
      expect(described_class.first_of_month?(date.beginning_of_month)).to be(true)
    end

    it 'must be false if there is at least one disbursement created on an earlier data the same month' do
      date = Date.parse('2024-02-09')
      create(:disbursement, created_at: date)
      expect(described_class.first_of_month?(date + 1.day)).to be(false)
    end
  end

  ####### EXTRA FEE #########
  describe '.extra fee' do
    let(:merchant) { create(:merchant, :daily, minimum_monthly_fee_in_cents: 1000) }
    let(:disbursement) { create(:disbursement, merchant: merchant) }

    it 'is the amount left to complete the minimum monthly fee for a merchant' do
      expect(disbursement.extra_fee).to eq(merchant.minimum_monthly_fee_in_cents)
    end

    it 'is zero if the merchant complied with its minimum monthly fee' do
      create(:order, merchant: merchant, amount_in_cents: 10_000_00)
      expect(disbursement.extra_fee).to eq(0)
    end
  end
end
