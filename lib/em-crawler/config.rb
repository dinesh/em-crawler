

require 'erb'

module EMCrawler
  class Config 
   class << self
     attr_accessor :instance
     def init 
      @instance ||= new(opts= {})
     end
   end
   
   attr_accessor :configuration
   def initialize opts = {}
     @configuration = YAML.load ERB.new( File.read( File.join(File.dirname(__FILE__), '..', 'config/config.yml') ) ).result
   end 
   
   def database
    @configuration['database']['development']
   end
   
   def http_cache_directory
      File.join File.dirname(__FILE__), '..', @configuration['core']['http_cache']
   end
   
  end
end