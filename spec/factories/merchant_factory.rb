# frozen_string_literal: true

# spec/factories/merchant_factory.rb
FactoryBot.define do
  factory :merchant do
    email { Faker::Internet.email.to_s }
    minimum_monthly_fee_in_cents { rand(100..2000) }
    reference do
      "#{Faker::Alphanumeric.alpha(number: 10)}_#{Faker::Alphanumeric.alpha(number: 6)} "
    end

    trait :daily do
      disbursement_frequency { :DAILY }
    end

    trait :weekly do
      disbursement_frequency { :WEEKLY }
    end
  end
end
