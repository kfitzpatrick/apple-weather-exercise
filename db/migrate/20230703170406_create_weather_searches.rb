# frozen_string_literal: true

# WeatherSearches are the main model of the whole application
class CreateWeatherSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :weather_searches do |t|
      t.string :search_term, required: true
      t.string :address
      t.string :latitude
      t.string :longitude
      t.string :zipcode
      t.json :forecasts
      t.timestamps
    end
  end
end
