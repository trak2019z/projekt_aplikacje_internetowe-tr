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

ActiveRecord::Schema.define(version: 2019_01_19_143306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 25
    t.string "last_name", limit: 50
    t.string "address"
    t.integer "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true
  end

  create_table "employees", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 20, null: false
    t.string "last_name", limit: 50, null: false
    t.integer "phone_number"
    t.string "desc", limit: 250
    t.boolean "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
  end

  create_table "employees_services", id: false, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "service_id"
    t.index ["employee_id", "service_id"], name: "index_employees_services_on_employee_id_and_service_id"
  end

  create_table "reservations", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "phone"
    t.text "email"
    t.text "date"
    t.text "time"
  end

  create_table "services", id: :serial, force: :cascade do |t|
    t.string "name", limit: 15
    t.text "description"
    t.integer "price"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services_visits", id: :serial, force: :cascade do |t|
    t.integer "client_id"
    t.integer "employee_id"
    t.integer "service_id"
    t.integer "visit_id"
    t.string "client_opinion_comment"
    t.integer "client_opinion_rating"
    t.datetime "client_opinion_added"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["client_id", "employee_id", "service_id", "visit_id"], name: "index_services_visits_on_c_id_and_e_id_and_s_id_and_vs_id"
  end

  create_table "visits", id: :serial, force: :cascade do |t|
    t.integer "client_id"
    t.integer "price"
    t.integer "discount"
    t.string "comments"
    t.boolean "status", default: false
    t.datetime "start_time"
    t.boolean "sms"
    t.boolean "email"
    t.datetime "sms_time"
    t.datetime "email_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_visits_on_client_id"
  end

end
