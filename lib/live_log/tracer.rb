# frozen_string_literal: true
require 'live_log/logger'
require 'binding_of_caller'

module LiveLog
  class Tracer
    attr_accessor :formatter, :level, :logger

    def initialize(logger)
      @logger = logger
    end

    %i[debug info warn error fatal unknown].each do |level|
      define_method level do |*args, &block|
        if logger
          caller_class = binding.callers.second.eval('self').class.to_s
          caller_method = binding.callers.second.frame_description
          Logger.info([caller_class, caller_method]) if ['PageController'].include? caller_class
          logger&.send(level, *args, &block)
        end
      end

      define_method "#{level}?" do
        true
      end
    end
  end
end

