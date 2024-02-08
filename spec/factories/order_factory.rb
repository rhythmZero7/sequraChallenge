# frozen_string_literal: true

# spec/factories/order_factory.rb
FactoryBot.define do
  factory :order do
    merchant { FactoryBot.build(:merchant) }
    amount { Faker::Commerce.price(range: 0..10_000.0) }
  end
end
