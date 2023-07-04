# Purpose: Forecast model. This model is used to store the weather forecast data
# for a given location during a given time period
class Forecast < ApplicationRecord
  belongs_to :weather_search

  # Generate Forecast models from WeatherClient::ForecastResult objects
  # @param [Array[WeatherClient::ForecastResult]] search_results from WeatherClient
  # @return [Array[Forecast]] An array of Forecast models
  def self.from_search_results(search_results)
    search_results.map do |result|
      Forecast.new(name: result.name,
                   wind_speed: result.wind_speed,
                   temperature: result.temperature,
                   temperature_unit: result.temperature_unit,
                   icon: result.icon,
                   short_forecast: result.short_forecast,
                   detailed_forecast: result.detailed_forecast,
                   is_day_time: result.is_day_time,
                   start_time: result.start_time,
                   end_time: result.end_time)
    end
  end
end
