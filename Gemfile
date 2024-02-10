source "https://rubygems.org"

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Needed in order to seed db from provided files
gem 'csv'

group :development, :test do
  gem 'rubocop', require: false	
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rake', require: false
  gem 'rspec-rails', '~> 6.1.0'
  gem "factory_bot_rails"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'faker'
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-nav'
end
