# frozen_string_literal: true

require 'redis'

module LiveLog
  # This class will initialize the configuration
  class Configuration
    class Boolean; end
    def self.attr_checker(*attributes) 
      attributes.each do |attribute|
        name, type = attribute
        define_method(name) do
          instance_variable_get("@#{name}")
        end

        define_method("#{name}=") do |argument|
          if type == Boolean
            raise "#{name.to_s.capitalize} should be of type Boolean" unless argument.instance_of? TrueClass
          else
            raise "#{name.to_s.capitalize} should be of type #{type.to_s}" unless argument.instance_of? type
          end
          instance_variable_set("@#{name}", argument)
        end
      end
    end

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
