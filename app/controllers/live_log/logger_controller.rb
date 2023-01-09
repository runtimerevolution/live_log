require_dependency 'live_log/application_controller'

module LiveLog
  class LoggerController < ApplicationController
    # Method will render default page
    def index; end

    # Method will return all data from redis formated
    def redis_data
      render json: LiveLog::Logger.redis_data.map { |_, k| k }
    end
  end
end
