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

ActiveRecord::Schema.define(version: 20160114071901) do

  create_table "admins", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "password_digest", limit: 255
    t.string   "auth_token",      limit: 255
    t.boolean  "root",            limit: 1,     default: false
    t.text     "memo",            limit: 65535
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "attendee_categories", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "event_id",        limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "category_number", limit: 4
  end

  create_table "attendees", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "company",              limit: 255
    t.string   "mobile",               limit: 255
    t.string   "email",                limit: 255
    t.string   "id_photo",             limit: 255
    t.integer  "event_id",             limit: 4
    t.integer  "category_id",          limit: 4
    t.string   "token",                limit: 255
    t.string   "rfid_num",             limit: 255
    t.datetime "checked_in_at"
    t.integer  "attendee_number",      limit: 4,   default: 0
    t.integer  "sms_sid",              limit: 4
    t.string   "sms_mobile",           limit: 255
    t.datetime "sms_sent_at"
    t.boolean  "sms_delivered",        limit: 1
    t.datetime "sms_delivered_at"
    t.boolean  "sms_failed",           limit: 1
    t.string   "sms_error",            limit: 255
    t.string   "invitation_short_url", limit: 255
    t.integer  "gender_id",            limit: 4,   default: 0
    t.string   "province",             limit: 255
    t.string   "city",                 limit: 255
    t.datetime "printed_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "photo_file_name",      limit: 255
    t.string   "photo_content_type",   limit: 255
    t.integer  "photo_file_size",      limit: 4
    t.datetime "photo_updated_at"
    t.string   "avatar_file_name",     limit: 255
    t.string   "avatar_content_type",  limit: 255
    t.integer  "avatar_file_size",     limit: 4
    t.datetime "avatar_updated_at"
  end

  create_table "checkins", force: :cascade do |t|
    t.integer  "session_id",    limit: 4
    t.integer  "attendee_id",   limit: 4
    t.datetime "checked_in_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "checkins", ["attendee_id"], name: "index_checkins_on_attendee_id", using: :btree
  add_index "checkins", ["session_id"], name: "index_checkins_on_session_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.date     "start"
    t.date     "end"
    t.boolean  "enabled",        limit: 1
    t.text     "desc",           limit: 65535
    t.string   "location",       limit: 255
    t.string   "contact",        limit: 255
    t.string   "contact_number", limit: 255
    t.string   "time_zone",      limit: 255,   default: "Beijing"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "invitation_settings", force: :cascade do |t|
    t.integer  "event_id",      limit: 4
    t.text     "content",       limit: 65535
    t.string   "date",          limit: 255
    t.string   "check_in_time", limit: 255
    t.string   "location",      limit: 255
    t.string   "address",       limit: 255
    t.string   "map_url",       limit: 1000
    t.text     "qr_tip",        limit: 65535
    t.string   "event_alias",   limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "company",    limit: 255
    t.string   "mobile",     limit: 255
    t.string   "photo",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "event_id",        limit: 4
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "location",        limit: 255
    t.text     "desc",            limit: 65535
    t.boolean  "checkin_enabled", limit: 1
    t.boolean  "hidden",          limit: 1,     default: false
    t.boolean  "company_checkin", limit: 1,     default: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "sms_templates", force: :cascade do |t|
    t.string   "sign",       limit: 255
    t.string   "content",    limit: 255
    t.integer  "event_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "checkins", "attendees"
  add_foreign_key "checkins", "sessions"
end
