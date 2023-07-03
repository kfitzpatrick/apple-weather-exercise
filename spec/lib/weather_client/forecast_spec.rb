# frozen_string_literal: true

require 'weather_client/forecast'

describe WeatherClient::Forecast do
  it 'assigns values from the json object (with string keys)' do
    json = { 'name' => 'foo', 'windSpeed' => '10' }
    forecast = WeatherClient::Forecast.from_json(json)
    expect(forecast.name).to eq('foo')
    expect(forecast.wind_speed).to eq('10')
  end
end
