# frozen_string_literal: true

require 'google_maps_service'
require 'location_search/location'

class LocationSearch
  class NoResultsFoundForAddressError < StandardError; end
end

# Service class for doing address searches
class LocationSearch
  # Searches for a location based on an address
  # @param [String] address Address to search for
  # @param [String] key Google Maps API key
  # @return [LocationSearch::Location]
  def self.search(address, key)
    gmapclient = GoogleMapsService::Client.new(key:)
    result = gmapclient.geocode(address)
    raise NoResultsFoundForAddressError, "No results found for address: #{address}" if result.nil? || result.empty?

    location = result.instance_of?(Array) ? result.first : result
    LocationSearch::Location.new location
  end
end
