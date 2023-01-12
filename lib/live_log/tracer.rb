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
          call = caller.first
          matcher = call.match(/(\/(?<file>[^\/]+)\.)[\S]*:(?<line>[\d]*):[\S\s]+((`(?<method>[^<][\S]+)')|`<class:(?<class>[\S]+)>|`<module:(?<module>[\S]+)>)/)
          Logger.send(lvl, "#{matcher[:file]}::#{matcher[:method] || matcher[:class] || matcher[:module]}        #{args.first}") if call.include? 'page_controller'
          logger&.send(lvl, *args, &block)
        end
      end

      define_method "#{lvl}?" do
        true
      end
    end
  end
end

