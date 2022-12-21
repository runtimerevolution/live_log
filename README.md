# LiveLog
Short description and motivation.

## Usage
How to use my plugin.

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

## Getting started
After the installation we need to setup the action cable to the project.

Run the following command:

```bash
bin/rails g live_log:config:config
```

This command will add 2 new files `live_log_channel.rb` and `live_log_channel.js` these files will be responsible to adding the correct configuration.

Now paste the following code on your `application_controller.rb` to be able to use the `all_exceptions` feature:

```ruby
rescue_from Exception, with: ->(e) { LiveLog::Logger.handle_exception(e) }
```

#### Gem configuration initializers
You can also define configurations by creating a file `live_log.rb` on `config/initializers` and use it like the following:

```ruby
LiveLog.configuration.channel = 'my_channel_name'
LiveLog.configuration.persist = true
LiveLog.configuration.persist_limit = 10
LiveLog.configuration.persist_time = 5
LiveLog.configuration.all_exceptions = true
```

or

```ruby
LiveLog.configure do |config|
    config.channel = 'my_channel_name'
    config.persist = true
    config.persist_limit = 10
    config.persist_time = 5
    config.all_exceptions = true
end
```

| Name  |  Type | Default  | Description  |
|---|---|---|---|
|channel|string|"live_log_channel"|It setups the name of the streaming room|
|persist|boolean|false|It enables the persistance of data|
|persist_limit|integer|5|Amount of individual data that will persist|
|persist_time|integer|1|Amount of time in minutes that the data will persist|
|all_exceptions|boolean|false|It enables to send all exceptions|

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
