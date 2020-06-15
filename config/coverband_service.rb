Coverband.configure do |config|
  # add local ignores, ignores listed here will filter and never send data to Coverband service
  config.ignore = %w[config/application.rb
                     config/boot.rb
                     config/coverband.rb]

  # set API key via Rails configs opposed to ENV vars
  # config.api_key = Rails.application.credentials.coverband_api_key

  # enable to debug in development if having issues sending files
  config.verbose = false
end
