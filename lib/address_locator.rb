# frozen_string_literal: true

class AddressLocator
  class NoAddressFound < StandardError
  end

  # @param [String] google_services_key API Key you set up when establishing your Google Maps Services account
  def initialize(google_services_key)
    @api_key = google_services_key
  end

  def latlng(address_string)
    gmap_client = GoogleMapsService::Client.new(key: @api_key)
    results = gmap_client.geocode(address_string)
    raise NoAddressFound if results === []

    location = results.first.dig(:geometry, :location)
    {
      lat: location[:lat],
      lng: location[:lng]
    }
  end
end
