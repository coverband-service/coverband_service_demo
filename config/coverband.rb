# frozen_string_literal: true

require 'securerandom'

module Coverband
  module Adapters
    ###
    # Take Coverband data and store a merged coverage set to the Coverband service
    #
    # NOTES:
    # * uses net/http to avoid any dependencies
    # * currently JSON, but likely better to move to something simpler / faster
    ###
    class Service < Base
      attr_reader :coverband_url, :process_type, :runtime_env, :coverband_id

      def initialize(coverband_url, opts = {})
        super()
        @coverband_url = coverband_url
        @process_type = opts.fetch(:process_type) { 'unknown' }
        @runtime_env = opts.fetch(:runtime_env) { Rails.env }
        @coverband_id = opts.fetch(:coverband_id) { 'coverband-service/coverband_service_demo' }
      end

      def clear!
        # TBD
      end

      def clear_file!(filename)
        # TBD
      end

      # TODO: we should support nil to mean not supported
      def size
        0
      end

      # TODO: no longer get by type just get both reports in a single request
      def coverage(local_type = nil, opts = {})
        local_type ||= opts.key?(:override_type) ? opts[:override_type] : type
        uri = URI("#{coverband_url}/api/coverage/#{coverband_id}?type=#{local_type}")
        req = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json', 'Coverband-Token' => 'abcd')
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(req)
        end
        coverage_data = JSON.parse(res.body)
        # puts "coverage data: "
        # puts coverage_data
        coverage_data
      rescue StandardError => err
        puts "Coverband: Error while retrieving coverage #{err}"
      end

      def save_report(report)
        return if report.empty?

        # TODO: do we need dup
        # TODO: remove timestamps, server will track first_seen
        data = expand_report(report.dup)
        full_package = {
          coverband_id: coverband_id,
          collection_type: 'coverage_delta',
          collection_data: {
            tags: {
              process_type: process_type,
              app_loading: type == Coverband::EAGER_TYPE,
              runtime_env: runtime_env
            },
            file_coverage: data
          }
        }
        save_coverage(full_package)
      end

      def raw_store
        raise 'not supported'
      end

      private

      def save_coverage(data)
        uri = URI("#{coverband_url}/api/collector")
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json', 'Coverband-Token' => 'abcd')
        # puts "sending #{data}"
        req.body = { remote_uuid: SecureRandom.uuid, data: data }.to_json
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(req)
        end
      rescue StandardError => err
        puts "Coverband: Error while saving coverage #{err}"
      end
    end
  end
end

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
