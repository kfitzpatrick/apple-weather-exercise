# frozen_string_literal: true
class WeatherClient
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

    def self.from_json(json_object)
      new.tap do |f|
        f.name = json_object["name"]
        f.start_time = json_object["startTime"]
        f.end_time = json_object["endTime"]
        f.is_day_time = json_object["isDayTime"]
        f.temperature = json_object["temperature"]
        f.temperature_unit = json_object["temperatureUnit"]
        f.wind_speed = json_object["windSpeed"]
        f.wind_direction = json_object["windDirection"]
        f.icon = json_object["icon"]
        f.short_forecast = json_object["shortForcast"]
        f.detailed_forecast = json_object["detailedForecast"]
      end
    end
  end
end
