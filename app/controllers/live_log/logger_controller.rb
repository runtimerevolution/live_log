require_dependency 'live_log/application_controller'
require 'live_log/tracer'

module LiveLog
  class LoggerController < ApplicationController
    # Method will render default page
    def index
      @tracer_files = LiveLog::Tracer.files
      @files_list = files_list
    end

    # Method will return all data from redis formated
    def redis_data
      render json: LiveLog::Logger.redis_data.map { |_, k| k }
    end

    # Sets is_active
    def tracer_active
      LiveLog::Tracer.is_active = params[:active].to_s.downcase == 'true'
      redirect_back fallback_location: root_path
    end

    # Sets files is_active value
    def tracer_files
      LiveLog::Tracer.files << params[:file]
      redirect_back fallback_location: root_path
    end

    # delete tracer files
    def remove_file
      LiveLog::Tracer.files.delete_at(params[:id].to_i)
      redirect_back fallback_location: root_path
    end

    private

    def files_list
      Dir['app/**/*.rb'] - LiveLog::Tracer.files
    end
  end
end
