# frozen_string_literal: true

module LiveLog
  # Logger contains the methods to broadcast a message
  class Logger
    class << self
      def error(payload)
        broadcast_message(format_payload('error', payload))
      end

      def warn(payload)
        broadcast_message(format_payload('warn', payload))
      end

      def info(payload)
        broadcast_message(format_payload('info', payload))
      end

      def handle_exception(payload)
        return unless LiveLog.configuration.all_exceptions

        broadcast_message(format_payload('exception', payload))
      end

      def redis_data
        update_redis_data
      end

      private

      def redis
        LiveLog.configuration.redis
      end

      def format_payload(type, payload)
        { type: type, time: to_ms(Time.now), message: payload.to_json, groupId: '0' }
      end

      def broadcast_message(*payload)
        redis_persist(payload) if LiveLog.configuration.persist
        ActionCable.server.broadcast LiveLog.configuration.channel, payload
      end

      def to_ms(time)
        (time.to_f * 1000.0).to_i
      end

      def min_timestamp
        to_ms(Time.now) - to_ms(LiveLog.configuration.persist_time.minute)
      end

      def redis_persist(payload)
        redis.xadd(LiveLog.configuration.channel, *payload, id: "#{to_ms(Time.now)}-0")
        update_redis_data
      end

      def update_redis_data
        redis.call(['xtrim', LiveLog.configuration.channel, 'minid', '=', "#{min_timestamp}-0"])
        redis.xrevrange(LiveLog.configuration.channel, '+', '-', count: LiveLog.configuration.persist_limit)
      end
    end
  end
end
