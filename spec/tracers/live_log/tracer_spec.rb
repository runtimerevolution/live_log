# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LiveLog::Tracer do
  before(:all) do
    LiveLog::Tracer.is_active = true
  end

  shared_examples 'sends a console' do |type|
    let(:tracer) { Rails.logger }

    it "#{type} log" do
      LiveLog::Tracer.files = [{ path: 'log_subscriber', log_level: described_class::LEVELS[type.to_sym] }]
      expect(tracer).to receive(type.to_sym).with(type).at_least(:once)
      # Tracer doesn't output to log file
      tracer.send(type.to_sym, type)
      expect do
        # Tracer logger does output to log file
        tracer.logger.send(type.to_sym, type)
        system('tail -1 spec/dummy/log/test.log')
      end.to output("#{type}\n").to_stdout_from_any_process
    end
  end

  include_examples 'sends a console', 'info'
  include_examples 'sends a console', 'warn'
  include_examples 'sends a console', 'debug'
  include_examples 'sends a console', 'error'
  include_examples 'sends a console', 'fatal'
  include_examples 'sends a console', 'unknown'
end
