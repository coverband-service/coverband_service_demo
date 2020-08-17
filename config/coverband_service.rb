###
# NOTE: We need to solve issues with using:
# * Figaro
# * Rails.application.credentials
# * requiring rails-dotenv users to fastload
#
# We want to be able to have all of those working in this Coverband.configure block
###
# after moving to using coverband with the service adapter triggering Figaro.load works
# but it is to late when using coverband-service-client (same for rails secrets)
# require 'figaro'
# Figaro.application = Figaro::Application.new(environment: Rails.env.to_s, path: File.expand_path('../config/application.yml', __FILE__))

puts "data from rails-dotenv: #{ENV['DOTENV_TEST']}"
# puts "data from figaro: #{ENV['FIGARO_TEST']}"
# puts "rails secrets: #{Rails.application.credentials.rails_secrets_loaded}"
# Rails.application.credentials.coverband_api_key
puts "configuring service"
Coverband.configure do |config|
  # add local ignores, ignores listed here will filter and never send data to Coverband service
  config.ignore = %w[config/application.rb
                     config/boot.rb
                     config/coverband.rb]

  # set API key via Rails configs opposed to ENV vars
  config.api_key = Rails.application.credentials.coverband_api_key

  # when debugging it is nice to report often
  config.background_reporting_sleep_seconds = 10

  # Logging when debugging
  config.logger = Rails.logger
  # enable to debug in development if having issues sending files
  # config.verbose = true
end
