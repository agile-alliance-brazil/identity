#encoding: utf-8 
source 'https://rubygems.org'
ruby '2.2.0'

def linux_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /linux/ ? require_as : false
end
# Mac OS X
def darwin_only(require_as)
  RbConfig::CONFIG['host_os'] =~ /darwin/ ? require_as : false
end

gem 'rails', '4.2.0'
gem 'haml', '4.0.6'
gem 'will_paginate', '3.0.7'
gem 'devise', '3.4.1'
gem 'devise-i18n'
gem 'devise-encryptable', '0.2.0'
gem 'doorkeeper', '2.1.0'
gem 'newrelic_rpm'

gem 'jquery-rails', '~>4.0'
gem 'sass-rails', '~>5.0'
gem 'coffee-rails', '~>4.1'
gem 'jquery-ui-rails', '~>5.0'
gem 'uglifier', '~>2.7'
gem 'turbolinks'

group :development do
  gem 'capistrano', '3.3.5', require: false
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
  gem 'mocha'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'simplecov'
  gem 'email_spec'
  gem 'codeclimate-test-reporter', require: nil
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'rspec-collection_matchers'
  gem 'guard-rspec'
  gem 'pry-rails'
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'terminal-notifier-guard', require: darwin_only('terminal-notifier-guard')
  gem 'rb-inotify', require: linux_only('rb-inotify')
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'konacha'
  gem 'guard-konacha', git: 'https://github.com/lbeder/guard-konacha.git'
  gem 'poltergeist', require: 'capybara/poltergeist'
  gem 'selenium-webdriver'
end
