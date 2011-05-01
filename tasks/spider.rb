
require File.join( File.dirname(__FILE__), '..', 'lib', 'em-crawler')
require 'ap'

SEED = ['news.ycombinator.com']

# http://rubysource.com/understanding-concurrent-programming-with-ruby-goliath/

class OnShotSpider
  include EM::Deferrable
  include EMCrawler::Util
  include EMCrawler::Console
  
  attr_accessor :urls, :options 
  
  def initialize seeds, opts = {}
    @urls = seeds
    @options = { :wait => 3, :redirect_limit => 3, :max_seed_size => 10000, :store => 'seed.txt' }
    @options = @options.merge!( opts )
  end
  
  def run
    begin 
      handle = lambda { |url|
            url = Addressable::URI.heuristic_parse(url)
            green "Getting : #{url}..."
            conn = EventMachine::HttpRequest.new(url).get
            conn.callback{ |http| EM.next_tick{ extract_links(url, http.response) } }
            conn.errback{ self.fail('Error reterving ' + url) }
      }
      @urls.each{|seed| EM.next_tick{ handle.call(seed) } }
    rescue Exception => e
      puts e.message
      puts e.backtrace
      EM.stop
    end
  end
    
  def extract_links url, body
      doc = Nokogiri::HTML.parse(body)
      anchor_handle = lambda {|link|  
        uri = Addressable::URI.heuristic_parse(link) 
        uri = uri.relative? ? Addressable::URI.join(url, uri) : uri
      }    
      ap (doc/'a[href]').map{|u| anchor_handle.call(u['href']) }.uniq
  end
  
  
end

if __FILE__ == $0
  EM.run do 
    trap('INT') { puts ' quiting spider... '; EM.stop }
    spider = OnShotSpider.new SEED
    EM.next_tick{ spider.run }
  end
end
  