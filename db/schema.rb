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

ActiveRecord::Schema.define(version: 20160627135413) do

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
    t.boolean  "root",                            default: false
    t.text     "memo"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "restaurant_permission"
    t.boolean  "session_manage_permission"
    t.boolean  "session_notifacation_permission"
    t.boolean  "attendee_manage_permission"
    t.boolean  "checkin_manage_permission"
    t.boolean  "interaction_manage_permission"
    t.boolean  "seller_manage_permission"
    t.boolean  "event_manage_permission"
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
    t.integer  "owner_attendee_id"
    t.integer  "seller_id"
    t.string   "token"
    t.string   "rfid_num"
    t.string   "level"
    t.integer  "login_count",          default: 0
    t.datetime "checked_in_at"
    t.integer  "attendee_number",      default: 0
    t.string   "sms_sid"
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

  create_table "event_lottery_prize_items", force: :cascade do |t|
    t.integer  "event_lottery_prize_id"
    t.string   "name"
    t.integer  "count"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "event_lottery_prizes", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.text     "comment"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "allow_attendee_repeat_take_in", default: false
    t.string   "lottery_prize_method",          default: "attendee"
  end

  create_table "event_questions", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.string   "time_zone",                      default: "Beijing"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "domain_name"
    t.string   "title"
    t.text     "content"
    t.string   "head_photo_file_name"
    t.string   "head_photo_content_type"
    t.integer  "head_photo_file_size"
    t.datetime "head_photo_updated_at"
    t.string   "event_logo_file_name"
    t.string   "event_logo_content_type"
    t.integer  "event_logo_file_size"
    t.datetime "event_logo_updated_at"
    t.boolean  "display_welcome_page",           default: true
    t.boolean  "opposite_color",                 default: true
    t.string   "welcome_page_logo_file_name"
    t.string   "welcome_page_logo_content_type"
    t.integer  "welcome_page_logo_file_size"
    t.datetime "welcome_page_logo_updated_at"
    t.string   "welcome_bg_file_name"
    t.string   "welcome_bg_content_type"
    t.integer  "welcome_bg_file_size"
    t.datetime "welcome_bg_updated_at"
    t.boolean  "admission_certificate"
    t.boolean  "session_schedule"
    t.boolean  "hotel_info"
    t.boolean  "nearby_recommend"
    t.boolean  "seat_info"
    t.boolean  "outside_link"
    t.boolean  "interactive_answer"
    t.boolean  "lottery"
    t.boolean  "defunct",                        default: false
    t.integer  "admission_certificate_order",    default: 1
    t.integer  "session_schedule_order",         default: 2
    t.integer  "hotel_info_order",               default: 3
    t.integer  "nearby_recommend_order",         default: 4
    t.integer  "seat_info_order",                default: 5
    t.integer  "outside_link_order",             default: 6
    t.integer  "interactive_answer_order",       default: 7
    t.integer  "lottery_order",                  default: 8
  end

  create_table "invitation_settings", force: :cascade do |t|
    t.integer  "event_id"
    t.text     "content"
    t.string   "date"
    t.string   "check_in_time"
    t.string   "location"
    t.string   "address"
    t.string   "map_url",            limit: 1000
    t.text     "qr_tip"
    t.string   "event_alias"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "token"
    t.integer  "attendee_number",                 default: 0
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "lottery_prize_categories", force: :cascade do |t|
    t.integer  "event_lottery_prize_id"
    t.integer  "attendee_category_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "lottery_prizes", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "attendee_id"
    t.integer  "event_lottery_prize_item_id"
    t.integer  "event_lottery_prize_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "state",                       default: "C"
    t.boolean  "is_specify",                  default: false
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
    t.integer  "attendee_id"
    t.integer  "event_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "event_question_id"
    t.integer  "praise_count",      default: 0
    t.boolean  "enable_display",    default: false
  end

  create_table "recommends", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "category_name"
    t.string   "recommend_name"
    t.string   "address"
    t.string   "phone_number"
    t.float    "distance"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "baidu_url"
  end

  create_table "restaurants", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "restaurant_name"
    t.string   "phone_number"
    t.string   "address"
    t.string   "map_url",         limit: 1000
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "seats", force: :cascade do |t|
    t.integer  "session_id"
    t.integer  "attendee_id"
    t.integer  "table_row"
    t.integer  "table_col"
    t.string   "desc"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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

  create_table "session_locations", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "location_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "session_seats", force: :cascade do |t|
    t.integer  "session_id"
    t.integer  "total_table_count"
    t.integer  "per_table_num"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.json     "properties",        default: {}
    t.boolean  "display"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "location"
    t.string   "baidu_map_location_url"
    t.text     "desc"
    t.string   "contact_name"
    t.string   "contact_phone_number"
    t.boolean  "checkin_enabled"
    t.boolean  "hidden",                 default: false
    t.boolean  "company_checkin",        default: false
    t.boolean  "question_enabled",       default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "session_location_id"
  end

  create_table "sms_templates", force: :cascade do |t|
    t.string   "sign"
    t.string   "content"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_infos", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "content"
    t.boolean  "display",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_foreign_key "checkins", "attendees"
  add_foreign_key "checkins", "sessions"
end
