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

    %i[debug info warn error fatal unknown].each do |lvl|
      define_method lvl do |*args, &block|
        if logger
          binder = Binding.new(caller.first)
          Logger.send(lvl, "Ola -- #{binder.classname}") if binder.classname == 'PageController'
          logger&.send(lvl, *args, &block)
        end
      end

      define_method "#{lvl}?" do
        true
      end
    end
  end
end

