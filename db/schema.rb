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

ActiveRecord::Schema.define(version: 20140126173227) do

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

  create_table "marina_db_affiliate_organisations", force: true do |t|
    t.integer  "site_id"
    t.string   "name",                                           default: "",    null: false
    t.decimal  "discount",               precision: 8, scale: 2, default: 0.0,   null: false
    t.boolean  "applies_to_memberships",                         default: false, null: false
    t.boolean  "applies_to_tickets",                             default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marina_db_asset_pages", force: true do |t|
    t.integer  "site_id"
    t.string   "type"
    t.string   "name"
    t.text     "contents"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_asset_pages", ["site_id", "name"], name: "index_marina_db_asset_pages_on_site_id_and_name", unique: true, using: :btree

  create_table "marina_db_field_definitions", force: true do |t|
    t.integer  "site_id"
    t.string   "name",       null: false
    t.string   "label",      null: false
    t.string   "type",       null: false
    t.text     "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_field_definitions", ["site_id"], name: "index_marina_db_field_definitions_on_site_id", using: :btree

  create_table "marina_db_log_entries", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "type"
    t.text     "data"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_log_entries", ["owner_type", "owner_id", "created_at"], name: "log_entry_owner", using: :btree

  create_table "marina_db_mailout_deliveries", force: true do |t|
    t.integer  "mailout_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_mailout_deliveries", ["mailout_id"], name: "index_marina_db_mailout_deliveries_on_mailout_id", using: :btree
  add_index "marina_db_mailout_deliveries", ["member_id"], name: "index_marina_db_mailout_deliveries_on_member_id", using: :btree

  create_table "marina_db_mailouts", force: true do |t|
    t.integer  "site_id"
    t.integer  "sender_id"
    t.string   "subject"
    t.string   "from_address"
    t.text     "contents"
    t.boolean  "send_to_all_members", default: false
    t.boolean  "test",                default: false
    t.text     "recipient_plan_ids"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_mailouts", ["site_id"], name: "index_marina_db_mailouts_on_site_id", using: :btree

  create_table "marina_db_members", force: true do |t|
    t.integer  "site_id"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "api_token"
    t.boolean  "receives_mailshots", default: false, null: false
    t.string   "visible_to"
    t.text     "visible_plans"
    t.text     "permissions"
    t.text     "data"
    t.text     "biography"
    t.string   "title"
    t.text     "address"
    t.string   "town"
    t.string   "county"
    t.string   "postcode"
    t.string   "country"
    t.string   "telephone"
    t.string   "web_address"
    t.string   "source"
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_members", ["site_id", "api_token"], name: "index_marina_db_members_on_site_id_and_api_token", unique: true, using: :btree
  add_index "marina_db_members", ["site_id", "created_at", "visible_to"], name: "index_marina_db_members_on_site_id_and_created_at_and_visible_to", using: :btree
  add_index "marina_db_members", ["site_id", "email"], name: "index_marina_db_members_on_site_id_and_email", using: :btree
  add_index "marina_db_members", ["site_id", "last_name"], name: "index_marina_db_members_on_site_id_and_last_name", using: :btree
  add_index "marina_db_members", ["site_id", "username"], name: "index_marina_db_members_on_site_id_and_username", using: :btree

  create_table "marina_db_subscription_plans", force: true do |t|
    t.integer  "site_id"
    t.string   "type"
    t.string   "name",                                                                       null: false
    t.decimal  "price",                              precision: 10, scale: 2
    t.integer  "length"
    t.string   "supporting_information_label"
    t.text     "supporting_information_description"
    t.text     "feature_levels"
    t.boolean  "active",                                                      default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_subscription_plans", ["site_id", "name"], name: "index_marina_db_subscription_plans_on_site_id_and_name", unique: true, using: :btree

  create_table "marina_db_subscription_reviewed_plan_applications", force: true do |t|
    t.integer  "plan_id"
    t.integer  "member_id"
    t.integer  "administrator_id"
    t.integer  "affiliated_organisation_id"
    t.string   "affiliate_membership_details"
    t.text     "supporting_information"
    t.text     "reason_for_rejection"
    t.text     "reason_for_affiliation_rejection"
    t.string   "status",                           default: "awaiting_review", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_subscription_reviewed_plan_applications", ["plan_id"], name: "reviewed_plan_applications_plan_id", using: :btree

  create_table "marina_db_subscriptions", force: true do |t|
    t.integer  "plan_id"
    t.integer  "member_id"
    t.boolean  "active",                default: false, null: false
    t.date     "expires_on"
    t.boolean  "lifetime_subscription", default: false, null: false
    t.float    "credit",                default: 0.0,   null: false
    t.string   "identifier",            default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_subscriptions", ["member_id"], name: "index_marina_db_subscriptions_on_member_id", using: :btree
  add_index "marina_db_subscriptions", ["plan_id"], name: "index_marina_db_subscriptions_on_plan_id", using: :btree

  create_table "marina_db_vouchers", force: true do |t|
    t.integer  "site_id"
    t.string   "code",                               default: "", null: false
    t.string   "type"
    t.integer  "days"
    t.decimal  "amount",     precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "marina_db_vouchers", ["site_id", "code"], name: "index_marina_db_vouchers_on_site_id_and_code", using: :btree

end
