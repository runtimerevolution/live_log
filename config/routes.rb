# frozen_string_literal: true

LiveLog::Engine.routes.draw do
  root 'logger#index'
  get '/redis-data', to: 'logger#redis_data'
end
