# frozen_string_literal: true

require 'redis'

module LiveLog
  # This class will initialize the configuration
  class Configuration
    attr_accessor :channel, :persist, :all_exceptions, :persist_limit, :persist_time
    attr_reader :redis

    def initialize
      @channel = 'live_log_channel'
      @persist = false
      @persist_limit = 5
      @persist_time = 1
      @all_exceptions = false
      @redis = Redis.new
    end

    def redis=(redis)
      @redis = Redis.new(redis)
    end
  end
end
