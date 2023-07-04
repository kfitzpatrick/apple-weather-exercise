# frozen_string_literal: true

# TODO: load if same zip and less than 30 minutes old

# Represents the search the user is making
class WeatherSearch < ApplicationRecord
  validates_presence_of :search_term
  before_save :get_location_data
  before_save :get_forecast_data

  has_many :forecasts, dependent: :destroy

  # Searches for a matching location using the search_term
  # @return [Object]
  def get_location_data
    location = LocationSearch.search(search_term)
    self.latitude =  location.latitude
    self.longitude = location.longitude
    self.address =   location.formatted_address
    self.zipcode =   location.zipcode
  end

  def get_forecast_data
    periods = WeatherClient.forecast_at(lat: latitude, lng: longitude)
    self.forecasts = periods.map(&:to_json)
  end
end
