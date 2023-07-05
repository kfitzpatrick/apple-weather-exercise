# frozen_string_literal: true

class LocationSearch
  # Service object to wrap the Google Maps API location results
  class Location
    attr_reader :latitude, :longitude, :formatted_address, :zipcode

    def initialize(gmaps_response)
      @latitude = gmaps_response[:geometry][:location][:lat]
      @longitude = gmaps_response[:geometry][:location][:lng]
      @formatted_address = gmaps_response[:formatted_address]
      zipcode_attribute =  gmaps_response[:address_components].find { |ac| ac[:types].include?('postal_code') }
      @zipcode = zipcode_attribute[:long_name] if zipcode_attribute
    end
  end
end
