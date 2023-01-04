require_relative 'lib/live_log/version'

Gem::Specification.new do |spec|
  spec.name        = 'live_log'
  spec.version     = LiveLog::VERSION
  spec.authors     = ['Runtime Revolution']
  spec.email       = ['info@runtime-revolution.com']
  spec.homepage    = 'http://www.runtime-revolution.com/'
  spec.summary     = 'Summary of LiveLog.'
  spec.description = 'Description of LiveLog.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/runtimerevolution/live_log'
  spec.metadata['changelog_uri'] = 'https://github.com/runtimerevolution/live_log'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'mock_redis'
  spec.add_development_dependency 'rails', '~> 6.1.7'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'timecop'

  spec.add_dependency 'redis'
end
