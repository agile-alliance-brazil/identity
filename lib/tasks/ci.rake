# encoding: UTF-8
begin
  desc 'Task to run on CI: runs Rubocop cops, RSpec specs and Konacha specs'
  task ci: %i(rubocop spec konacha:run brakeman)

  namespace :ci do
    desc 'Task to run on CI: runs Rubocop cops, RSpec specs and Konacha specs'
    task all: %i(rubocop spec konacha:run brakeman)
  end

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)

  task :brakeman do
    sh 'bundle exec brakeman -z'
  end

  task default: :'ci:all'
rescue LoadError
  STDERR.puts "Couldn't load rubocop, rspec, brakeman or konacha."
end
