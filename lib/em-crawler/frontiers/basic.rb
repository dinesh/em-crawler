
module EMCrawler
  module Frontiers
    class Basic
      attr_accessor :queue, :options
      
      def initialize opts = {}
        @queue = []
        @options ||= { :timeout => 5 }.merge(opts) 
      end
      
      def add links = []
        if links.present?
          @queue.unshift *Array(links)
        end
        size
      end
      
      def size; @queue.size; end
      
      def shuffle
        @queue.sort!{|a, b| a.frontier_rank <=> b.frontier_rank }
      end
      
      def get n = 10
        @queue.slice!(0, n)
      end
      
    end
  end
end