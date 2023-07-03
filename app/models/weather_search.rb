# frozen_string_literal: true

# TODO: load if same zip and less than 30 minutes old

# Represents the search the user is making
class WeatherSearch < ApplicationRecord
  validates_presence_of :search_term
  before_save :get_location_data

  # Searches for a matching location using the search_term
  # @return [Object]
  def get_location_data
    response = LocationSearch.search(search_term)
    first_response = response.first
    self.latitude =  first_response[:geometry][:location][:lat]
    self.longitude = first_response[:geometry][:location][:lng]
    self.address =   first_response[:formatted_address]
    self.zipcode =   first_response[:address_components].find { |ac| ac[:types].include?('postal_code') }[:long_name]
  end
end
