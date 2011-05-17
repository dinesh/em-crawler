
module EMCrawler
  module Frontiers
    class Basic
      attr_accessor :queue, :options, :min, :max
      
      def initialize opts = {}
        @options ||= { :timeout => 5 , :min => 20, :max => 50000 }.merge(opts) 
        @queue = Set.new
      end
      
      def options; @options; end
      
      def validate uri
        uri = Models::Url.get(uri)
        uri.host && uri.host.size > 0 &&
        Models::Url::ACCEPTED_SCHEMES.include?(uri.scheme) &&
        uri.uri.size > 0 
      end
      
      def add links = []
        if links.present?
          @queue.merge Array(links).select{|u| validate(u) }.map{|u| u.code } 
        end
        teardown 
        size
      end
      
      def size; @queue.size; end
      
      def teardown
        if size > options[:max]
             shuffle
             waiting_urls = @queue.slice!(options[:min], @queue.size)
             File.open(dump_path, 'w'){|file| YAML.dump(waiting_urls, file) }
         end   
      end
      
      def shuffle
        @queue.sort!{|a, b| a.frontier_rank <=> b.frontier_rank }
      end
      
      def get n = 10
        @queue.slice!(0, n)
      end
      
      def dump_path
        EMCrawler.config.frontiers_dump_path
      end
      
    end
  end
end