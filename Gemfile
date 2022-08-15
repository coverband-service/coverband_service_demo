# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'pg'
gem 'rails', '~> 6.1.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# verify we support alternative view templates like HAML
gem 'haml'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

#gem 'coverband-service-client'
#gem 'coverband-service-client', path: '../coverband-service-client'

# to use the persistent client with coverband service install this gem prior
# to coverband
# gem "net-http-persistent"

# to collect stats about coverband report time
gem "dogapi"


# from rubygems
gem 'coverband', '~> 5.0.0'

gem 'psych', '< 4'

# for local development
# gem 'coverband', '~> 5.0.0.rc.4', path: '../coverband'
# gem 'coverband-service-client', '~> 0.0.14'
# gem 'coverband-service-client', path: '../coverband-service-client'

# ensure figaro loads how we want
#gem "figaro"
# rails now is not needed for using dotenv in your config/coverband.rb but it is needed for env vars
# to be picked up by the coverband gem initialize if you want it to find defaults like coverband_url
gem 'dotenv-rails', groups: %i[development qa test], require: 'dotenv/rails-now'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # add binding.pry to debug
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
