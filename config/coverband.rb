# frozen_string_literal: true

require 'securerandom'
require 'coverband'
require "coverband/service/client"

Coverband.configure do |config|
  # toggle store type
  redis_url = ENV['REDIS_URL']
  # Normal Coverband Setup
  # config.store = Coverband::Adapters::HashRedisStore.new(Redis.new(url: redis_url))
  # Use The Test Service Adapter
  coverband_service_url = ENV['COVERBAND_URL'] || 'http://127.0.0.1:3456'
  config.store = Coverband::Adapters::Service.new(coverband_service_url)
  # in general I would leave the report time to the defaults,
  # but for the demo it is nice to update even faster
  config.background_reporting_sleep_seconds = 10

  # toggle on and off using oneshot
  # config.use_oneshot_lines_coverage = true
  # config.simulate_oneshot_lines_coverage = true

  # toggle allowing folks to clear coverband from web-ui
  config.web_enable_clear = true

  # toggle on and off web debug
  # allowing one to dump full coverband stored json data to web
  config.web_debug = true

  # toggle on and off tracking gems
  # config.track_gems = true

  # toggle on and off gem file details
  # config.gem_details = true

  # TODO: the initial service will not support tracking views
  # config.track_views = false

  # ignores bin started to show in runtime only ;)
  # NOTE: that activerecord/* shows how to ignore gems
  config.ignore += %w[config/application.rb
                      config/boot.rb
                      config/puma.rb
                      config/coverband.rb
                      bin/*
                      config/initializers/*
                      config/spring.rb
                      config/environments/test.rb
                      config/environments/development.rb
                      config/environments/production.rb]

  # Logging when debugging
  config.logger = Rails.logger

  # config options false, true, or 'debug'. Always use false in production
  # true and debug can give helpful and interesting code usage information
  # they both increase the performance overhead of the gem a little.
  # they can also help with initially debugging the installation.
  config.verbose = false # true
end
