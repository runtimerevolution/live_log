# frozen_string_literal: true

require 'rack/builder'

module LiveLog
  # This class will handle the rack basic auth
  class Web
    class << self
      def call(env)
        @app ||= new
        @app.call(env)
      end

      def middlewares
        @middlewares ||= []
      end

      def use(*args, &block)
        middlewares << [args, block]
      end
    end

    def call(env)
      app.call(env)
    end

    def app
      @app ||= build
    end

    def middlewares
      @middlewares ||= self.class.middlewares
    end

    def use(*args, &block)
      middlewares << [args, block]
    end

    private

    def build
      m = middlewares
      ::Rack::Builder.new do
        m.each { |middleware, block| use(*middleware, &block) }
        run LiveLog::Engine
      end
    end
  end
end
