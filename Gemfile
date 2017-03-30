# encoding: utf-8

source 'https://rubygems.org'
ruby '2.4.0'

def linux_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /linux/ ? require_as : false
end

# Mac OS X
def darwin_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /darwin/ ? require_as : false
end

gem 'attribute_normalizer'
gem 'aws-ses', require: 'aws/ses'
gem 'bootstrap-sass', '~> 3.3'
gem 'coffee-rails', '~>4.1'
gem 'devise', '~> 4.0'
gem 'devise-i18n'
gem 'doorkeeper', '~> 4.2'
gem 'doorkeeper-i18n'
gem 'haml', '~> 4.0'
gem 'jquery-rails', '~>4.0'
gem 'jquery-ui-rails', '~>6.0'
gem 'newrelic_rpm'
gem 'omniauth'
# general
# gem 'omniauth-azure-oauth2'
# gem 'omniauth-digitalocean'
gem 'omniauth-facebook'
# gem 'omniauth-github'
# gem 'omniauth-google-oauth2'
# gem 'omniauth-heroku'
# gem 'omniauth-linkedin-oauth2'
gem 'omniauth-twitter'
# gem 'omniauth2-gitlab'
gem 'rails', '~> 5.0'
gem 'sass-rails', '~>5.0'
gem 'therubyracer'
gem 'turbolinks'
gem 'uglifier', '~>3.0'
gem 'will_paginate', '~> 3.1'

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :development do
  # TODO: Either remove or set up capistrano
  # gem 'capistrano', '3.4.1', require: false
  # gem 'capistrano-bundler', require: false
  # gem 'capistrano-rails', require: false
  gem 'bullet'
  gem 'byebug'
  gem 'foreman'
  gem 'lol_dba'
  gem 'pry'
  gem 'rack-livereload'
  gem 'web-console'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'email_spec'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers', require: false
  gem 'simplecov'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'dotenv-rails'
  gem 'guard-livereload', require: false
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'poltergeist', require: 'capybara/poltergeist'
  gem 'pry-rails'
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'rb-inotify', require: linux_only('rb-inotify')
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'selenium-webdriver'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'sqlite3'
  gem 'terminal-notifier-guard', require: darwin_only('terminal-notifier-guard')
end
