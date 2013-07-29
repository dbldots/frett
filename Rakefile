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
  gem.name = "frett"
  gem.homepage = "http://github.com/dbldots/frett"
  gem.license = "WTFPL"
  gem.summary = %Q{search engine for local files}
  gem.description = <<DESC
frett is a search engine for local files. once your project gets very large, even great
tools like ack or silver searcher need some time to complete their job. if you hate waiting
for search results you might want to try out frett.
DESC
  gem.email = "dbldots@gmail.com"
  gem.authors = ["Johannes-Kostas Goetzinger"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
