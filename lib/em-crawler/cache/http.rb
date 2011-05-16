
require 'fileutils'

module EMCrawler
 module Cache  
    class Http 
      def initialize( base_dir )
        @base_dir = File.expand_path base_dir
        FileUtils.mkdir_p(base_dir) unless File.exists?(@base_dir)
      end

      def get( url, key, opts = { } )
        cached_path = @base_dir + '/' + key
        fiber = Fiber.current
        if File.exists?( cached_path  )
          puts "Getting file #{key} (#{url}) from cache"
          return IO.read( cached_path )
        else
          puts "Getting file #{key} from URL #{url}"
          puts cached_path
          http = EventMachine::HttpRequest.new(url).aget opts
          cachr = lambda{|cached_path, data| 
              File.open( cached_path, 'w' ) do |f|
                f.puts data
              end
          }
        
          http.callback { 
            data = http.response;
            cachr.call(cached_path, data); 
            fiber.resume(data) 
          }
        
          Fiber.yield
        end
      end
    end
    
  end
  
end