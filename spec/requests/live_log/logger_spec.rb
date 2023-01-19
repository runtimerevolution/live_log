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

  describe 'POST /tracer_active' do
    before(:each) do
      LiveLog::Tracer.is_active = false
    end

    it 'sets tracer as active' do
      post '/live_log/tracer_active', params: { active: true }

      expect(LiveLog::Tracer.is_active).to be(true)
    end

    it 'sets tracer as inactive' do
      LiveLog::Tracer.is_active = true

      post '/live_log/tracer_active', params: { active: false }

      expect(LiveLog::Tracer.is_active).to be(false)
    end

    it 'not sets tracer as active with random value' do
      post '/live_log/tracer_active', params: { active: 'random_value' }

      expect(LiveLog::Tracer.is_active).to be(false)
    end

    it 'not sets tracer as active with random key' do
      post '/live_log/tracer_active', params: { random_key: true }

      expect(LiveLog::Tracer.is_active).to be(false)
    end
  end

  describe 'POST /tracer_files' do
    path = '/some/path/to/file.rb'

    before(:each) do
      LiveLog::Tracer.is_active = true
      LiveLog::Tracer.files = []
    end

    it 'adds tracer file' do
      post '/live_log/tracer_files', params: { file: path }

      expect(LiveLog::Tracer.files).to eq([path])
    end

    it 'not adds tracer file inactive' do
      LiveLog::Tracer.is_active = false
      post '/live_log/tracer_files', params: { file: path }

      expect(LiveLog::Tracer.files).to eq([])
    end

    it 'not adds tracer file with other param' do
      post '/live_log/tracer_files', params: { random_key: path }

      expect(LiveLog::Tracer.files).to eq([])
    end
  end

  describe 'POST /remove_file' do
    path = '/some/path/to/file.rb'

    before(:each) do
      LiveLog::Tracer.is_active = true
      LiveLog::Tracer.files = [path]
    end

    it 'removes tracer file' do
      post '/live_log/remove_file', params: { id: 0 }

      expect(LiveLog::Tracer.files).to eq([])
      expect(response.body).to include('redirected')
    end

    it 'not removes tracer file inactive' do
      LiveLog::Tracer.is_active = false
      post '/live_log/remove_file', params: { id: 0 }

      expect(LiveLog::Tracer.files).to eq([path])
      expect(response.body).to eq('')
    end

    it 'not removes tracer file with other param' do
      post '/live_log/remove_file', params: { random_key: 0 }

      expect(LiveLog::Tracer.files).to eq([path])
      expect(response.body).to eq('')
    end

    it 'not adds tracer file with non index' do
      post '/live_log/remove_file', params: { id: 3 }

      expect(LiveLog::Tracer.files).to eq([path])
      expect(response.body).to include('redirected')
    end
  end
end
