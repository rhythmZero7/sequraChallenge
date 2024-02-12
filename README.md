# Sequra Backend Coding Challenge

## Author
Sam Samaniego
February, 2024

## Requirements
* Ruby v 3.3.0
* Rails v 7.1.3
* Postgres v 14.10

## Configuration
### 1. Database
Currently system-wide Postgres is used, which can be installed (and automatically run) via normal OS package managers
* MacOS
```
brew install postgres@14
brew services start postgres@14
```

### 2. Rails Setup
#### 2.1 Install gems
```bash
bundle install
```
### 2.2 Setup Databases
```bash
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```
Warning: DO NOT run these seeds unless strictly necessary. It has not been optimized do to time constraints (read explanation below for more details) and could take a while.

## Testing
To run all tests
```bash
rspec
```
## Linting check
```bash
rubocop
```

## Running the disbursement task to populate all disbursements for 2022 and 2023
```bash
rake sequra:generate_disbursements
```

## Results

| Year    | Number of disbursements | Amount to be disbursed to merchants | Amount of order fees |
| ------- | ----------------------- |------------------------------------ | ---------------------|
| 2022    |        13,868           |            38.049.927,65 €          |   3.582.366,40 €     | 
| 2023    |        13,872           |            189.486.930,26 €         |   26.735.749,21 €    |

#### Note

As per the challenge description, charging the minimum_monthly_fee is out of the scope of this challenge. It is not subtracted from the disbursement commissions. That's why the last two columns in the table are not included (yet)

# Design Decisions

## Rake tasks

I decided to provide the solution using a rake task because given the time contraints it was the easiest, fastest, and cleanest way to obtain the desired results without needing a front end. The idea is to include a Sidekiq worker to run a similar task daily in the future.

## Money
Given that we are dealing with money, all fields related to currency were declared as `integer` and converted into cents to avoid `float`'s lack of precision. This should be enough for the scope of this project, where we are using a single currency and basic operations only. However, in a real-life scenario it would probably be a good idea to consider using a pre-existing gem such as `money-rails` to handle conversions and more complex operations without losing precision.

## Architecture
I decided to spend most of my time designing small reusable methods, all of which have been thoroughly tested. These are the building blocks for a strong foundation which can later be easily scaled.

## Service Objects
I decided to use Service Objects in order for multiple database updates to be wrapped in a transaction block, and therefore be safer.
This is the case for the `DisbursementCalculator` service.

## Seeds
I did not optimize the seeding of the DB because I preferred to invest more time in the actual solution than the loading of the data.

## Todo's
A lot can still be done to improve this code.

For example, my next step if given more time would have been adding a worker to start the disbursements calculation for all merchants, by 8:00 UTC daily. However, all the blocks are in place for this development to be achieved in a few lines.

I would also like to add more integration tests although for now I feel confident that unit tests provide enough coverage for the solution to be accurate.


