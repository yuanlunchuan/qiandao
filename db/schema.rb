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

ActiveRecord::Schema.define(version: 20160122020820) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "auth_token"
    t.boolean  "root",            default: false
    t.text     "memo"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "advertisements", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "shop_id",                                                  null: false
    t.uuid     "scenes_spot_id",                                           null: false
    t.string   "title",                    default: "",                    null: false
    t.string   "ad_type",                  default: "",                    null: false
    t.string   "state",          limit: 1, default: "C",                   null: false
    t.datetime "opened_at",                default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                  default: false,                 null: false
    t.json     "property",                 default: {},                    null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  create_table "ali_pay_notifies", force: :cascade do |t|
    t.uuid     "order_id",                                                        null: false
    t.string   "discount",                        default: "",                    null: false
    t.string   "payment_type",        limit: 4,   default: "",                    null: false
    t.string   "subject",             limit: 150, default: "",                    null: false
    t.string   "trade_no",            limit: 64,  default: "",                    null: false
    t.string   "buyer_email",         limit: 100, default: "",                    null: false
    t.datetime "gmt_create",                      default: '1970-01-01 00:00:00', null: false
    t.string   "notify_type",                     default: "",                    null: false
    t.integer  "quantity",                        default: 1,                     null: false
    t.string   "out_trade_no",        limit: 64,  default: "",                    null: false
    t.string   "seller_id",           limit: 30,  default: "",                    null: false
    t.datetime "notify_time",                     default: '1970-01-01 00:00:00', null: false
    t.string   "body",                limit: 512, default: "",                    null: false
    t.string   "trade_status",                    default: "",                    null: false
    t.string   "total_fee",                       default: "",                    null: false
    t.datetime "gmt_payment",                     default: '1970-01-01 00:00:00', null: false
    t.string   "seller_email",        limit: 100, default: "",                    null: false
    t.string   "price",                           default: "",                    null: false
    t.string   "buyer_id",            limit: 30,  default: "",                    null: false
    t.string   "notify_id",                       default: "",                    null: false
    t.string   "use_coupon",          limit: 1,   default: "",                    null: false
    t.string   "sign_type",                       default: "",                    null: false
    t.string   "sign",                            default: "",                    null: false
    t.string   "is_total_fee_adjust", limit: 1,   default: "N",                   null: false
    t.string   "state",               limit: 1,   default: "C",                   null: false
    t.datetime "opened_at",                       default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                       default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                         default: false,                 null: false
    t.json     "property",                        default: {},                    null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
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

  create_table "authenticatings", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "visitor_id",                                               null: false
    t.string   "visitor_type",  limit: 64, default: "",                    null: false
    t.uuid     "identity_id",                                              null: false
    t.string   "identity_type", limit: 64, default: "",                    null: false
    t.string   "state",         limit: 1,  default: "C",                   null: false
    t.datetime "opened_at",                default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                  default: false,                 null: false
    t.json     "properties",               default: {},                    null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "authenticatings", ["identity_id"], name: "index_authenticatings_on_identity_id", using: :btree

  create_table "bosses", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "login_count",           default: 0,                     null: false
    t.string   "state",       limit: 1, default: "C",                   null: false
    t.datetime "opened_at",             default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",             default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",               default: false,                 null: false
    t.json     "property",              default: {},                    null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
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

  create_table "china_mobile_phone_numbers", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "phone_number", limit: 11,                                 null: false
    t.boolean  "verified",                default: false,                 null: false
    t.boolean  "elemental",               default: false,                 null: false
    t.string   "state",        limit: 1,  default: "C",                   null: false
    t.datetime "opened_at",               default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",               default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                 default: false,                 null: false
    t.json     "properties",              default: {},                    null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "china_mobile_phone_numbers", ["phone_number"], name: "index_china_mobile_phone_numbers_on_phone_number", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.date     "start"
    t.date     "end"
    t.boolean  "enabled"
    t.text     "desc"
    t.string   "location"
    t.string   "contact"
    t.string   "contact_number"
    t.string   "time_zone",      default: "Beijing"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "foods", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "shop_id",                                              null: false
    t.string   "food_name",            default: "",                    null: false
    t.string   "food_desc",            default: "",                    null: false
    t.string   "state",      limit: 1, default: "C",                   null: false
    t.datetime "opened_at",            default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",            default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",              default: false,                 null: false
    t.json     "property",             default: {},                    null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "guests", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id"
    t.cidr     "guest_ip",                                             null: false
    t.string   "guest_name",           default: "0",                   null: false
    t.string   "state",      limit: 1, default: "C",                   null: false
    t.datetime "opened_at",            default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",            default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",              default: false,                 null: false
    t.json     "property",             default: {},                    null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "guests", ["guest_ip"], name: "index_guests_on_guest_ip", using: :btree

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

  create_table "locations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "owner_id",                                                null: false
    t.string   "owner_type",   limit: 64, default: "",                    null: false
    t.float    "latitude",                default: 0.0,                   null: false
    t.float    "longitude",               default: 0.0,                   null: false
    t.string   "address",                 default: "",                    null: false
    t.text     "address_desc"
    t.string   "state",        limit: 1,  default: "C",                   null: false
    t.datetime "opened_at",               default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",               default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                 default: false,                 null: false
    t.json     "property",                default: {},                    null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
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

  create_table "order_items", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "order_id",                                                   null: false
    t.string   "phone_number",               default: "",                    null: false
    t.integer  "wireless_traffic",           default: 0,                     null: false
    t.string   "state",            limit: 1, default: "C",                   null: false
    t.datetime "opened_at",                  default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                  default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                    default: false,                 null: false
    t.json     "property",                   default: {},                    null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "order_items", ["phone_number"], name: "index_order_items_on_phone_number", using: :btree
  add_index "order_items", ["wireless_traffic"], name: "index_order_items_on_wireless_traffic", using: :btree

  create_table "orders", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "guest_id",                                                 null: false
    t.uuid     "scenes_spot_id",                                           null: false
    t.string   "order_num",                default: "",                    null: false
    t.integer  "total_fee",                default: 0,                     null: false
    t.string   "state",          limit: 1, default: "C",                   null: false
    t.datetime "opened_at",                default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                  default: false,                 null: false
    t.json     "property",                 default: {},                    null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "orders", ["order_num"], name: "index_orders_on_order_num", using: :btree

  create_table "passwords", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "hashed_content", limit: 64,                                 null: false
    t.string   "pepper_content", limit: 64,                                 null: false
    t.string   "state",          limit: 1,  default: "C",                   null: false
    t.datetime "opened_at",                 default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                 default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                   default: false,                 null: false
    t.json     "properties",                default: {},                    null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "passwords", ["hashed_content"], name: "index_passwords_on_hashed_content", using: :btree

  create_table "people", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "person_id",                                              null: false
    t.string   "person_type",            default: "",                    null: false
    t.string   "person_name", limit: 30, default: "",                    null: false
    t.string   "gender",      limit: 1,  default: "F",                   null: false
    t.string   "state",       limit: 1,  default: "C",                   null: false
    t.datetime "opened_at",              default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",              default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                default: false,                 null: false
    t.json     "property",               default: {},                    null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "pictures", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "subject_id",                                                    null: false
    t.string   "subject_type",      limit: 64,  default: "",                    null: false
    t.uuid     "uuid",                                                          null: false
    t.integer  "ordinal",                       default: 0,                     null: false
    t.string   "name",              limit: 200, default: "",                    null: false
    t.string   "picture",           limit: 200, default: "",                    null: false
    t.integer  "width",                         default: 0,                     null: false
    t.integer  "height",                        default: 0,                     null: false
    t.integer  "file_size",                     default: 0,                     null: false
    t.string   "content_type",      limit: 20,  default: "",                    null: false
    t.string   "md5sum",            limit: 32,                                  null: false
    t.string   "original_filename", limit: 200, default: "",                    null: false
    t.string   "state",             limit: 1,   default: "C",                   null: false
    t.datetime "opened_at",                     default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                     default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                       default: false,                 null: false
    t.json     "properties",                    default: {},                    null: false
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "pictures", ["subject_id"], name: "index_pictures_on_subject_id", using: :btree
  add_index "pictures", ["uuid"], name: "index_pictures_on_uuid", unique: true, using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "question_content"
    t.integer  "session_id"
    t.integer  "attendee_id"
    t.integer  "event_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "scenes_blocks", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "scenes_spot_id",                                              null: false
    t.string   "scenes_block_name",           default: "",                    null: false
    t.text     "scenes_block_desc"
    t.string   "state",             limit: 1, default: "C",                   null: false
    t.datetime "opened_at",                   default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                   default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                     default: false,                 null: false
    t.json     "property",                    default: {},                    null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  create_table "scenes_spots", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "scenes_spot_name",           default: "",                    null: false
    t.string   "state",            limit: 1, default: "C",                   null: false
    t.datetime "opened_at",                  default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                  default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                    default: false,                 null: false
    t.json     "property",                   default: {},                    null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "seats", force: :cascade do |t|
    t.integer  "session_id"
    t.integer  "table_num"
    t.integer  "per_table_num"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "location"
    t.text     "desc"
    t.boolean  "checkin_enabled"
    t.boolean  "hidden",           default: false
    t.boolean  "company_checkin",  default: false
    t.boolean  "question_enabled", default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "shops", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "boss_id",                                                  null: false
    t.uuid     "scenes_spot_id",                                           null: false
    t.float    "coordinates",              default: [],                    null: false, array: true
    t.string   "address",                  default: "",                    null: false
    t.string   "shop_name",                default: "",                    null: false
    t.string   "state",          limit: 1, default: "C",                   null: false
    t.datetime "opened_at",                default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                  default: false,                 null: false
    t.json     "property",                 default: {},                    null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  create_table "sms_templates", force: :cascade do |t|
    t.string   "sign"
    t.string   "content"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "state",      limit: 1, default: "C",                   null: false
    t.datetime "opened_at",            default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",            default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",              default: false,                 null: false
    t.json     "properties",           default: {},                    null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "verificatings", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "visitor_id",                                                 null: false
    t.string   "visitor_type",    limit: 64, default: "",                    null: false
    t.uuid     "credential_id",                                              null: false
    t.string   "credential_type", limit: 64, default: "",                    null: false
    t.string   "state",           limit: 1,  default: "C",                   null: false
    t.datetime "opened_at",                  default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                  default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                    default: false,                 null: false
    t.json     "properties",                 default: {},                    null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "verificatings", ["credential_id"], name: "index_verificatings_on_credential_id", using: :btree
  add_index "verificatings", ["visitor_id", "credential_id", "visitor_type", "credential_type"], name: "index_verificatings_on_visitor_credential", unique: true, using: :btree

  create_table "wx_pay_notifies", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "order_id",                                                   null: false
    t.uuid     "wx_prepayment_id",                                           null: false
    t.string   "appid",                      default: "",                    null: false
    t.string   "bank_type",                  default: "",                    null: false
    t.string   "cash_fee",                   default: "",                    null: false
    t.string   "fee_type",                   default: "",                    null: false
    t.string   "is_subscribe",               default: "",                    null: false
    t.string   "mch_id",                     default: "",                    null: false
    t.string   "openid",                     default: "",                    null: false
    t.string   "nonce_str",                  default: "",                    null: false
    t.string   "out_trade_no",               default: "",                    null: false
    t.string   "sign",                       default: "",                    null: false
    t.string   "time_end",                   default: "",                    null: false
    t.string   "trade_type",                 default: "",                    null: false
    t.string   "transaction_id",             default: "",                    null: false
    t.string   "result_code",                default: "",                    null: false
    t.string   "return_code",                default: "",                    null: false
    t.integer  "total_fee",                  default: 0,                     null: false
    t.string   "state",            limit: 1, default: "C",                   null: false
    t.datetime "opened_at",                  default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",                  default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",                    default: false,                 null: false
    t.json     "property",                   default: {},                    null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "wx_pay_notifies", ["appid"], name: "index_wx_pay_notifies_on_appid", using: :btree

  create_table "wx_prepayments", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "order_id",                                             null: false
    t.string   "appid",                default: "",                    null: false
    t.string   "mch_id",               default: "",                    null: false
    t.string   "nonce_str",            default: "",                    null: false
    t.string   "sign",                 default: "",                    null: false
    t.string   "prepay_id",            default: "",                    null: false
    t.string   "trade_type",           default: "",                    null: false
    t.string   "state",      limit: 1, default: "C",                   null: false
    t.datetime "opened_at",            default: '1970-01-01 00:00:00', null: false
    t.datetime "closed_at",            default: '3000-01-01 00:00:00', null: false
    t.boolean  "defunct",              default: false,                 null: false
    t.json     "property",             default: {},                    null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "wx_prepayments", ["prepay_id"], name: "index_wx_prepayments_on_prepay_id", using: :btree

  add_foreign_key "checkins", "attendees"
  add_foreign_key "checkins", "sessions"
end
