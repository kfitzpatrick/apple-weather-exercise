# frozen_string_literal: true

require 'rails_helper'

require 'location_search'
RSpec.describe WeatherSearch, type: :model do
  describe 'lifecycle' do
    describe 'before create' do
      describe 'searching for a matching address' do
        context 'on success' do
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
          it 'populates the Location data in the database and returns' do
            expect(LocationSearch).to receive(:search).and_return(mock_location_search_result)
            weather_search = WeatherSearch.new(search_term: 'foo')
            expect(weather_search.save).to be_truthy
            expect(weather_search.address).to eq('Infinite Loop 1, 1 Infinite Loop, Cupertino, CA 95014, USA')
            expect(weather_search.latitude).to eq('37.3318598')
            expect(weather_search.longitude).to eq('-122.0302485')
            expect(weather_search.zipcode).to eq('95014')
          end
        end

        context 'on failure' do
          it 'does something appropriate'
        end
      end

      it 'searches for the forecast'
    end
  end
end
