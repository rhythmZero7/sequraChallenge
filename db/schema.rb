# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_11_162628) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "disbursements", force: :cascade do |t|
    t.string "reference", null: false
    t.integer "amount_in_cents", null: false
    t.integer "fee_in_cents", null: false
    t.bigint "merchant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
    t.index ["reference"], name: "unique_disbursements", unique: true
  end

  create_table "merchants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "reference", null: false
    t.date "live_on"
    t.integer "disbursement_frequency", default: 0
    t.integer "minimum_monthly_fee_in_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "unique_references", unique: true
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount_in_cents", null: false
    t.datetime "disbursed_at"
    t.bigint "merchant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "disbursement_id"
    t.index ["disbursement_id"], name: "index_orders_on_disbursement_id"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

end
