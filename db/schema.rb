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

ActiveRecord::Schema.define(version: 20140228193723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "poem_tweets", force: true do |t|
    t.integer  "poem_id"
    t.integer  "tweet_id"
    t.integer  "line_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poems", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", force: true do |t|
    t.string   "text"
    t.integer  "num_syllables"
    t.integer  "twitter_handle_id"
    t.string   "last_word"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tweet_status_url"
    t.string   "tweet_status_num"
  end

  add_index "tweets", ["last_word"], name: "index_tweets_on_last_word", using: :btree
  add_index "tweets", ["tweet_status_num"], name: "index_tweets_on_tweet_status_num", unique: true, using: :btree

  create_table "twitter_handles", force: true do |t|
    t.string   "handle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_searched"
    
  end

  add_index "twitter_handles", ["handle"], name: "index_twitter_handles_on_handle", using: :btree

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_handle_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
