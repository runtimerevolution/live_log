# frozen_string_literal: true

require 'redis'

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
        min_timestamp = to_ms(Time.now) - to_ms(LiveLog.configuration.persist_time.minute)
        redis.call(['xtrim', LiveLog.configuration.channel, 'minid', '=', "#{min_timestamp}-0"])
        redis.xrevrange(LiveLog.configuration.channel, '+', '-', count: LiveLog.configuration.persist_limit)
      end

      private

      def redis
        @redis ||= Redis.new
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

      def redis_persist(payload)
        timestamp_ms = to_ms(Time.now)
        live_log = LiveLog.configuration
        min_timestamp = timestamp_ms - to_ms(live_log.persist_time.minute)
        redis.xadd(live_log.channel, *payload, id: "#{timestamp_ms}-0")
        redis.call(['xtrim', live_log.channel, 'minid', '=', "#{min_timestamp}-0"])
        redis.xrevrange(live_log.channel, '+', '-', count: live_log.persist_limit)
      end
    end
  end
end
