require 'forwardable'
require 'active_support/core_ext/array'

module EMCrawler
  module Frontiers
    class << self
      extend Forwardable
      attr_accessor :runner , :options
      DEFAULT_OPTIONS = { :runner => 'Basic' }
      def_delegators :@runner, :add, :get, :size, :shuffle, :stop
      
      def setup opts = {}
        @options ||= DEFAULT_OPTIONS.merge(opts)
        runner opts
      end
      
      def runner opts = {} 
        @runner ||= Basic.new
      end
      
    end
  end
end

