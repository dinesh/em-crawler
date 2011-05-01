

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
   
  end
end