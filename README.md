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

## Running a Developer Server
```bash
bundle exec rails server
```

## Description

## Endpoint
Exposes the disbursements for a given merchant on a given week.
If no merchant is provided return for all of them.

```
@path [GET] /merchant/disbursements

@parameter (body)[integer](id)
@parameter (body, required)[date](week)
@response 200 merchant_disbursements (by week)
@response 400 Invalid parameters
@response 404 merchant not found
```
# Design Decisions

## Money
Given that we are dealing with money, all fields related to currency were declared as `bigint` with `precision: 8` and `scale: 2`. This should be enough for the scope of this project, where we are using a single currency and basic operations only. However, in a real-life scenario it would probably be a good idea to consider using a pre-existing gem such as `money-rails` to handle conversions and more complex operations without losing precision.

Additionally, to achieve perfect precision, all operations involving currency were handled by using the BigDecimal class provided in Ruby. Ideally there should be a helper to detect these scenarios throughout the codebase, but it wasn't included due to time constraints.

## Seeds
I did not optimize the seeding of the DB because I preferred to invest more time in the actual solution than the loading of the data.

### Todo's
A lot can still be done to improve this code.

Would have also liked to add a programmed job to run the Worker each Monday.


