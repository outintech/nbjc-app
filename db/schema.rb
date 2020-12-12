# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_12_180252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "space_id"
    t.text "address_1"
    t.text "address_2"
    t.string "city"
    t.string "postal_code"
    t.string "country"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["space_id"], name: "index_addresses_on_space_id", unique: true
  end

  create_table "indicator_lists", force: :cascade do |t|
    t.bigint "space_id"
    t.boolean "atm", default: false
    t.boolean "queer_friendly", default: false
    t.boolean "asl_friendly", default: false
    t.boolean "wheelchair_accessible", default: false
    t.boolean "gender_neutral_restroom", default: false
    t.boolean "black_owned", default: false
    t.boolean "poc_owned", default: false
    t.string "languages", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["languages"], name: "index_indicator_lists_on_languages", using: :gin
    t.index ["space_id"], name: "index_indicator_lists_on_space_id", unique: true
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "space_id"
    t.text "url"
    t.boolean "cover", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["space_id"], name: "index_photos_on_space_id", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.boolean "anonymous"
    t.integer "vibe_check"
    t.integer "rating"
    t.text "content"
    t.bigint "space_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["space_id"], name: "index_reviews_on_space_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id", unique: true
  end

  create_table "spaces", force: :cascade do |t|
    t.string "yelp_id"
    t.string "phone"
    t.text "name"
    t.text "yelp_url"
    t.text "url"
    t.jsonb "hours_of_op"
    t.point "coordinates"
    t.integer "price_level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "spaces"
  add_foreign_key "indicator_lists", "spaces"
  add_foreign_key "photos", "spaces"
  add_foreign_key "reviews", "spaces"
  add_foreign_key "reviews", "users"
end
