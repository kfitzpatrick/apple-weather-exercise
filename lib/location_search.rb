# frozen_string_literal: true

require 'google_maps_service'
require 'location_search/location'

# Service class for doing address searches
class LocationSearch

  def self.search(address)
    gmapclient = GoogleMapsService::Client.new(key: ENV['GOOGLE_MAPS_API_KEY'])
    gmapclient_geocode = gmapclient.geocode(address)
    LocationSearch::Location.new gmapclient_geocode.first
  end

end
