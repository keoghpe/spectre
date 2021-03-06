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

ActiveRecord::Schema.define(version: 20180731073100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baselines", force: :cascade do |t|
    t.string   "name"
    t.string   "browser"
    t.string   "size"
    t.integer  "suite_id"
    t.string   "screenshot_uid"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "key"
    t.integer  "test_id"
  end

  add_index "baselines", ["suite_id"], name: "index_baselines_on_suite_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "slug"
    t.integer  "baseline_suite_id"
    t.string   "github_repo"
  end

  add_index "projects", ["baseline_suite_id"], name: "index_projects_on_baseline_suite_id", using: :btree

  create_table "runs", force: :cascade do |t|
    t.integer  "suite_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "sequential_id"
    t.string   "sha"
    t.integer  "screenshot_count",     default: 0
    t.string   "access_token"
    t.datetime "access_token_expires"
    t.string   "state"
  end

  add_index "runs", ["suite_id"], name: "index_runs_on_suite_id", using: :btree

  create_table "suites", force: :cascade do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "tests", force: :cascade do |t|
    t.string   "name"
    t.string   "browser"
    t.string   "size"
    t.integer  "run_id"
    t.float    "diff"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "screenshot_uid"
    t.string   "screenshot_baseline_uid"
    t.string   "screenshot_diff_uid"
    t.string   "key"
    t.boolean  "pass"
    t.string   "source_url"
    t.string   "fuzz_level"
    t.string   "highlight_colour"
    t.string   "crop_area"
  end

  add_index "tests", ["run_id"], name: "index_tests_on_run_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "approved",               default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "baselines", "suites"
  add_foreign_key "runs", "suites"
  add_foreign_key "tests", "runs"
end
