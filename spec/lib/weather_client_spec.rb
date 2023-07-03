# frozen_string_literal: true

require 'spec_helper'
require 'weather_client'

describe WeatherClient do

  context 'given lat/lng coordinates' do
    it 'returns an array of ongoing forecast periods from the National Weather Service' do
      conn = double(:faraday_connection)
      allow(Faraday).to receive(:new).and_return(conn)
      expect(conn).to receive(:get).with('https://api.weather.gov/points/1,0').and_return(double(:response, body: <<-BODY))
          { "properties": {
              "forecast": "http://url-to-the-given-points-forecast"
          } }
      BODY

      expect(conn).to receive(:get).with('http://url-to-the-given-points-forecast').and_return(double(:forecast_response, body: <<-BODY))
        {
          "properties": {
            "periods": [{
                         "name": "Today",
                         "temperature": 76
                       }]
          } 
        }
      BODY

      result = WeatherClient.forecast(lat: 1, lng: 0)
      expect(result[0].name).to eq('Today')
      expect(result[0].temperature).to eq(76)
    end
  end
end
