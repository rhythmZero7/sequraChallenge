# frozen_string_literal: true

# spec/factories/order_factory.rb
FactoryBot.define do
  factory :order do
    merchant
    amount_in_cents { rand(1..25_000) }
  end
end
