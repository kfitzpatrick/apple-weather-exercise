# frozen_string_literal: true

# Controller for WeatherSearches
class WeatherSearchesController < ApplicationController
  before_action :set_weather_search, only: %i[show]

  def index
    @weather_searches = WeatherSearch.all
  end

  # GET /weather_searches/1 or /weather_searches/1.json
  def show; end

  # GET /weather_searches/new
  def new
    @weather_search = WeatherSearch.new
  end

  # POST /weather_searches or /weather_searches.json
  def create
    @weather_search = WeatherSearch.new(weather_search_params)
    @weather_search.search_location_data

    if (existing_search = WeatherSearch.where('zipcode = ? AND updated_at > ?', @weather_search.zipcode,
                                              30.minutes.ago).first)
      @weather_search = existing_search
    end

    respond_to do |format|
      if existing_search || @weather_search.save
        notice_message = existing_search ? "Using cached results from #{existing_search.updated_at}" : 'Found weather for location'
        format.html do
          redirect_to weather_search_url(@weather_search), notice: notice_message
        end
        format.json { render :show, status: :created, location: @weather_search }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @weather_search.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_weather_search
    @weather_search = WeatherSearch.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def weather_search_params
    params.require(:weather_search).permit(:search_term)
  end
end
