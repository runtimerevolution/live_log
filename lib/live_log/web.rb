require 'rack/builder'

module LiveLog
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
      ::Rack::Builder.new do
        (@middlewares || []).each { |middleware, block| use(*middleware, &block) }
        run LiveLog::Engine
      end
    end
  end
end
