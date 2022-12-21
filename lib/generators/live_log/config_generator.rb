# frozen_string_literal: true

require 'rails/generators'

module LiveLog
  module Generators
    # Copy Generator will copy the necessary files for the action cable if it don't exists
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_from_directories
        live_log_channel_rb_path = 'app/channels/live_log_channel.rb'
        live_log_channel_js_path = 'app/javascript/packs/live_log_channel.js'
        copy_file 'live_log_channel.rb', live_log_channel_rb_path unless File.exist?(live_log_channel_rb_path)
        copy_file 'live_log_channel.js', live_log_channel_js_path unless File.exist?(live_log_channel_js_path)
      end

      def add_mount_application
        route "mount LiveLog::Engine, at: '/live_log'"
      end
    end
  end
end
