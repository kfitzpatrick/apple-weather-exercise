# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'WeatherSearches', type: :system do
  let(:mock_location_search_result) do
    { address_components: [{ long_name: 'Infinite Loop 1', short_name: 'Infinite Loop 1', types: ['premise'] },
                           { long_name: '1',
                             short_name: '1', types: ['street_number'] },
                           { long_name: 'Infinite Loop', short_name: 'Infinite Loop',
                             types: ['route'] },
                           { long_name: 'Cupertino', short_name: 'Cupertino',
                             types: %w[locality political] },
                           { long_name: 'Santa Clara County', short_name: 'Santa Clara County',
                             types: %w[administrative_area_level_2 political] },
                           { long_name: 'California', short_name: 'CA',
                             types: %w[administrative_area_level_1 political] },
                           { long_name: 'United States', short_name: 'US',
                             types: %w[country political] },
                           { long_name: '95014',
                             short_name: '95014', types: ['postal_code'] },
                           { long_name: '2083',
                             short_name: '2083', types: ['postal_code_suffix'] }],
      formatted_address: 'Infinite Loop 1, 1 Infinite Loop, Cupertino, CA 95014, USA',
      geometry: { bounds: { northeast: { lat: 37.3321786, lng: -122.0297996 }, southwest: { lat: 37.3312158, lng: -122.0305776 } },
                  location: { lat: 37.3318598,
                              lng: -122.0302485 },
                  location_type: 'ROOFTOP',
                  viewport: {
                    northeast: { lat: 37.3330203302915,
                                 lng: -122.0289424197085 }, southwest: { lat: 37.3303223697085, lng: -122.0316403802915 }
                  } },
      place_id: 'ChIJAf9D3La1j4ARuwKZtGjgMXw',
      types: ['premise'] }
  end

  let(:weather_search_result) do
    <<~JSON
            {
              "properties": {
                "updated": "2023-07-05T08:28:36+00:00",
                "units": "us",
                "forecastGenerator": "BaselineForecastGenerator",
                "generatedAt": "2023-07-05T14:32:46+00:00",
                "updateTime": "2023-07-05T08:28:36+00:00",
                "validTimes": "2023-07-05T02:00:00+00:00/P7DT2H",
                "elevation": {
                  "unitCode": "wmoUnit:m",
                  "value": 74.066400000000002
                },
                "periods": [
                  {
                    "number": 1,
                    "name": "Today",
                    "startTime": "2023-07-05T07:00:00-07:00",
                    "endTime": "2023-07-05T18:00:00-07:00",
                    "isDaytime": true,
                    "temperature": 79,
                    "temperatureUnit": "F",
                    "temperatureTrend": "falling",
                    "probabilityOfPrecipitation": {
                      "unitCode": "wmoUnit:percent",
                      "value": null
                    },
                    "dewpoint": {
                      "unitCode": "wmoUnit:degC",
                      "value": 14.444444444444445
                    },
                    "relativeHumidity": {
                      "unitCode": "wmoUnit:percent",
                      "value": 83
                    },
                    "windSpeed": "3 to 12 mph",
                    "windDirection": "NNE",
                    "icon": "https://api.weather.gov/icons/land/day/few?size=medium",
                    "shortForecast": "Sunny",
                    "detailedForecast": "Sunny. High near 79, with temperatures falling to around 77 in the afternoon. North northeast wind 3 to 12 mph."
                  },
                  {
                    "number": 2,
                    "name": "Tomorrow",
                    "startTime": "2023-07-05T07:00:00-07:00",
                    "endTime": "2023-07-05T18:00:00-07:00",
                    "isDaytime": true,
                    "temperature": 79,
                    "temperatureUnit": "F",
                    "temperatureTrend": "falling",
                    "probabilityOfPrecipitation": {
                      "unitCode": "wmoUnit:percent",
                      "value": null
                    },
                    "dewpoint": {
                      "unitCode": "wmoUnit:degC",
                      "value": 14.444444444444445
                    },
                    "relativeHumidity": {
                      "unitCode": "wmoUnit:percent",
                      "value": 83
                    },
                    "windSpeed": "3 to 12 mph",
                    "windDirection": "NNE",
                    "icon": "https://api.weather.gov/icons/land/day/few?size=medium",
                    "shortForecast": "Sunny",
                    "detailedForecast": "Sunny. High near 79, with temperatures falling to around 77 in the afternoon. North northeast wind 3 to 12 mph."
                  }
                ]
              }
      }

    JSON
  end

  before do
    driven_by(:rack_test)
    google_maps_client = double('GoogleMapsService::Client',
                                geocode: mock_location_search_result)
    allow(GoogleMapsService::Client).to receive(:new).and_return(google_maps_client)

    allow(Faraday).to receive(:new).and_return(double('Faraday connection',
                                                      get: double('Faraday::Response', body: weather_search_result)))
  end

  describe 'Doing a Weather Forecast Search' do
    it 'shows the weather forecast for the given location' do
      visit '/'
      fill_in 'Search term', with: '1 Infinite Loop, Cupertino, CA 95014'
      click_on 'Search'
      expect(page).to have_text('Found Infinite Loop')
      expect(page).to have_text('Today')
      expect(page).to have_text('Tomorrow')
    end

    it 'shows an error if the search term is empty' do
      visit '/weather_searches/new'
      fill_in 'Search term', with: ''
      click_on 'Search'
      expect(page).to have_text('Search term can\'t be blank')
    end

    describe 'with a bad address' do
      let(:mock_location_search_result) { nil }

      it 'it shows an error message' do
        visit '/weather_searches/new'
        fill_in 'Search term', with: 'bad address'
        click_on 'Search'
        expect(page).to have_text('No results found for address: bad address')
      end
    end

    it 'shows an error if no forecasts were found'
  end
end
