# frozen_string_literal: true

namespace :sequra do
  desc 'Generate disbursements for 2022 and 2023 '
  task generate_disbursements: :environment do
    pp 'Starting to generate disbursements...'
    # Disbursement.destroy_all
    [2022, 2023].each do |year|
      start_string = "01/01/#{year} 08:00 UTC"
      start_date = Time.parse(start_string)
      end_date = start_date.end_of_year
      date = start_date
      while date < end_date
        pp "Generating disbursements for #{date}"
        DisbursementCalculator.call(date)
        date += 1.day
      end
      pp "Successfully finished disbursing all orders for year #{year}"
      year_disbursements = Disbursement.created_between(start_date, end_date)
      pp "Year: #{year}"
      pp "Number of disbursements: #{year_disbursements.size}"
      pp "Amount to be disbursed to merchants: #{year_disbursements.sum(&:amount_in_cents) / 100.0} €"
      pp "Amount of order fees: #{year_disbursements.sum(&:fee_in_cents) / 100.0} €"
    end
  end
end
