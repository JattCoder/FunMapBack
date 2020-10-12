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

ActiveRecord::Schema.define(version: 6) do

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "photo"
    t.string "phone"
    t.string "password_digest"
    t.string "recovery"
    t.string "method"
    t.boolean "confirmed", default: false
    t.string "member_type"
    t.string "created_at"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "account_id"
    t.integer "contact_id"
    t.string "name"
    t.string "email"
    t.string "phone"
  end

  create_table "families", force: :cascade do |t|
    t.integer "admin_id"
    t.string "name"
    t.string "code"
    t.string "admins"
    t.string "users"
    t.string "created_at"
    t.string "date"
  end

  create_table "favs", force: :cascade do |t|
    t.integer "account_id"
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.string "placeid"
    t.string "type"
    t.string "created_at"
  end

  create_table "fpins", force: :cascade do |t|
    t.string "account_id"
    t.string "code"
    t.string "time"
  end

  create_table "loggs", force: :cascade do |t|
    t.string "account_id"
    t.string "email"
    t.string "mac_address"
    t.string "time"
  end

end
