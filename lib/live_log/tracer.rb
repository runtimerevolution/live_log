# frozen_string_literal: true

require 'live_log/logger'
require 'live_log/binding'

module LiveLog
  # Tracer class
  class Tracer
    attr_accessor :formatter, :level, :logger

    def initialize(logger)
      @logger = logger
    end

    %i[debug info warn error fatal unknown].each do |level|
      define_method level do |*args, &block|
        if logger
          previous = Binding.new(binding.callers.second)
          Logger.info([previous.class, previous.method]) if ['PageController'].include? previous.class
          logger&.send(level, *args, &block)
        end
      end

      define_method "#{level}?" do
        true
      end
    end
  end
end

