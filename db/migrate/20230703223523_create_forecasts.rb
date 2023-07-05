# frozen_string_literal: true

# Moving forecasts to their own table
class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.string :short_forecast
      t.string :detailed_forecast
      t.string :temperature
      t.string :temperature_unit
      t.string :wind_speed
      t.string :wind_direction
      t.string :wind_direction_unit
      t.string :icon
      t.references :weather_search, null: false, foreign_key: true
      t.timestamps
    end
  end
end
