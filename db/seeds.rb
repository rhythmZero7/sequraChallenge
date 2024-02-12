require 'csv'

puts "Seeding Merchants"
Merchant.destroy_all
csv_text = File.read(Rails.root.join('lib', 'seeds', 'merchants.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1', col_sep: ';')
csv.each do |row|
  t = Merchant.new
  t.id = row['id']
  t.reference = row['reference']
  t.email = row['email']
  t.live_on = row['live_on']
  t.disbursement_frequency = row['disbursement_frequency'].to_sym
  t.minimum_monthly_fee_in_cents = row['minimum_monthly_fee'] * 100
  t.save
  puts "#{t.id}, #{t.reference} saved"
end

puts "Seeding Orders"
Order.destroy_all
csv_text = File.read(Rails.root.join('lib', 'seeds', 'orders.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1', col_sep: ';')
csv.each do |row|
  merchant = Merchant.find_by(reference: row['merchant_reference'])
  next unless merchant.present?
  t = merchant.orders.new
  t.id = row['id']
  t.amount_in_cents = (row['amount'].to_f * 100).round
  t.created_at = row['created_at']
  t.save
  puts "Order #{t.id} saved for merchant with reference: #{t.merchant.reference}"
end
