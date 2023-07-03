# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'WeatherSearches', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'Doing a Weather Forecast Search' do
    it 'shows the weather forecast for the given location' do
      visit '/weather_searches/new'
      fill_in 'Search term', with: '1 Infinite Loop, Cupertino, CA 95014'
      click_on 'Search'

      expect(page).to have_text('Found 1 Infinite Loop, Cupertino, CA 95014')
      expect(page).to have_text('Today')
      expect(page).to have_text('Tomorrow')
    end

    it 'shows an error if the search term is empty' do
      visit '/weather_searches/new'
      fill_in 'Search term', with: ''
      click_on 'Search'
      expect(page).to have_text('Search term can\'t be blank')
    end

    it 'shows an error if Google Maps could not find a matching address'
    it 'shows an error if no forecasts were found'
  end
end
