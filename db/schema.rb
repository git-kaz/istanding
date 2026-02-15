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

ActiveRecord::Schema[8.1].define(version: 2026_02_13_212116) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "exercises", force: :cascade do |t|
    t.integer "category"
    t.string "cloudinary_public_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "sitting_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration"
    t.boolean "notified"
    t.datetime "notify_at"
    t.datetime "start_at"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sitting_sessions_on_user_id"
  end

  create_table "suggested_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "exercise_id", null: false
    t.bigint "sitting_session_id", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_suggested_actions_on_exercise_id"
    t.index ["sitting_session_id"], name: "index_suggested_actions_on_sitting_session_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "auth"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "endpoint"
    t.string "p256dh"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "sitting_sessions", "users"
  add_foreign_key "suggested_actions", "exercises"
  add_foreign_key "suggested_actions", "sitting_sessions"
end
