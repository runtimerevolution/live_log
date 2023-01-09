# frozen_string_literal: true

module LiveLog
  # This class starts the engine for the gem and all initializers
  #
  # When engine initializes it precompiles both css and js files
  class Engine < ::Rails::Engine
    isolate_namespace LiveLog

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer :precompile do |app|
      app.config.assets.precompile << 'live_log/application.css'
      app.config.assets.precompile << LiveLog.file_version
    end
  end
end
