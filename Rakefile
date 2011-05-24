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
  gem.name = "em-crawler"
  gem.homepage = "http://github.com/dinesh/em-crawler"
  gem.license = "MIT"
  gem.summary = %Q{ A evented ruby based cralwer which supports focused and topical crawling of web. }
  gem.description = %Q{ A evented ruby based cralwer which supports focused and topical crawling of web. }
  gem.email = "dinesh@crypsis.net"
  gem.authors = ["Dinesh Yadav"]  
end

Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'

task :default => [:spec]
task :test => [:spec]

desc "run spec tests"
RSpec::Core::RakeTask.new('spec') do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "crawler #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

import 'migration.rake'