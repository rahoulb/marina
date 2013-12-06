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

ActiveRecord::Schema.define(version: 20131206155442) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "marina_db_members", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_members", ["email"], name: "index_marina_db_members_on_email", using: :btree
  add_index "marina_db_members", ["last_name"], name: "index_marina_db_members_on_last_name", using: :btree

  create_table "marina_db_subscription_plans", force: true do |t|
    t.string   "type"
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_subscription_plans", ["name"], name: "index_marina_db_subscription_plans_on_name", unique: true, using: :btree

  create_table "marina_db_subscriptions", force: true do |t|
    t.integer  "plan_id"
    t.integer  "member_id"
    t.boolean  "active",     default: false, null: false
    t.date     "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_subscriptions", ["member_id"], name: "index_marina_db_subscriptions_on_member_id", using: :btree
  add_index "marina_db_subscriptions", ["plan_id"], name: "index_marina_db_subscriptions_on_plan_id", using: :btree

end
