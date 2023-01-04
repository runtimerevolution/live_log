# frozen_string_literal: true

module LiveLog
  class Engine < ::Rails::Engine
    isolate_namespace LiveLog
    config.assets.precompile << 'live_log/application.css'
    config.assets.precompile << 'live_log_channel.js'

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'live_log.precompile' do |app|
      app.config.assets.precompile += %w( live_log_channel.js )
    end
  end
end
