# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
  ####### VALIDATIONS #########
  describe '.validations' do
    let(:order) { build(:order) }

    it 'must have an amount' do
      expect do
        order.amount = nil
      end.to change(order, :valid?).from(true).to(false)
    end

    it 'must have a numeric amount' do
      expect do
        order.amount = 'two cents'
      end.to change(order, :valid?).from(true).to(false)
    end

    it 'must have an amount greater than zero' do
      expect do
        order.amount = -17.25
      end.to change(order, :valid?).from(true).to(false)
    end
  end

  ####### CREATED BETWEEN SCOPE #########
  describe '.created_between' do
    it 'must include orders created within time range' do
      start_date = Date.today - 1.week
      end_date = Date.today
      timely_order = create(:order, created_at: Date.today - 1.day)
      expect(described_class.created_between(start_date,
                                             end_date).include?(timely_order)).to be(true)
    end

    it 'must NOT include orders created within time range' do
      start_date = Date.today - 1.week
      end_date = Date.today
      untimely_order = create(:order, created_at: Date.today + 1.day)
      expect(described_class.created_between(start_date,
                                             end_date).include?(untimely_order)).to be(false)
    end
  end

  ####### FEE CALCULATIONS #########
  describe '.fee' do
    it 'is 1.00% for orders with an amount strictly smaller than 50 €' do
      small_order = create(:order, amount: 49.99)
      expect(small_order.fee).to eq(small_order.amount * BigDecimal('0.01'))
    end

    it 'is 0.95% for orders with an amount between 50 € and 300 €' do
      %w[50.00 120.00 299.99].each do |amount|
        medium_order = create(:order, amount: amount)
        expect(medium_order.fee).to eq(medium_order.amount * BigDecimal('0.0095'))
      end
    end

    it 'is 0.85% for orders with an amount of 300 € or more' do
      large_order = create(:order, amount: 300.00)
      expect(large_order.fee).to eq(large_order.amount * BigDecimal('0.0085'))
    end
  end
end
