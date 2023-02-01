# frozen_string_literal: true

require 'live_log/logger'

module LiveLog
  # Tracer class
  class Tracer
    @is_active = false
    @files = []
    LEVELS = {
      debug: 0,
      info: 1,
      warn: 2,
      error: 3,
      fatal: 4,
      unknown: 5
    }.freeze

    class << self
      attr_accessor :files, :is_active, :log_level
    end

    attr_accessor :formatter, :level, :logger

    def initialize(logger)
      @logger = logger
      @log_level = level
    end

    %i[debug info warn error fatal unknown].each do |lvl|
      define_method lvl do |*args, &block|
        if logger
          if self.class.is_active
            caller_file = get_match_caller caller.first
            if caller_file &&
               self.class.files.map do |f|
                 f[:log_level] == self.class::LEVELS[lvl.to_sym] &&
                 caller_file[:path].include?(f[:path])
               end.include?(true)
              LiveLog::Logger.send(check_level(lvl), "#{caller_file[:path]}: #{args.first}")
            end
          end

          logger&.send(lvl, *args, &block)
        end
      end

      define_method "#{lvl}?" do
        true
      end
    end

    private

    def check_level(lvl)
      return 'handle_exception' if %i[fatal unknown].include? lvl.to_s
      return 'info' if lvl == 'debug'

      lvl
    end

    def get_match_caller(first_caller)
      first_caller.match(regex)
    end

    def regex
      %r{(?<path>[\s\S]*(?:/(?<file>[^/]+)\.)rb)\S*:(?<line>\d*):[\S\s]+(?:(?:`(?<method>[^<]\S+)')|`<class:(?<class>\S+)>|`<module:(?<module>\S+)>)} # rubocop:disable Layout/LineLength
    end
  end
end
