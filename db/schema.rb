# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_16_193321) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "campaigns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "campaigns_users", id: false, force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.integer "user_id", null: false
  end

  create_table "character_sheet_templates", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.jsonb "data", default: {}
    t.string "name"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_character_sheet_templates_on_campaign_id"
  end

  create_table "character_sheets", force: :cascade do |t|
    t.bigint "character_sheet_template_id", null: false
    t.datetime "created_at", null: false
    t.jsonb "data", default: {}
    t.bigint "player_character_id", null: false
    t.datetime "updated_at", null: false
    t.index ["character_sheet_template_id"], name: "index_character_sheets_on_character_sheet_template_id"
    t.index ["player_character_id"], name: "index_character_sheets_on_player_character_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "friend_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_locations_on_campaign_id"
  end

  create_table "non_player_characters", force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_non_player_characters_on_campaign_id"
  end

  create_table "player_characters", force: :cascade do |t|
    t.integer "campaign_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["campaign_id"], name: "index_player_characters_on_campaign_id"
    t.index ["user_id"], name: "index_player_characters_on_user_id"
  end

  create_table "relations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.integer "target_id", null: false
    t.string "target_type", null: false
    t.datetime "updated_at", null: false
    t.index ["source_type", "source_id", "target_type", "target_id"], name: "index_relations_uniqueness", unique: true
    t.index ["source_type", "source_id"], name: "index_relations_on_source"
    t.index ["target_type", "target_id"], name: "index_relations_on_target"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campaigns", "users"
  add_foreign_key "character_sheet_templates", "campaigns"
  add_foreign_key "character_sheets", "character_sheet_templates"
  add_foreign_key "character_sheets", "player_characters"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "locations", "campaigns"
  add_foreign_key "non_player_characters", "campaigns"
  add_foreign_key "player_characters", "campaigns"
  add_foreign_key "player_characters", "users"
  add_foreign_key "sessions", "users"
end
