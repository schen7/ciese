# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20130710192736) do
=======
ActiveRecord::Schema.define(version: 20130830152750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "profile_id"
    t.integer  "program_id"
    t.string   "detail"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "ciese_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "prefix"
    t.string   "title"
    t.string   "greeting"
    t.string   "ssn"
    t.string   "email1"
    t.string   "email2"
    t.string   "department"
    t.string   "subject"
    t.string   "grade"
    t.string   "function"
    t.string   "district"
    t.string   "affiliation"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "home_address_line_1"
    t.string   "home_address_line_2"
    t.string   "home_city"
    t.string   "home_state"
    t.string   "home_zip"
    t.string   "home_phone"
    t.string   "home_mobile"
    t.string   "home_fax"
    t.string   "memo1"
    t.string   "memo2"
    t.string   "memo3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
>>>>>>> cd209e65cdcd4f28c667a782b90ec496e5855bd3

  create_table "programs", force: true do |t|
    t.string   "name"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",        null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.boolean  "admin",           null: false
    t.boolean  "staff",           null: false
    t.boolean  "active",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
