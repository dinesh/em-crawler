
require File.expand_path File.join( File.dirname(__FILE__), '..', 'lib', 'boot')
require 'ap'
SEEDS = ['http://news.ycombinator.com', 'http://news.google.com']


class OnShotSpider
  include EM::Deferrable
  include EMCrawler::Util
  include EMCrawler::Console
  
  def self.run opts
    new(opts[:seeds], opts).start(opts[:seeds])
  end
  
  attr_accessor :urls, :options 
  
  def initialize seeds, opts = {}
    @urls = Models::Url.limit(1)
    @options = { :wait => 3, :redirect_limit => 3, :max_seed_size => 10000, :store => 'seed.txt' }
    @options = @options.merge!( opts )
    EMCrawler::Frontiers.setup
  end
  
  def start urls
    urls = urls.map!{|u| Models::Url.get(u) }
    begin 
        EMCrawler::Frontiers.add(urls)
        crawl
    rescue Exception => e
      puts e.message
      puts e.backtrace
      EM.stop
    end
  end
  
  def crawl 
    looper = lambda { 
      EMCrawler::Frontiers.get(10).each do |seed|
        EMCrawler::Fetcher.get(seed){|response| extract_links(seed, response) }
      end
    }
    looper.call
  end
  
  def extract_links url, body
      doc = Nokogiri::HTML.parse(body)
      anchor_handle = lambda {|link|  
        uri = Addressable::URI.heuristic_parse(link) 
        uri = uri.relative? ? Addressable::URI.join(url.uri, uri) : uri
      }    
      outgoing_links = (doc/'a[href]').map{|u| anchor_handle.call(u['href']) }.uniq
      Fiber.new{ 
        outgoing_links.each{|u| url.add_outgoing(u) }
        EMCrawler::Frontiers.add(outgoing_links)
      }.resume
      
  end
  
  
end

if __FILE__ == $0
    EM.run do 
      trap('INT') { puts ' quiting spider... '; EM.stop }
      Fiber.new{ OnShotSpider.run(:seeds => SEEDS) }.resume
    end
  
end
  