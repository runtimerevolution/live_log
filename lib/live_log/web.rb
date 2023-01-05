require 'rack/builder'

module LiveLog
  class Web
    def call(env)
      app.call(env)
    end

    def self.call(env)
      @app ||= new
      @app.call(env)
    end

    def self.middlewares
      @middlewares ||= []
    end

    def self.use(*args, &block)
      middlewares << [args, block]
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
