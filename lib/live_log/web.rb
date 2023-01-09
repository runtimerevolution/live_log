# frozen_string_literal: true

require 'rack/builder'

module LiveLog
  # This class will handle the rack basic auth
  class Web
    class << self
      # Method initializes new class instance of Web
      #
      # @param [Hash] env accepts application configuration
      def call(env)
        @app ||= new
        @app.call(env)
      end

      # Method initializes middlewares
      def middlewares
        @middlewares ||= []
      end

      # Method enables the insertion of new middlewares into instance
      #
      # @param [Array] args all middlewares
      # @param [Block] block block of code
      def use(*args, &block)
        middlewares << [args, block]
      end
    end

    # Method initializes Web
    #
    # @param [Hash] env accepts application configuration
    def call(env)
      app.call(env)
    end

    # Method builds all middlewares and runs engine
    def app
      @app ||= build
    end

    # Method initializes middlewares
    def middlewares
      @middlewares ||= self.class.middlewares
    end

    # Method enables the insertion of new middlewares into instance
    #
    # @param [Array] args all middlewares
    # @param [Block] block block of code
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
