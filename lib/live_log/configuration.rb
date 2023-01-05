# frozen_string_literal: true

require 'redis'
require 'live_log/macro'

module LiveLog
  # This class will initialize the configuration
  class Configuration < Macro
    attr_reader :redis

    attr_checker [:channel, String],
                 [:persist, Boolean],
                 [:all_exceptions, Boolean],
                 [:persist_limit, Integer],
                 [:persist_time, Integer]

    def initialize
      @channel = 'live_log_channel'
      @persist = false
      @persist_limit = 5
      @persist_time = 1
      @all_exceptions = false
      @redis = Redis.new
    end

    def redis=(redis)
      @redis = redis.instance_of?(Redis) ? redis : Redis.new(redis)
    end
  end
end
