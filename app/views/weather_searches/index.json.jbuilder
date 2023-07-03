# frozen_string_literal: true

json.array! @weather_searches, partial: 'weather_searches/weather_search', as: :weather_search
