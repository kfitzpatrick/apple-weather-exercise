# frozen_string_literal: true

require 'faraday'
require 'faraday/follow_redirects'
require 'weather_client/forecast_result'

# WeatherClient uses the National Weather Service to retrieve weather forecasts
class WeatherClient
  attr_reader :conn

  def initialize
    @conn = Faraday.new do |faraday|
      faraday.response :follow_redirects # use Faraday::FollowRedirects::Middleware
      faraday.adapter Faraday.default_adapter
    end
  end

  # @return [Array[WeatherClient::ForecastResult]] An array of ForecastResult objects
  def forecast_at(lat:, lng:)
    point_data = get_point_data(lat, lng)
    forecast_url = point_data['properties']['forecast']
    response = conn.get(forecast_url)
    body = JSON.parse(response.body)
    props = body['properties']
    props['periods'].map { |p| ForecastResult.from_json(p) }
  end

  # Retrieve forecast for a given latitude and longitude from National Weather Service
  # @param [String|Number] lat Latitude of point to get forecast for
  # @param [String|Number] lng Longitude of point to get forecast for
  # @return [Array[WeatherClient::ForecastResult]] An array of Forecast objects
  def self.forecast(lat:, lng:)
    client = WeatherClient.new
    client.forecast_at(lat:, lng:)
  end

  private

  # Retrieve point data for a given latitude and longitude from National Weather Service
  # @param [Number] lat Latitude to get point data for
  # @param [Number] lng Longitude to get point data for
  # @return [Hash] Point data for the given latitude and longitude. i
  #                Result will have a 'properties' attribute with a
  #                'forecast' attribute which contains the url for the forecast
  def get_point_data(lat, lng)
    point_url = "https://api.weather.gov/points/#{lat},#{lng}"
    response = conn.get(point_url)
    JSON.parse(response.body)
  end
end
