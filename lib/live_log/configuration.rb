# frozen_string_literal: true

require 'redis'
require 'live_log/macro'

module LiveLog
  # This class will initialize the configuration
  class Configuration < Macro
    attr_reader :redis, :rrtools_grouped_gems

    attr_checker [:channel, String],
                 [:persist, Boolean],
                 [:all_exceptions, Boolean],
                 [:persist_limit, Integer],
                 [:persist_time, Integer]

    def initialize
      super
      @channel = 'live_log_channel'
      @persist = false
      @persist_limit = 5
      @persist_time = 1
      @all_exceptions = false
      @redis = Redis.new
      @rrtools_grouped_gems = Rails.application.routes.routes.select { |prop| prop.defaults[:group] == 'RRTools' }
                                   .collect do |route|
        {
          name: route.name,
          path: route.path.build_formatter.instance_variable_get('@parts').join
        }
      end || []
    end

    def redis=(redis)
      @redis = redis.instance_of?(Redis) ? redis : Redis.new(redis)
    end
  end
end
