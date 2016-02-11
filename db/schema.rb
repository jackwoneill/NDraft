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

ActiveRecord::Schema.define(version: 20160211044700) do

  create_table "balances", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contests", force: :cascade do |t|
    t.string   "title"
    t.float    "fee"
    t.integer  "max_size"
    t.integer  "curr_size"
    t.float    "prize_pool"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "slate_id"
    t.boolean  "closed"
    t.integer  "payment_structure"
    t.boolean  "paid_out"
    t.datetime "start_time"
  end

  create_table "deposits", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer  "team_1"
    t.integer  "team_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.integer  "slate_id"
  end

  create_table "lineups", force: :cascade do |t|
    t.integer  "top"
    t.integer  "mid"
    t.integer  "adc"
    t.integer  "support"
    t.integer  "jungler"
    t.integer  "flex_1"
    t.integer  "flex_2"
    t.integer  "flex_3"
    t.integer  "user_id"
    t.integer  "contest_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "total_score"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.text     "description"
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.integer  "salary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "avgFP"
    t.string   "position"
    t.integer  "team_id"
    t.float    "live_score"
  end

  create_table "slates", force: :cascade do |t|
    t.datetime "start_time"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stream_links", force: :cascade do |t|
    t.integer  "slate_id"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "abbrev"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "league"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "permissions"
    t.float    "balance"
    t.float    "total_winnings"
    t.string   "display_name",           default: "", null: false
  end

end