# frozen_string_literal: true

# spec/factories/merchant_factory.rb
FactoryBot.define do
  factory :merchant do
    email { Faker::Internet.email.to_s }
    reference do
      "#{Faker::Alphanumeric.alpha(number: 10)}_#{Faker::Alphanumeric.alpha(number: 6)} "
    end

    trait :daily do
      disbursement_frequency { :daily }
    end

    trait :weekly do
      disbursement_frequency { :weekly }
    end
  end
end
