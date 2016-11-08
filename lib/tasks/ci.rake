# encoding: UTF-8
begin
  desc 'Task to run on CI: runs Rubocop cops, RSpec specs and Konacha specs'
  task ci: %i(rubocop spec codeclimate-test-reporter konacha:run brakeman)

  namespace :ci do
    desc 'Task to run on CI: runs Rubocop cops, RSpec specs and Konacha specs'
    task all: %i(rubocop spec codeclimate-test-reporter konacha:run brakeman)
  end

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)

  task :brakeman do
    sh 'bundle exec brakeman -z'
  end

  task :'codeclimate-test-reporter' do
    sh 'if [[ -n ${CODECLIMATE_REPO_TOKEN} ]]; then\
      bundle exec codeclimate-test-reporter;\
      fi'
  end

  task default: :'ci:all'
rescue LoadError
  STDERR.puts "Couldn't load rubocop, rspec, brakeman or konacha."
end
