# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  ####### VALIDATIONS #########
  describe '.validations' do
    let(:order) { build(:order) }

    it 'must have an amount' do
      expect do
        order.amount_in_cents = nil
      end.to change(order, :valid?).from(true).to(false)
    end

    it 'must have a numeric amount' do
      expect do
        order.amount_in_cents = 'two cents'
      end.to change(order, :valid?).from(true).to(false)
    end

    it 'must have an amount greater than zero' do
      expect do
        order.amount_in_cents = -17
      end.to change(order, :valid?).from(true).to(false)
    end
  end

  ####### CREATED BETWEEN SCOPE #########
  describe '.created_between' do
    it 'must include orders created within time range' do
      start_date = Date.today - 1.week
      end_date = Date.today
      timely_order = create(:order, created_at: Date.today - 1.day)
      expect(described_class.created_between(start_date, end_date).include?(timely_order)).to be(true)
    end

    it 'must NOT include orders created within time range' do
      start_date = Date.today - 1.week
      end_date = Date.today
      untimely_order = create(:order, created_at: Date.today + 1.day)
      expect(described_class.created_between(start_date, end_date).include?(untimely_order)).to be(false)
    end
  end

  ####### FEE CALCULATIONS #########
  describe '.fee' do
    it 'is 1.00% for orders with an amount strictly smaller than 50 €' do
      small_order = create(:order, amount_in_cents: 4999)
      expected_amount = (small_order.amount_in_cents * 0.01).round
      expect(small_order.fee_in_cents).to eq(expected_amount)
    end

    it 'is 0.95% for orders with an amount between 50 € and 300 €' do
      %w[5000 12000 29999].each do |amount|
        medium_order = create(:order, amount_in_cents: amount)
        expected_amount = (medium_order.amount_in_cents * 0.0095).round
        expect(medium_order.fee_in_cents).to eq(expected_amount)
      end
    end

    it 'is 0.85% for orders with an amount of 300 € or more' do
      large_order = create(:order, amount_in_cents: 30_000)
      expected_amount = (large_order.amount_in_cents * 0.0085).round
      expect(large_order.fee_in_cents).to eq(expected_amount)
    end
  end
end
