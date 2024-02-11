# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    merchant { FactoryBot.build(:merchant) }
    amount { 0.00 }
    fee { 0.00 }
  end
end
