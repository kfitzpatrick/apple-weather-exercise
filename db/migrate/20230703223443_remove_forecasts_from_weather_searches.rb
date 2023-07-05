# frozen_string_literal: true

class RemoveForecastsFromWeatherSearches < ActiveRecord::Migration[7.0]
  def change
    remove_column :weather_searches, :forecasts, :json
  end
end
