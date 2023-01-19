Rails.application.routes.draw do
  LiveLog::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['LIVELOG_USERNAME'])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['LIVELOG_PASSWORD']))
  end
  mount LiveLog::Web, at: '/live_log', defaults: { group: 'RRTools' }
end
