require 'rails_helper'

describe Forecast do
  describe ".from_search_results" do
    it 'creates a Forecast for each WeatherClient::ForecastResult' do
      results = [FactoryBot.build(:forecast_result, name: 'Today', temperature: 76),
                 FactoryBot.build(:forecast_result, name: 'Tomorrow', temperature: 75)]
      forecasts = Forecast.from_search_results(results)
      expect(forecasts.count).to eq(2)
      expect(forecasts.first).to be_an_instance_of(Forecast)
      expect(forecasts.map(&:name)).to include('Today', 'Tomorrow')
    end
  end
end

