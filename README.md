# README

WeatherSearch is a simple Rails app that allows a user to search for a location by zipcode and get the current weather and ongoing forecast.

Run `bin/rails s` to start the server and navigate to http://localhost:3000 to search.

## Configuration

You will need a Google Maps Platform API Key. Information can be found at https://developers.google.com/maps/documentation/geocoding/get-api-key under 'Creating API Keys.'

Once you have your API key, set up your local environment by copying the .env.example file to .env and adding your API key to the GOOGLE_MAPS_API_KEY variable.

In production, add GOOGLE_MAPS_API_KEY to your environment variables.

## Database creation & initialization

`bin/rails db:setup`

## How to run the test suite

`bin/rails spec`

## Caching

WeatherSearch/Forecast caching is done through the database. It is set to expire after 30 minutes. 

The request to check the location is not yet cached due to development time restraints. Future development should include a cache for the location lookup with a mapping to zipcode.
