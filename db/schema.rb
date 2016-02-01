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

ActiveRecord::Schema.define(version: 20160201070004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "location"
    t.string   "link"
    t.text     "desc"
    t.boolean  "apply_enable", default: false
    t.integer  "category_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "activity_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "event_id"
    t.string   "category_color"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "auth_token"
    t.boolean  "root",            default: false
    t.text     "memo"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "admin_id"
    t.text     "answer"
    t.string   "state",       limit: 1, default: "C", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "attendee_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "event_id"
    t.integer  "category_number"
    t.string   "category_color"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "attendees", force: :cascade do |t|
    t.string   "name"
    t.string   "company"
    t.string   "mobile"
    t.string   "email"
    t.string   "id_photo"
    t.integer  "event_id"
    t.integer  "category_id"
    t.string   "token"
    t.string   "rfid_num"
    t.datetime "checked_in_at"
    t.integer  "attendee_number",      default: 0
    t.integer  "sms_sid"
    t.string   "sms_mobile"
    t.datetime "sms_sent_at"
    t.boolean  "sms_delivered"
    t.datetime "sms_delivered_at"
    t.boolean  "sms_failed"
    t.string   "sms_error"
    t.string   "invitation_short_url"
    t.integer  "gender_id",            default: 0
    t.string   "province"
    t.string   "city"
    t.datetime "printed_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "checkins", force: :cascade do |t|
    t.integer  "session_id"
    t.integer  "attendee_id"
    t.datetime "checked_in_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "checkins", ["attendee_id"], name: "index_checkins_on_attendee_id", using: :btree
  add_index "checkins", ["session_id"], name: "index_checkins_on_session_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.date     "start"
    t.date     "end"
    t.boolean  "enabled"
    t.text     "desc"
    t.string   "location"
    t.string   "contact"
    t.string   "contact_number"
    t.string   "event_link"
    t.string   "time_zone",      default: "Beijing"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "invitation_settings", force: :cascade do |t|
    t.integer  "event_id"
    t.text     "content"
    t.string   "date"
    t.string   "check_in_time"
    t.string   "location"
    t.string   "address"
    t.string   "map_url",       limit: 1000
    t.text     "qr_tip"
    t.string   "event_alias"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "company"
    t.string   "mobile"
    t.string   "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "question_content"
    t.integer  "session_id"
    t.integer  "attendee_id"
    t.integer  "event_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "recommends", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "category_name"
    t.string   "recommend_name"
    t.string   "address"
    t.string   "phone_number"
    t.integer  "distance"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "seats", force: :cascade do |t|
    t.integer  "session_id"
    t.integer  "table_num"
    t.integer  "per_table_num"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "sellers", force: :cascade do |t|
    t.integer  "manager_id"
    t.integer  "event_id"
    t.string   "name"
    t.string   "responsible_area"
    t.string   "phone_number"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "location"
    t.string   "baidu_map_location_url"
    t.text     "desc"
    t.boolean  "checkin_enabled"
    t.boolean  "hidden",                 default: false
    t.boolean  "company_checkin",        default: false
    t.boolean  "question_enabled",       default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "sms_templates", force: :cascade do |t|
    t.string   "sign"
    t.string   "content"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "checkins", "attendees"
  add_foreign_key "checkins", "sessions"
end
