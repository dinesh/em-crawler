
require 'rubygems'
require 'eventmachine'
require 'em-http'
require 'em-synchrony'
require 'addressable/uri'
require 'nokogiri'
require 'rainbow'

$:.unshift File.dirname(__FILE__)
%w[ em-crawler ].each do |path|
  $:.unshift File.expand_path File.join(File.dirname(__FILE__), path)
end

require 'config'

module EMCrawler

  class << self
    attr_accessor :config
    def config
      @config ||= Config.new
    end
    
  end
  
end

require 'models/url'