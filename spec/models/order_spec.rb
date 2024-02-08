# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order do
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

    it 'must have an amounti greater than zero' do
      expect do
        order.amount = -17.25
      end.to change(order, :valid?).from(true).to(false)
    end
  end
end
