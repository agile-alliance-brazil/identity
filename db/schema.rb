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

ActiveRecord::Schema.define(version: 20150124193218) do

  create_table "authentications", force: :cascade do |t|
    t.string "user_id"
    t.string "provider"
    t.string "uid"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",                              null: false
    t.string   "first_name",                            null: false
    t.string   "last_name",                             null: false
    t.string   "phone"
    t.string   "state"
    t.string   "city"
    t.string   "organization"
    t.string   "website_url"
    t.text     "bio"
    t.string   "country"
    t.string   "twitter_username"
    t.string   "default_locale",         default: "pt", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                 null: false
    t.string   "encrypted_password",                    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token"
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token"
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token"
  add_index "users", ["username"], name: "index_users_on_username"

end
