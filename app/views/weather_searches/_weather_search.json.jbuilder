# frozen_string_literal: true

json.extract! weather_search, :id, :created_at, :updated_at
json.url weather_search_url(weather_search, format: :json)
