require 'rails_helper'

module LiveLog
  RSpec.describe LiveLogChannel, type: :channel do
    it 'successfully subscribes' do
      subscribe
      expect(subscription).to be_confirmed
    end

    it 'changes the channel name' do
      LiveLog.configure do |config|
        config.channel = 'my_channel'
      end

      subscribe
      expect(subscription.streams).to include('my_channel')
    end

    it 'sends a broacast info' do
      assert_broadcasts LiveLog.configuration.channel, 0
      LiveLog::Logger.info('Info')
      assert_broadcasts LiveLog.configuration.channel, 1
    end

    it 'sends a broacast warn' do
      assert_broadcasts LiveLog.configuration.channel, 0
      LiveLog::Logger.warn('Warning')
      assert_broadcasts LiveLog.configuration.channel, 1
    end

    it 'sends a broacast error' do
      assert_broadcasts LiveLog.configuration.channel, 0
      LiveLog::Logger.error('Error')
      assert_broadcasts LiveLog.configuration.channel, 1
    end

    it 'sends a broacast handle_exception withdout config' do
      assert_broadcasts LiveLog.configuration.channel, 0
      LiveLog::Logger.handle_exception('Exception')
      assert_broadcasts LiveLog.configuration.channel, 0
    end

    it 'sends a broacast handle_exception with config' do
      LiveLog.configuration.all_exceptions = true
      assert_broadcasts LiveLog.configuration.channel, 0
      LiveLog::Logger.handle_exception('Exception')
      assert_broadcasts LiveLog.configuration.channel, 1
    end
  end
end
