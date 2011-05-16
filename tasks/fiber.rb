

require File.expand_path File.join( File.dirname(__FILE__), '..', 'lib', 'boot')
require 'fiber'
require 'ap'
require 'em-crawler/models/base'

EM::synchrony do
  u = 'http://news.ycombinator.com'
  c =  Models::Url.find_by_code EMCrawler::Util.digest(u)
  puts 'here we go..'
  trap('INT'){ EM.stop }
end
