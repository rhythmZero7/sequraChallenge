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
        disbursement.amount = 'two cents'
      end.to change(disbursement, :valid?).from(true).to(false)
    end

    it 'must have an amount greater than zero' do
      expect do
        disbursement.amount = -17.25
      end.to change(disbursement, :valid?).from(true).to(false)
    end

    it 'must have a numeric fee' do
      expect do
        disbursement.fee = 'two cents'
      end.to change(disbursement, :valid?).from(true).to(false)
    end

    it 'must have a fee greater than zero' do
      expect do
        disbursement.fee = -17.25
      end.to change(disbursement, :valid?).from(true).to(false)
    end
  end
end
