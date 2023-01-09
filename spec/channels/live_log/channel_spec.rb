# frozen_string_literal: true

require 'rails_helper'

module LiveLog
  RSpec.describe LiveLogChannel, type: :channel do
    # Converts last broadcast message from json to object
    def last_broadcast
      msgs = broadcasts(LiveLog.configuration.channel)
      return OpenStruct.new if msgs.empty? # rubocop:disable Style/OpenStructUse

      last = JSON.parse(msgs.last, object_class: OpenStruct).last # rubocop:disable Style/OpenStructUse
      last.message = last.message.scan(/[a-zA-Z]+/).last
      last
    end

    before(:all) do
      LiveLog.configuration.all_exceptions = false
    end

    it 'successfully subscribes' do
      subscribe
      expect(subscription).to be_confirmed
    end

    it 'changes the channel name' do
      LiveLog.configuration.channel = 'my_channel'
      subscribe
      expect(subscription.streams).to include('my_channel')
    end

    shared_examples 'sends a broadcast' do |args|
      it "sends a broadcast #{args[:example] || args[:type]}" do
        assert_broadcasts LiveLog.configuration.channel, 0
        LiveLog::Logger.send((args[:method] || args[:type]).to_sym, args[:message])
        expect(last_broadcast.type).to eq(args[:type])
        expect(last_broadcast.message).to eq(args[:message])
        assert_broadcasts LiveLog.configuration.channel, args[:count] || 1
      end
    end

    include_examples 'sends a broadcast', type: 'info', message: 'Info'
    include_examples 'sends a broadcast', type: 'warn', message: 'Warning'
    include_examples 'sends a broadcast', type: 'error', message: 'Error'
    include_examples 'sends a broadcast', method: 'handle_exception', type: nil, message: nil, count: 0
    context 'with config' do
      before { LiveLog.configuration.all_exceptions = true }
      include_examples 'sends a broadcast', method: 'handle_exception', type: 'exception', message: 'Exception'
    end
  end
end
