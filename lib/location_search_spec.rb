# frozen_string_literal: true

require 'google_maps_service'
require 'location_search'
require 'location_search/location'

describe LocationSearch do
  describe '.search' do
    it 'calls the Google Maps API to get the data of a location' do
      gmaps_response = [{
        geometry: {
          location: { lat: 1, lng: 0 }
        }
      }]
      client_double = double('GoogleMapsService::Client', geocode: gmaps_response)
      allow(LocationSearch::Location).to receive(:new).with(gmaps_response.first).and_return(double(
                                                                                               'LocationSearch::Location', latitude: 1
                                                                                             ))
      expect(GoogleMapsService::Client).to receive(:new).with(key: ENV['GOOGLE_MAPS_API_KEY']).and_return(client_double)
      expect(client_double).to receive(:geocode).with('foo')

      results = LocationSearch.search('foo')
      expect(results.latitude).to eq(1)
    end
  end

  describe LocationSearch::Location do
    it "is a PORO that wraps the Google Maps API's response" do
      gmaps_response = {
        geometry: {
          location: { lat: 1, lng: 0 }
        },
        formatted_address: 'foo',
        address_components: [
          { long_name: 'bar', types: ['postal_code'] }
        ]
      }
      location = LocationSearch::Location.new(gmaps_response)
      expect(location.latitude).to eq(1)
      expect(location.longitude).to eq(0)
      expect(location.formatted_address).to eq('foo')
      expect(location.zipcode).to eq('bar')
    end
  end
end
