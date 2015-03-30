# encoding: UTF-8
begin
  desc 'Task to run on CI: runs Rubocop cops, RSpec specs and Konacha specs'
  task ci: %i(rubocop spec konacha:run)

  namespace :ci do
    desc 'Task to run on CI: runs Rubocop cops, RSpec specs and Konacha specs'
    task all: %i(rubocop spec konacha:run)
  end

  task :rubocop do
    sh 'bundle exec rubocop'
  end

  task default: :'ci:all'
rescue LoadError
  STDERR.puts "Couldn't load rubocop, rspec or konacha."
end
