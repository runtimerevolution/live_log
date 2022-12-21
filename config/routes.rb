# frozen_string_literal: true

LiveLog::Engine.routes.draw do
  scope :rrtools do
    scope path: 'live-log' do
      root 'logger#index'
      get '/redis-data', to: 'logger#redis_data'
    end
  end
end
