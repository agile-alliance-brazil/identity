# frozen_string_literal: true

begin
  desc 'Task to run on CI: runs Rubocop cops, RSpec specs and brakeman'
  task ci: %i[rubocop spec codeclimate-test-reporter brakeman]

  namespace :ci do
    desc 'Task to run on CI: runs Rubocop cops, RSpec specs and brakeman'
    task all: %i[rubocop spec codeclimate-test-reporter brakeman]
  end

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.requires << 'rubocop-rspec'
  end

  task :brakeman do
    sh 'bundle exec brakeman -z --no-pager'
  end

  task :'codeclimate-test-reporter' do
    sh 'if [ ! -z "${CODECLIMATE_REPO_TOKEN}" ]; then\
      bundle exec codeclimate-test-reporter;\
      fi'
  end

  task default: :'ci:all'
rescue LoadError
  warn "Couldn't load rubocop, rspec or brakeman."
end
