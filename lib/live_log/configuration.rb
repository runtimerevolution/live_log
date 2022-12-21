# frozen_string_literal: true

module LiveLog
  # This class will initialize the configuration
  class Configuration
    attr_accessor :channel, :persist, :all_exceptions

    def initialize
      @channel = 'live_log_channel'
      @persist = false
      @all_exceptions = false
    end
  end
end
