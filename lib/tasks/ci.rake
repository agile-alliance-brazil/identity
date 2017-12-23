begin
  desc 'Task to run on CI: runs Rubocop cops, RSpec specs and brakeman'
  task ci: %i[rubocop spec codeclimate-test-reporter brakeman]

  namespace :ci do
    desc 'Task to run on CI: runs Rubocop cops, RSpec specs and brakeman'
    task all: %i[rubocop spec codeclimate-test-reporter brakeman]
  end

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)

  task :brakeman do
    sh 'bundler exec brakeman -z --no-pager'
  end

  task :'codeclimate-test-reporter' do
    sh 'if [ ! -z "${CODECLIMATE_REPO_TOKEN}" ]; then\
      bundler exec codeclimate-test-reporter;\
      fi'
  end

  task default: :'ci:all'
rescue LoadError
  STDERR.puts "Couldn't load rubocop, rspec or brakeman."
end
