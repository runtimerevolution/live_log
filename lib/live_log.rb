# frozen_string_literal: true

require 'live_log/version'
require 'live_log/engine'
require 'live_log/configuration'
require 'live_log/logger'
require 'live_log/web'

module LiveLog
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def file_version(version = Rails.version.to_i)
      file_timestamp = '2CgHl9Qa1IaWqOB7zwJMBF910n11y7epmoF2rBbgiR7q4a9DvYcCA2zFlB2bDmLS'
      if version < 7
        "versions/up_to_6_v1_#{file_timestamp}.js"
      else
        "versions/7_up_v1_#{file_timestamp}.js"
      end
    end
  end
end
