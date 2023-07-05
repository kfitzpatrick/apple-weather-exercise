# frozen_string_literal: true

Rails.application.routes.draw do
  resources :weather_searches
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "weather_searches#new"
end
