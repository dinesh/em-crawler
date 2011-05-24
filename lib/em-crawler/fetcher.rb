

module EMCrawler
  
  module Fetcher
    STATES = [:new, :ok, :error ]
    
    class URL
      attr_accessor :uri, :state
      def initialize uri, opts = { }
        @uri = uri
        @state = opts[:state] || STATES[0]
      end
    end
    
    class DownloadReport < ::DS::MetaHash
       field :interval
       field :fetched_at
       field :signature
       field :header, :default => {}
       field :status
       field :error
       field :io
    end
    
    class << self
      attr_accessor :queue, :connections, :cacher
      
      def stop
        @cacher.shutdown if @cacher
      end
      
      
      def add uri
        ( @queue ||= Set.new ).add( URL.new(uri) )
      end
      
      def remove uri
        @queue.delete?(uri)
      end  
      
      def get uri_code, &blk
        @cacher ||= Cache::Http.new(dir = EMCrawler.config.http_cache_directory)
        link = Models::Url.find_by_code(uri_code)
        add(link)
        downloader = lambda { |link|
                link.code ||= Util.digest(link.uri)
                url = Addressable::URI.heuristic_parse(link.uri)
                proxy = ENV['http_proxy'] ? { :host => URI.parse(ENV['http_proxy']).host, :port =>  URI.parse(ENV['http_proxy']).port } : nil
                @cacher.get url, link.code, :proxy => proxy 
        }
        report = downloader.call(link)
        blk.call(link,report) 
      ensure
        remove(link)
      end
      
      end
      
      def status uri
        @queue.include?(url)
      end
      
      
    end
    
  end
  
end