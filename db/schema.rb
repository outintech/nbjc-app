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

ActiveRecord::Schema.define(version: 2021_03_04_020052) do

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

  create_table "category_aliases", force: :cascade do |t|
    t.string "alias"
    t.string "title"
    t.bigint "category_bucket_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_bucket_id"], name: "index_category_aliases_on_category_bucket_id"
  end

  create_table "category_aliases_spaces", id: false, force: :cascade do |t|
    t.bigint "category_alias_id", null: false
    t.bigint "space_id", null: false
    t.index ["category_alias_id"], name: "index_category_aliases_spaces_on_category_alias_id"
    t.index ["space_id"], name: "index_category_aliases_spaces_on_space_id"
  end

  create_table "category_buckets", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "indicators", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "space_id"
    t.text "url"
    t.boolean "cover", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["space_id"], name: "index_photos_on_space_id"
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
    t.string "attributed_user", default: "Anonymous", null: false
    t.index ["space_id"], name: "index_reviews_on_space_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "space_indicators", force: :cascade do |t|
    t.bigint "space_id"
    t.bigint "indicator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["indicator_id"], name: "index_space_indicators_on_indicator_id"
    t.index ["space_id"], name: "index_space_indicators_on_space_id"
  end

  create_table "space_languages", force: :cascade do |t|
    t.bigint "space_id"
    t.bigint "language_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["language_id"], name: "index_space_languages_on_language_id"
    t.index ["space_id"], name: "index_space_languages_on_space_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "provider_urn"
    t.string "phone"
    t.text "name"
    t.text "provider_url"
    t.text "url"
    t.jsonb "hours_of_op"
    t.integer "price_level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "latitude"
    t.decimal "longitude"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "addresses", "spaces"
  add_foreign_key "category_aliases", "category_buckets"
  add_foreign_key "photos", "spaces"
  add_foreign_key "reviews", "spaces"
  add_foreign_key "reviews", "users"
end
