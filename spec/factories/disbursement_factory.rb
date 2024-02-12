# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    merchant
    amount_in_cents { 0 }
    fee_in_cents { 0 }
  end
end
