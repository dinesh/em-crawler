
require 'rubygems'
require 'addressable/uri'
require 'nokogiri'
require 'rainbow'
require 'active_support'

require 'em-synchrony'
require 'em-synchrony/em-http'
require 'em-synchrony/iterator'


require 'em-crawler/patch'


module Models
  autoload :Base, 'em-crawler/models/base'
  autoload :Url, 'em-crawler/models/url'
  autoload :LinkNode, 'em-crawler/models/link_node'
end

module EMCrawler
  autoload :Config, 'em-crawler/config'
  autoload :Frontiers, 'em-crawler/frontiers'
  autoload :Util, 'em-crawler/util'
  autoload :Console, 'em-crawler/console'
  autoload :Fetcher, 'em-crawler/fetcher'
  
  module Cache
    autoload :Http, 'em-crawler/cache/http'
  end
  
  module Frontiers
    autoload :Basic, 'em-crawler/frontiers/basic'
    autoload :Mercator, 'em-crawler/frontiers/mercator' 
  end
  
  
  class << self
    attr_accessor :config
    def config
      @config ||= Config.new
    end 
    
    def root
      config.root
    end
    
  end
  
end
