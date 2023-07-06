# frozen_string_literal: true

require 'rails_helper'

require 'location_search'
RSpec.describe WeatherSearch, type: :model do
  describe 'lifecycle' do
    describe 'validations' do
      context 'when location search fails' do
        it 'shows a validation error' do
          expect(LocationSearch).to receive(:search).and_raise(LocationSearch::NoResultsFoundForAddressError,
                                                               'uh oh bad address')
          weather_search = WeatherSearch.new(search_term: 'foo')
          results = weather_search.save
          expect(results).to eq(false)
          expect(weather_search.errors.messages[:search_term]).to eq(['uh oh bad address'])
        end
      end
    end

    describe 'before create' do
      describe 'searching for a matching address' do
        context 'on success' do
          let(:location) do
            double(LocationSearch::Location, latitude: '3', longitude: '-1', formatted_address: 'foo',
                                             zipcode: '95014')
          end

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
              FactoryBot.build(:forecast_result, name: 'Today', temperature: 76),
              FactoryBot.build(:forecast_result, name: 'Tomorrow', temperature: 75)
            ]
            expect(WeatherClient).to receive(:forecast).and_return(wc_forecasts)
            weather_search = WeatherSearch.new(search_term: 'foo')
            expect(weather_search.save).to be_truthy
            weather_search.reload
            expect(weather_search.forecasts.count).to eq(2)
            expect(weather_search.forecasts.map(&:name)).to contain_exactly('Today', 'Tomorrow')
          end

          context 'on failure' do
            it 'does something appropriate'
          end
        end
      end
    end
  end
end
