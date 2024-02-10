# frozen_string_literal: true

# spec/factories/order_factory.rb
FactoryBot.define do
  factory :order do
    merchant { FactoryBot.build(:merchant) }
    amount { rand(1.0..25_000.00) }
  end
end
