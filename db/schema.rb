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

ActiveRecord::Schema[7.0].define(version: 2023_07_04_174040) do
  create_table "forecasts", force: :cascade do |t|
    t.string "short_forecast"
    t.string "detailed_forecast"
    t.string "temperature"
    t.string "temperature_unit"
    t.string "wind_speed"
    t.string "wind_direction"
    t.string "wind_direction_unit"
    t.string "icon"
    t.integer "weather_search_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "is_day_time"
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["weather_search_id"], name: "index_forecasts_on_weather_search_id"
  end

  create_table "weather_searches", force: :cascade do |t|
    t.string "search_term"
    t.string "address"
    t.string "latitude"
    t.string "longitude"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "forecasts", "weather_searches"
end
