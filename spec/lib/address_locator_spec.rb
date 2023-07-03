# frozen_string_literal: true

require 'spec_helper'
require 'address_locator'
require 'google_maps_service'

describe AddressLocator do
  let(:client) { AddressLocator.new('my key') }

  context 'with an address' do
    it 'can retrieve lat/long for a given address from Google Maps Services' do
      response_object = [{
        formatted_address: '1147 Hearst Ave, Berkeley, CA 94702, USA',
        geometry: { location: { lat: 1, lng: 0 } }
      }]
      client_double = double(:client, geocode: response_object)
      allow(GoogleMapsService::Client).to receive(:new).with(key: 'my key').and_return(client_double)
      expect(client.latlng('good address')).to eq({ lat: 1, lng: 0 })
    end

    it 'raises an error if the address is bogus' do
      allow(GoogleMapsService::Client).to receive(:new).with(key: 'my key').and_return(double(:client, geocode: []))
      expect { client.latlng('bad address') }.to raise_error(AddressLocator::NoAddressFound)
    end
  end

  context 'without an address' do
    it 'raises an error if the address is missing' do
      expect { client.latlng }.to raise_error(ArgumentError, /wrong number of arguments/)
    end
  end
end
