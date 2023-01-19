# LiveLog
LiveLog provides an user interface to show logs in realtime for production.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'live_log'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install live_log
```

## Usage

### Configuration
#### Views
To use `live_log` views you need to add this mount into your `routes.rb`

```ruby
mount LiveLog::Web, at: 'rrtools/live-log', defaults: { group: 'RRTools' }
```

It will be accessible on the browser at `/rrtools/live-log` with or without middlewares.

Pay attention that is good pratice to protect this route on production because it could have confidential metadata. We also support [basic auth](#basic-auth) that you can use to protect it.

#### Middleware
All middlewares are optional
##### Basic Auth

Enabling basic auth requires adding the middleware with recommended environment variables

```ruby
LiveLog::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['LIVELOG_USERNAME'])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['LIVELOG_PASSWORD']))
end if Rails.env.production?
mount LiveLog::Web, at: 'rrtools/live-log', defaults: { group: 'RRTools' }
```

#### All exceptions

To use `all_exceptions` feature we need to add the following code on your `application_controller.rb`.

```ruby
rescue_from Exception, with: ->(e) { LiveLog::Logger.handle_exception(e) }
```

It will catch all the exception from your controllers and log them on `/rrtools/live-log`

This feature requires `all_exceptions` enable on the [initializer](#initializers).

#### Rails Logger

LiveLog can catch all the logs from your rails application and filter it by files. To make it work just add the following on the `development.rb` or `production.rb` file:

```ruby
require "live_log/tracer"

config.logger = LiveLog::Tracer.new(ActiveSupport::Logger.new($stdout))
```
#### Initializers
You can define configurations by creating a file `live_log.rb` on `config/initializers` and use it like the following:

```ruby
LiveLog.configuration.channel = 'my_channel_name'
LiveLog.configuration.persist = true
LiveLog.configuration.persist_limit = 10
LiveLog.configuration.persist_time = 5
LiveLog.configuration.all_exceptions = true
```

**or**

```ruby
LiveLog.configure do |config|
    config.channel = 'my_channel_name'
    config.persist = true
    config.persist_limit = 10
    config.persist_time = 5
    config.all_exceptions = true
end
```

##### Types

| Name  |  Type | Default  | Description  |
|---|---|---|---|
|channel|string|"live_log_channel"|It setups the name of the streaming room|
|persist|boolean|false|It enables the persistance of data|
|persist_limit|integer|5|Amount of individual data that will persist|
|persist_time|integer|1|Amount of time in minutes that the data will persist|
|all_exceptions|boolean|false|It enables to send all exceptions|
|redis|hash|{}|It adds custom configs to redis|

### Implementation

To use this gem you just need to call the logger, for instance:

```ruby
LiveLog::Logger.info "Some message"
```

This will send the message to the view on `/rrtools/live-log`.

You have these type of messages for visual purposes on the view, they are essentially the same.

```ruby
LiveLog::Logger.info
LiveLog::Logger.warn
LiveLog::Logger.error
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/runtimerevolution/live_log.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
