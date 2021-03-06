source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# ENV
gem 'dotenv-rails', :groups => [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
gem 'turbolinks'

# Amazon S3
gem "aws-sdk-s3", require: false
# CORS
gem 'rack-cors'

# Cocoon
gem 'cocoon'
# Validate links
gem 'validate_url'
# Octokit
gem 'octokit', '~> 4.0'

# For Action Cable rendering
gem 'gon'

# OmniAuth
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-facebook'

# Authorization
gem 'cancancan'

gem 'pry-rails'
gem 'pry-byebug'

# REST API
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'

# ACTIVE JOB
gem 'sidekiq', '< 6'
gem 'sinatra', require: false
gem 'whenever', require: false

# SPHINX
gem 'mysql2',          '~> 0.4.10', :platform => :ruby
gem 'thinking-sphinx', '~> 4.4.1', git: 'https://github.com/pat/thinking-sphinx.git', branch: 'develop'

gem 'mini_racer'
gem 'unicorn'
gem 'redis-rails'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'slim-rails'
gem 'devise'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.0.beta'
  gem 'factory_bot_rails'
end

group :development do
  gem "letter_opener"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # DEPLOY
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-ssh-doctor', '~> 1.0'
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'capybara-email'
  gem 'capybara-selenium'
  # Database cleaner
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-redis'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 3.0.0.alpha'
  gem 'rails-controller-testing'
  gem 'launchy'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
