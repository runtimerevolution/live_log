# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Loggers', type: :request do
  describe 'GET /index' do
    it 'renders the index template' do
      get '/live_log'
      expect(response.body).to include('live_log_id')
    end
  end

  describe 'GET /redis_data' do
    before(:all) do
      LiveLog.configuration.persist = true
      LiveLog.configuration.redis = Redis.new
    end
    before(:each) do
      LiveLog.configuration.redis.flushAll
    end

    it 'returns empty array' do
      get '/live_log/redis-data'
      expect(JSON.parse(response.body)).to eq([])
    end

    it 'returns an array with object' do
      LiveLog::Logger.info('This is my info message')

      get '/live_log/redis-data'
      json_response = JSON.parse(response.body)
      expect(json_response[0]['type']).to eq('info')
      expect(json_response[0]['message']).to eq('"This is my info message"')
    end

    it 'returns only the persist limit' do
      LiveLog.configuration.persist_limit = 5

      (0..7).each do |_|
        LiveLog::Logger.error('This is my error')
        Timecop.travel(1.second)
      end

      get '/live_log/redis-data'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(5)
    end

    it 'returns only the persist time limit' do
      LiveLog.configuration.persist_time = 5

      LiveLog::Logger.error('This is my error')
      Timecop.travel(1.minute)
      LiveLog::Logger.error('This is my error 2')

      Timecop.travel(4.minute)

      get '/live_log/redis-data'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response[0]['type']).to eq('error')
      expect(json_response[0]['message']).to eq('"This is my error 2"')
    end
  end
end
