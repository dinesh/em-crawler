

module EMCrawler
  module Frontiers
    include BreathFirst
    include Mercator
    
    class << self
      attr_accessor :algorithm , :options
      DEFAULT_OPTIONS =  { :algorithm => :breath_first, :max_size => 1000000 }
      
      def config options, &block
        @options = DEFAULT_OPTIONS.update(options)
        yield 
      end
      
      def algorithm
        @algorithm ||= @options[:algorithm].camelize.new 
      end
      
      def add urls, opts ={}
        @algorithm.add(url, opts)
      end
      
      def next size = 1, opts = {}
        @algorithm.add(url, opts)
      end
      
      def shuffle
        @algorithm.shuffle
      end
      
    end
  end
end