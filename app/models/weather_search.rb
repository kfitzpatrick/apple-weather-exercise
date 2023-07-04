# frozen_string_literal: true
require 'weather_client'
# TODO: load if same zip and less than 30 minutes old

# Represents the search the user is making
class WeatherSearch < ApplicationRecord
  validates_presence_of :search_term
  before_save :search_location_data
  before_save :search_forecast_data

  has_many :forecasts, dependent: :destroy

  # Searches for a matching location using the search_term
  # @return [Object]
  def search_location_data
    location = LocationSearch.search(search_term)
    self.latitude =  location.latitude
    self.longitude = location.longitude
    self.address =   location.formatted_address
    self.zipcode =   location.zipcode
  end

  def search_forecast_data
    forecast_results = WeatherClient.forecast(lat: latitude, lng: longitude)
    self.forecasts = Forecast.from_search_results(forecast_results)
  end
end
