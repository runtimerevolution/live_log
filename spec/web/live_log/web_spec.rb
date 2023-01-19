# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LiveLog::Web do
  it 'has basic auth middleware' do
    m = described_class.middlewares
    expect(m.first.first).to eq([Rack::Auth::Basic])
  end

  it 'adds blank middleware' do
    m = described_class.use nil
    expect(m.last).to eq([[nil], nil])
  end
end
