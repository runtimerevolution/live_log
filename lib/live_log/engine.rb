# frozen_string_literal: true

module LiveLog
  class Engine < ::Rails::Engine
    isolate_namespace LiveLog
    config.assets.precompile << 'live_log/application.css'

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'live_log.precompile' do |app|
      app.config.assets.precompile += %w( live_log_channel_old.js ) if Rails.version.to_i < 7
      app.config.assets.precompile += %w( live_log_channel.js ) if Rails.version.to_i >= 7
    end
  end
end
