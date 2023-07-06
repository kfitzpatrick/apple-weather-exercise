# frozen_string_literal: true

require 'weather_client'
require 'location_search'

# Represents the search the user is making
class WeatherSearch < ApplicationRecord
  before_validation :search_location_data
  before_save :search_forecast_data

  validates_presence_of :search_term
  validates_presence_of :address

  has_many :forecasts, dependent: :destroy

  # Searches for a matching location using the search_term
  # @return [Object]
  def search_location_data
    location = LocationSearch.search(search_term, Rails.configuration.x.google_maps_api_key)
    self.latitude =  location.latitude
    self.longitude = location.longitude
    self.address =   location.formatted_address
    self.zipcode =   location.zipcode
  rescue LocationSearch::NoResultsFoundForAddressError => e
    errors.add(:search_term, e.message)
  end

  def search_forecast_data
    return if !latitude || !longitude

    forecast_results = WeatherClient.forecast(lat: latitude, lng: longitude)
    self.forecasts = Forecast.from_search_results(forecast_results)
  rescue WeatherClient::PointDataUnavailableError => e
    errors.add(:forecasts, e.message)
  end
end
