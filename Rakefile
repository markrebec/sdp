require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  STDERR.puts e.message
  STDERR.puts "Run `gem install bundler` to install Bundler."
  exit e.status_code
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems."
  exit e.status_code
end

require 'rake'

require 'ore/specification'
require 'jeweler'
Jeweler::Tasks.new(Ore::Specification.new)

require 'ore/tasks'
Ore::Tasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts = "-w"
  t.rspec_opts = ['--format', 'documentation', '--color']
end
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new  