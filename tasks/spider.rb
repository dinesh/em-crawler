
require File.expand_path File.join( File.dirname(__FILE__), '..', 'lib', 'boot')
require 'ap'
SEEDS = ['http://news.ycombinator.com', 'http://news.google.com']


class OnShotSpider
  include EM::Deferrable
  include EMCrawler::Util
  include EMCrawler::Console
  
  def self.run opts
    ( @instance = new(opts[:seeds], opts) ).start(opts[:seeds])
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
        count = 1
        loop do 
          fiber = Fiber.current
          green "Crawler entering into #{count} iteration with #{fiber}... \n"
          crawl
          EM.add_timer(3){ puts "Resumeing the crawler #{fiber} => #{fiber.alive?}" ; fiber.resume }
          Fiber.yield
          count += 1
        end
    rescue Exception => e
      puts e.message
      puts e.backtrace
      EM.stop
    end
  end
  
  def crawl 
    ap "fiber => #{f = Fiber.current} => #{f.alive?}.."
    looper = lambda { 
      EMCrawler::Frontiers.get(20).each do |seed|
        EMCrawler::Fetcher.get(seed){|url, response| extract_links(url, response) }
      end
    }
    looper.call
  end
  
  def extract_links url, body
      puts "\t--> Processing #{url.uri} (#{body.size}).."
      doc = Nokogiri::HTML.parse(body)
      anchor_handle = lambda {|link|  
        uri = Addressable::URI.heuristic_parse(link) rescue nil 
        uri = uri.relative? ? Addressable::URI.join(url.uri, uri) : uri if uri
      }    
      outgoing_links = (doc/'a[href]').map{|u| anchor_handle.call(u['href']) }.compact.uniq
      puts     "\t--> Got #{outgoing_links.size} links"
      outgoing_links.map!{ |u| url.add_outgoing(u) }
      size = EMCrawler::Frontiers.add(outgoing_links)
      green "Frontier size => #{size}..."
  end
  
  def stop
    EMCrawler::Fetcher.stop
  end
  
  def self.shutdown
    @instance.stop if @instance
  end
  
end

if __FILE__ == $0
    EM.run do 
      trap('INT') { puts ' quiting spider... '; OnShotSpider.shutdown; EM.stop }
      Fiber.new{ 
        OnShotSpider.run(:seeds => SEEDS) 
      }.resume
      
    end
  
end
  