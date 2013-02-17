# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "mexico"
  gem.homepage = "http://github.com/sfb673/mexico"
  gem.license = "LGPL Version 3"
  gem.summary = %Q{MExiCo is a library and API for the management of multimodal experimental corpora.}
  gem.description = %Q{MExiCo is a library and API for the management of multimodal experimental corpora.}
  gem.email = "pmenke@googlemail.com"
  gem.authors = ["Peter Menke"]
  gem.executables = ['mexico']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

#require 'rcov/rcovtask'
#Rcov::RcovTask.new do |test|
#  test.libs << 'test'
#  test.pattern = 'test/**/test_*.rb'
#  test.verbose = true
#  test.rcov_opts << '--exclude "gems/*"'
#end

#require 'cucumber/rake/task'
#Cucumber::Rake::Task.new(:features)

task :default => :test

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec') do |t|
  # t.rspec_opts = '-f html -o assets/spec.html'
  t.rspec_opts = '-f nested'
end

require 'yard'
YARD::Rake::YardocTask.new :doc do |t|
  t.options = %w(--private --protected)
end

task :undoc do |t|
  YARD::CLI::Stats.run('--list-undoc')
end
