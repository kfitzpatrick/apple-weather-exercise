# frozen_string_literal: true

require 'spec_helper'
require 'location_search'
require 'google_maps_service'

describe LocationSearch do

  let(:mock_location_search_result) do
    [{
      address_components: [{ long_name: 'Infinite Loop 1', short_name: 'Infinite Loop 1', types: ['premise'] },
                           { long_name: '95014', short_name: '95014', types: ['postal_code'] }],
      formatted_address: 'Infinite Loop 1, 1 Infinite Loop, Cupertino, CA 95014, USA',
      geometry: {
        location: { lat: 37.3318598, lng: -122.0302485 }
      },
      place_id: 'ChIJAf9D3La1j4ARuwKZtGjgMXw',
      types: ['premise']
    }]
  end
  before do
    allow(ENV).to receive(:[]).with('GOOGLE_MAPS_API_KEY').and_return('key')
  end
  it 'searches google maps service for a location based on address' do
    client = double('GoogleMapsService::Client',
                    geocode: mock_location_search_result)
    allow(GoogleMapsService::Client).to receive(:new).with(key: 'key').and_return(client)
    result = LocationSearch.search('foo')
    expect(result).to be_an_instance_of(LocationSearch::Location)
    expect(result.latitude).to eq(37.3318598)
  end
end
