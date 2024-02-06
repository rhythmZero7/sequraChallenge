# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant do
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
end
