# frozen_string_literal: true

require_dependency 'live_log/application_controller'
require 'live_log/tracer'
require 'live_log/logger'

module LiveLog
  class LoggerController < ApplicationController
    # Method will render default page
    def index
      @tracer_files = Tracer.files
      @files_list = files_list
      @log_level = Tracer::LEVELS.key(Tracer.log_level || Tracer::LEVELS[:info])
    end

    # Method will return all data from redis formated
    def redis_data
      render json: Logger.redis_data.map { |_, k| k }
    end

    def tracer_log_level
      return unless Tracer.is_active && tracer_params[:log_level]

      Tracer.log_level = tracer_params[:log_level].to_i
      redirect_back fallback_location: root_path
    end

    # Sets is_active
    def tracer_active
      Tracer.is_active = tracer_params[:active].to_s.downcase == 'true'
      redirect_back fallback_location: root_path
    end

    # Sets files is_active value
    def tracer_files
      return unless Tracer.is_active && tracer_params[:path] && tracer_params[:log_level]

      Tracer.files << { path: tracer_params[:path], log_level: Tracer.log_level || Tracer::LEVELS[:info] }
      redirect_back fallback_location: root_path
    end

    # delete tracer files
    def remove_file
      return unless Tracer.is_active && tracer_params[:id]

      Tracer.files.delete_at(Integer(tracer_params[:id]))
      redirect_back fallback_location: root_path
    end

    private

    def tracer_params
      params.permit(:id, :active, :path, :log_level, :authenticity_token, :method, :group, :file)
    end

    def files_list
      Dir['app/**/*.rb'].map { |f| { path: f, log_level: Tracer.log_level || Tracer::LEVELS[:info] } }
                        .reject { |f| Tracer.files.detect { |h| h[:path] == f[:path] } }
    end
  end
end
