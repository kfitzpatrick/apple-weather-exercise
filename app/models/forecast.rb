# Purpose: Forecast model. This model is used to store the weather forecast data
# for a given location during a given time period
class Forecast < ApplicationRecord
  belongs_to :weather_search
end