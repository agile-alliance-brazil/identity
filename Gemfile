# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.3'

def linux_only(require_as)
  RbConfig::CONFIG['host_os'].match(/linux/).nil? ? false : require_as
end

# Mac OS X
def darwin_only(require_as)
  RbConfig::CONFIG['host_os'].match(/darwin/).nil? ? false : require_as
end

gem 'attribute_normalizer'
gem 'aws-ses', require: 'aws/ses'
gem 'bootstrap-sass', '~> 3.4'
gem 'bundler'
gem 'coffee-rails', '~> 5.0', '>= 5.0.0'
gem 'devise', '~> 4.7', '>= 4.7.1'
gem 'devise-i18n', '>= 1.9.1'
gem 'doorkeeper', '~> 4.4', '>= 4.4.3'
gem 'doorkeeper-i18n'
gem 'haml', '~> 5.0'
gem 'jquery-rails', '~> 4.4', '>= 4.4.0'
gem 'jquery-ui-rails', '~> 6.0', '>= 6.0.1'
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
gem 'rails', '~> 5.2', '>= 5.2.4.3'
gem 'sass-rails', '~> 6.0', '>= 6.0.0'
gem 'therubyracer'
gem 'turbolinks'
gem 'uglifier', '~>4.0'
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
  gem 'bullet', '>= 6.1.0'
  gem 'byebug'
  gem 'foreman'
  gem 'lol_dba', '>= 2.2.0'
  gem 'pry'
  gem 'rack-livereload'
  gem 'web-console', '>= 3.7.0'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 1.0.8'
  gem 'email_spec'
  gem 'factory_bot_rails', '>= 5.2.0'
  gem 'shoulda-matchers', '>= 4.3.0', require: false
  gem 'simplecov', '>= 0.13.0'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'dotenv-rails', '>= 2.7.5'
  gem 'guard-livereload', require: false
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'poltergeist', '>= 1.18.1', require: 'capybara/poltergeist'
  gem 'pry-rails'
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'rb-inotify', require: linux_only('rb-inotify')
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'rspec-rails', '>= 4.0.1'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'selenium-webdriver'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'sqlite3'
  gem 'terminal-notifier-guard', require: darwin_only('terminal-notifier-guard')
end
