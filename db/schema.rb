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

ActiveRecord::Schema[8.1].define(version: 2026_02_10_190502) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "guest_email"
    t.string "guest_name"
    t.bigint "service_id", null: false
    t.datetime "start_time"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_appointments_on_service_id"
  end

  create_table "nutritionists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "latitude"
    t.string "location"
    t.float "longitude"
    t.string "name"
    t.bigint "nutritionist_id", null: false
    t.decimal "price"
    t.datetime "updated_at", null: false
    t.index ["nutritionist_id"], name: "index_services_on_nutritionist_id"
  end

  add_foreign_key "appointments", "services"
  add_foreign_key "services", "nutritionists"
end
