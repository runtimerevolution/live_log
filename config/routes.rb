# frozen_string_literal: true

LiveLog::Engine.routes.draw do
  root 'logger#index'
  get '/redis-data', to: 'logger#redis_data'
  post '/tracer_log_level', to: 'logger#tracer_log_level'
  post '/tracer_active', to: 'logger#tracer_active'
  post '/tracer_files', to: 'logger#tracer_files'
  post '/remove_file', to: 'logger#remove_file'
end
