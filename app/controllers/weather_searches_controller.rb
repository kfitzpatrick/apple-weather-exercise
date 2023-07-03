# frozen_string_literal: true

class WeatherSearchesController < ApplicationController
  before_action :set_weather_search, only: %i[show edit update destroy]

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

    respond_to do |format|
      if @weather_search.save
        format.html do
          redirect_to weather_search_url(@weather_search), notice: 'Weather search was successfully created.'
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
