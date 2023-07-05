# frozen_string_literal: true

require 'spec_helper'
require 'location_search'
require 'google_maps_service'

describe LocationSearch do
  let(:address) do
    {
      address_components: [{ long_name: 'Infinite Loop 1', short_name: 'Infinite Loop 1', types: ['premise'] },
                           { long_name: '95014', short_name: '95014', types: ['postal_code'] }],
      formatted_address: 'Infinite Loop 1, 1 Infinite Loop, Cupertino, CA 95014, USA',
      geometry: {
        location: { lat: 37.3318598, lng: -122.0302485 }
      },
      place_id: 'ChIJAf9D3La1j4ARuwKZtGjgMXw',
      types: ['premise']
    }
  end

  context "when google maps service doesn't return a result"

  context 'when google maps returns an array of possible results' do
    let(:mock_location_search_result) { [address] }

    it 'returns the first result' do
      client = double('GoogleMapsService::Client',
                      geocode: mock_location_search_result)
      allow(GoogleMapsService::Client).to receive(:new).with(key: 'key').and_return(client)
      result = LocationSearch.search('foo', 'key')
      expect(result).to be_an_instance_of(LocationSearch::Location)
      expect(result.latitude).to eq(37.3318598)
    end
  end

  context 'when google maps returns an one result' do
    let(:mock_location_search_result) { address }

    it 'returns the first result' do
      client = double('GoogleMapsService::Client',
                      geocode: mock_location_search_result)
      allow(GoogleMapsService::Client).to receive(:new).with(key: 'key').and_return(client)
      result = LocationSearch.search('foo', 'key')
      expect(result).to be_an_instance_of(LocationSearch::Location)
      expect(result.latitude).to eq(37.3318598)
    end

  end

  it 'can handle municipal level addresses' do
    # Note, there is no zip code
    mock_location_search_result = {
      address_components: [ ],
      formatted_address: 'Philadelphia, PA, USA',
      geometry: {
        location: { lat: 39.9525839, lng: -75.1652215 },
        location_type: 'APPROXIMATE'
      },
      place_id: 'ChIJ60u11Ni3xokRwVg-jNgU9Yk'
    }
    client = double('GoogleMapsService::Client',
                    geocode: mock_location_search_result)
    allow(GoogleMapsService::Client).to receive(:new).with(key: 'key').and_return(client)
    result = LocationSearch.search('foo', 'key')
    expect(result).to be_an_instance_of(LocationSearch::Location)
    expect(result.latitude).to eq(39.9525839)
    expect(result.zipcode).to be_nil
  end
end
