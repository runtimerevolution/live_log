# frozen_string_literal: true

module LiveLog
  class Engine < ::Rails::Engine
    isolate_namespace LiveLog
    config.assets.precompile << 'live_log/application.css'

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
