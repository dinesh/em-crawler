
module Models
  class Metadata < Base
    belongs_to :url 
    # state { :size => 3000, :visited => 100 , :status => [ 200, 400, 303 ] }
    serialize :stat, Hash
    validates_presence_of :url
    
    def update_on_crawl( report )
      # report should have :size, :status, :interval
      # report optionally accepts signature 
      state = { 
          :size => report[:size], 
          :visited => self.stat['visited'] + 1,  
          :status => ( self.stat['status'] ||= [] ).unshift(report[:status].slice(0,100) ,
        }
      signature = report[:signature] || generate_signature 
      fetch_interval = report[:interval]
    end
    
    def generate_signature
      File.open( File.join( ::EMCrawler.config.http_cache_directory, self.url.code ), 'r'){|f|
          
      }
      
    end
    
  end
end