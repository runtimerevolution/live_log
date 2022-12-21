# frozen_string_literal: true

require 'live_log/version'
require 'live_log/engine'
require 'live_log/configuration'
require 'live_log/logger'

module LiveLog
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
