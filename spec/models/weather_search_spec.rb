# frozen_string_literal: true

require 'rails_helper'

require 'location_search'
RSpec.describe WeatherSearch, type: :model do
  describe 'lifecycle' do
    describe 'before create' do
      describe 'searching for a matching address' do
        context 'on success' do
          let(:location) { double(LocationSearch::Location, latitude: '3', longitude: '-1', formatted_address: 'foo',
                                                            zipcode: '95014') }

          before do
            expect(LocationSearch).to receive(:search).and_return(location)
          end

          it 'populates the Location data in the database and returns' do
            expect(WeatherClient).to receive(:forecast).and_return([])
            weather_search = WeatherSearch.new(search_term: 'foo')
            expect(weather_search.save).to be_truthy
            weather_search.reload
            expect(weather_search.address).to eq('foo')
            expect(weather_search.latitude).to eq('3')
            expect(weather_search.longitude).to eq('-1')
            expect(weather_search.zipcode).to eq('95014')
          end

          it 'populates the Forecast data in the database and returns' do
            wc_forecasts = [
              double(WeatherClient::ForecastResult, name: 'Today', temperature: 76),
              double(WeatherClient::ForecastResult, name: 'Tomorrow', temperature: 75),
            ]
            expect(WeatherClient).to receive(:forecast).and_return(wc_forecasts)
            weather_search = WeatherSearch.new(search_term: 'foo')
            expect(weather_search.save).to be_truthy
            weather_search.reload
            expect(weather_search.forecasts.count).to eq(2)
            expect(weather_search.forecasts).to contain_exactly(
                                                  an_object_having_attributes(name: 'Today', temperature: 76),
                                                  an_object_having_attributes(name: 'Tomorrow', temperature: 75),
                                                )
          end
         
          context 'on failure' do
            it 'does something appropriate'
          end
        end
      end
    end
  end
end


