

require 'erb'

module EMCrawler
  class Config 
   class << self
     attr_accessor :instance
     def init 
      @instance ||= new(opts= {})
     end
   end
   
   attr_accessor :configuration, :root
   def initialize opts = {}
     @configuration = YAML.load ERB.new( File.read( File.join(File.dirname(__FILE__), '..', 'config/config.yml') ) ).result
   end 
   
   def database
    @configuration['database']['development']
   end
   
   def http_cache_directory
      File.join File.dirname(__FILE__), '..', @configuration['core']['http_cache']
   end
   
   def root
     @root ||= File.expand_path File.join( File.dirname(__FILE__), '..' )
   end
    
   def frontiers_dump_path
      File.join root, @configuration['frontiers']['dump_path']
   end
   
  end
end