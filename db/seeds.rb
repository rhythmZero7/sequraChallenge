require 'csv'

puts "Seeding Merchants"
csv_text = File.read(Rails.root.join('lib', 'seeds', 'merchants.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1', col_sep: ';')
csv.each do |row|
  t = Merchant.new
  t.id = row['id']
  t.reference = row['reference']
  t.email = row['email']
  t.live_on = row['live_on']
  t.disbursement_frequency = row['disbursement_frequency'].to_sym
  t.minimum_monthly_fee = row['minimum_monthly_fee']
  t.save
  puts "#{t.id}, #{t.reference} saved"
end
