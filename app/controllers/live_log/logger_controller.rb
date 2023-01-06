require_dependency 'live_log/application_controller'

module LiveLog
  class LoggerController < ApplicationController
    def index; end

    def redis_data
      render json: LiveLog::Logger.redis_data.map { |_, k| k }
    end
  end
end
