# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisbursementCalculator do
  let(:disbursement_date) { Time.parse('09/02/2024 08:00 UTC') }
  let(:merchant) { create(:merchant, :daily) }

  describe '.call' do
    it "creates a disbursement for each merchant who's on a disbursement date" do
      5.times do
        create(:order, merchant: merchant, created_at: disbursement_date - 5.hours)
      end
      expect do
        described_class.call(disbursement_date)
      end.to change(merchant.disbursements, :size).from(0).to(1)
    end
  end
end
