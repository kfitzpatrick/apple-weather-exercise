# frozen_string_literal: true

class WeatherClient
  # WeatherClient::Forecast is a PORO (Plain Old Ruby Object) that represents a single forecast
  # It is used to convert the JSON response from the National Weather Service into a Ruby object
  # that can be used in the application. It is not persisted to the database and is only used
  # in memory.
  class Forecast
    attr_accessor :name,
                  :start_time,
                  :end_time,
                  :is_day_time,
                  :temperature,
                  :temperature_unit,
                  :wind_speed,
                  :wind_direction,
                  :icon,
                  :short_forecast,
                  :detailed_forecast

    # Create a new Forecast object from a JSON object
    def self.from_json(json_object)
      new.tap do |f|
        f.name = json_object['name']
        f.start_time = json_object['startTime']
        f.end_time = json_object['endTime']
        f.is_day_time = json_object['isDayTime']
        f.temperature = json_object['temperature']
        f.temperature_unit = json_object['temperatureUnit']
        f.wind_speed = json_object['windSpeed']
        f.wind_direction = json_object['windDirection']
        f.icon = json_object['icon']
        f.short_forecast = json_object['shortForcast']
        f.detailed_forecast = json_object['detailedForecast']
      end
    end
  end
end
