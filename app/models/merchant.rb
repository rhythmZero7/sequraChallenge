# frozen_string_literal: true

# This is the merchant class.
class Merchant < ApplicationRecord
  enum :disbursement_frequency, %i[DAILY WEEKLY]

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :reference, presence: true, uniqueness: true
end
