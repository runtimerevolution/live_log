module LiveLog
  class LiveLogChannel < ApplicationCable::Channel
    def subscribed
      stream_from LiveLog.configuration.channel || 'live_log_channel'
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end
end
