

require 'rubygems'
require 'em-synchrony'
require 'em-synchrony/em-http'
require 'ap'
require 'uri'

EM.run{
  Fiber.new {
  
  }.resume
  
  trap('INT'){ EM.stop }
  
}