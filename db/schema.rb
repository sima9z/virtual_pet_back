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

ActiveRecord::Schema[7.0].define(version: 2024_09_13_050051) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "breed", null: false
    t.integer "experience", default: 0, null: false
    t.integer "level", default: 1, null: false
    t.integer "states", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "physical", default: 30
    t.integer "satiety", default: 20
    t.integer "happiness", default: 20
    t.integer "offspring_count", default: 0
    t.boolean "bred_at_level_3", default: false
    t.integer "max_physical", default: 50
    t.datetime "last_update_at"
    t.integer "max_satiety", default: 100
    t.integer "max_happiness", default: 100
    t.index ["user_id"], name: "index_cats_on_user_id"
  end

  create_table "dogs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "breed", null: false
    t.integer "experience", default: 0, null: false
    t.integer "level", default: 1, null: false
    t.integer "states", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "physical", default: 30
    t.integer "satiety", default: 20
    t.integer "happiness", default: 20
    t.integer "offspring_count", default: 0
    t.boolean "bred_at_level_3", default: false
    t.integer "max_physical", default: 50
    t.datetime "last_update_at"
    t.integer "max_satiety", default: 100
    t.integer "max_happiness", default: 100
    t.index ["user_id"], name: "index_dogs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.datetime "last_logout_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "cats", "users"
  add_foreign_key "dogs", "users"
end
