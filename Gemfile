# encoding: utf-8
source 'https://rubygems.org'
ruby '2.3.0'

def linux_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /linux/ ? require_as : false
end

# Mac OS X
def darwin_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /darwin/ ? require_as : false
end

gem 'rails', '~> 4.2'
gem 'haml', '~> 4.0'
gem 'will_paginate', '~> 3.1'
gem 'devise', '~> 3.5'
gem 'devise-i18n'
gem 'doorkeeper', '~> 3.0'
gem 'newrelic_rpm'
gem 'attribute_normalizer'
gem 'aws-ses', require: 'aws/ses'

gem 'omniauth'
# general
gem 'omniauth-facebook'
gem 'omniauth-twitter'
# gem 'omniauth-google-oauth2'
# gem 'omniauth-linkedin-oauth2'
# dev
# gem 'omniauth-azure-oauth2'
# gem 'omniauth-github'
# gem 'omniauth2-gitlab'
# gem 'omniauth-heroku'
# gem 'omniauth-digitalocean'

gem 'jquery-rails', '~>4.0'
gem 'sass-rails', '~>5.0'
gem 'bootstrap-sass', '~> 3.3'
gem 'coffee-rails', '~>4.1'
gem 'jquery-ui-rails', '~>5.0'
gem 'uglifier', '~>3.0'
gem 'turbolinks'

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :development do
  gem 'capistrano', '3.4.0', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'foreman'
  gem 'bullet'
  gem 'lol_dba'
  gem 'byebug'
  gem 'pry'
  gem 'web-console'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'factory_girl_rails'
  gem 'email_spec'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: nil
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rspec-collection_matchers'
  gem 'guard-rspec'
  gem 'guard-livereload', require: false
  gem 'pry-rails'
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'terminal-notifier-guard', require: darwin_only('terminal-notifier-guard')
  gem 'rb-inotify', require: linux_only('rb-inotify')
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'konacha'
  gem 'guard-konacha-rails'
  gem 'poltergeist', require: 'capybara/poltergeist'
  gem 'selenium-webdriver'
  gem 'rubocop'
  gem 'guard-rubocop'
  gem 'brakeman', require: false
end
