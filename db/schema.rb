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

ActiveRecord::Schema[7.1].define(version: 2024_07_31_020033) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employees", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name"
    t.decimal "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_employees_on_organization_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "payroll_period_id", null: false
    t.decimal "total_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_invoices_on_employee_id"
    t.index ["payroll_period_id"], name: "index_invoices_on_payroll_period_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payroll_periods", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "period_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_payroll_periods_on_organization_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.date "date"
    t.string "session_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_sessions_on_employee_id"
  end

  add_foreign_key "employees", "organizations"
  add_foreign_key "invoices", "employees"
  add_foreign_key "invoices", "payroll_periods"
  add_foreign_key "payroll_periods", "organizations"
  add_foreign_key "sessions", "employees"
end
