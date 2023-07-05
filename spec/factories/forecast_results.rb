# frozen_string_literal: true

require 'weather_client/forecast_result'

FactoryBot.define do
  factory :forecast_result, class: WeatherClient::ForecastResult do
    name { 'foo' }
    wind_speed { '10' }
    temperature { '76' }
    temperature_unit { 'F' }
    icon { 'http://example.com/icon.png' }
    short_forecast { 'Short forecast' }
    detailed_forecast { 'Detailed forecast' }
    is_day_time { true }
    start_time { Time.now }
    end_time { Time.now + 1.day }
  end
end
