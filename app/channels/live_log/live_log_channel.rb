# frozen_string_literal: true

module LiveLog
  # This class will create the channel setup
  class LiveLogChannel < ApplicationCable::Channel
    # Method will start the streaming connection for new subscription
    def subscribed
      stream_from LiveLog.configuration.channel || 'live_log_channel'
    end

    # Method will stop the connection
    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end
end
