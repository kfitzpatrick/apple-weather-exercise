# frozen_string_literal: true

require 'google_maps_service'
require 'location_search/location'

# Service class for doing address searches
class LocationSearch
  # Searches for a location based on an address
  # @param [String] address Address to search for
  # @param [String] key Google Maps API key
  # @return [LocationSearch::Location]
  def self.search(address, key)
    gmapclient = GoogleMapsService::Client.new(key:)
    result = gmapclient.geocode(address)
    location = result.instance_of?(Array) ? result.first : result
    LocationSearch::Location.new location
  end
end
