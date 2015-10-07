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

ActiveRecord::Schema.define(version: 20151007121312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_versions", force: :cascade do |t|
    t.integer  "application_id", null: false
    t.string   "version",        null: false
    t.integer  "version_code",   null: false
    t.integer  "status",         null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "app_versions", ["application_id"], name: "index_app_versions_on_application_id", using: :btree

  create_table "applications", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "package",    null: false
    t.text     "url",        null: false
    t.text     "icon_url"
    t.integer  "status",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "applications", ["name"], name: "index_applications_on_name", using: :btree
  add_index "applications", ["package"], name: "index_applications_on_package", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "name"
    t.string   "imei",                                      null: false
    t.string   "serial",                                    null: false
    t.string   "wifi_mac_address",                          null: false
    t.string   "bluetooth_mac_address",                     null: false
    t.string   "platform",              default: "Android", null: false
    t.string   "os_version",                                null: false
    t.string   "baseband_version",                          null: false
    t.string   "brand",                                     null: false
    t.string   "model",                                     null: false
    t.string   "phone_number"
    t.string   "id_cisco_asa"
    t.decimal  "screen_size"
    t.string   "screen_resolution"
    t.decimal  "camera"
    t.decimal  "sd_memory_card"
    t.string   "gmail_account"
    t.text     "comments"
    t.integer  "status",                default: 2,         null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "devices", ["imei"], name: "index_devices_on_imei", unique: true, using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.integer  "status",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "permissions", ["name"], name: "index_permissions_on_name", unique: true, using: :btree

  create_table "role_assignations", id: false, force: :cascade do |t|
    t.integer  "role_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "role_assignations", ["role_id", "user_id"], name: "index_role_assignations_on_role_id_and_user_id", unique: true, using: :btree
  add_index "role_assignations", ["user_id", "role_id"], name: "index_role_assignations_on_user_id_and_role_id", unique: true, using: :btree

  create_table "role_permissions", id: false, force: :cascade do |t|
    t.integer  "permission_id", null: false
    t.integer  "role_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "role_permissions", ["permission_id", "role_id"], name: "permission_id_role_id_index", unique: true, using: :btree
  add_index "role_permissions", ["role_id", "permission_id"], name: "role_id_permission_id_index", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "role",        null: false
    t.text     "description"
    t.integer  "status",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_devices", id: false, force: :cascade do |t|
    t.integer  "device_id",  null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_devices", ["device_id", "user_id"], name: "index_user_devices_on_device_id_and_user_id", unique: true, using: :btree
  add_index "user_devices", ["user_id", "device_id"], name: "index_user_devices_on_user_id_and_device_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",             default: "", null: false
    t.string   "authentication_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "role_assignations", "roles"
  add_foreign_key "role_assignations", "users"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "user_devices", "devices"
  add_foreign_key "user_devices", "users"
end
