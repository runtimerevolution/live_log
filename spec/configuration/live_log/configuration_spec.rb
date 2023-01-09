# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Configuration' do
  shared_examples 'configuration' do |name, type|
    types = {
      String: 'Some Value',
      Boolean: true,
      Integer: 123
    }

    it "sets #{name} with the right type" do
      expect(LiveLog.configuration).to receive(:instance_variable_set)
      expect(LiveLog.configuration).to receive(:check_type)
      expect { LiveLog.configuration.send("#{name}=", types[type]) }.not_to raise_error
    end

    it "not sets #{name} with the wrong type" do
      types.delete(type)
      types.each { |t| expect { LiveLog.configuration.send("#{name}=", t) }.to raise_error(RuntimeError, /#{type}/) }
    end
  end

  include_examples 'configuration', 'channel', :String
  include_examples 'configuration', 'persist', :Boolean
  include_examples 'configuration', 'all_exceptions', :Boolean
  include_examples 'configuration', 'persist_limit', :Integer
  include_examples 'configuration', 'persist_time', :Integer

  describe 'Redis config tests' do
    before(:all) do
      LiveLog.configuration.redis = Redis.new
    end

    it 'sets a new redis instance' do
      expect { LiveLog.configuration.redis = Redis.new }.not_to raise_error
    end

    it 'sets redis config' do
      expect { LiveLog.configuration.redis = { host: 'somehost' } }.not_to raise_error
    end

    it 'not sets with wrong config' do
      expect { LiveLog.configuration.redis = { something: 'somehost' } }.to raise_error ArgumentError
    end

    it 'not sets with wrong type' do
      expect { LiveLog.configuration.redis = 123 }.to raise_error NoMethodError
    end
  end
end
