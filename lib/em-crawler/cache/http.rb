
require 'fileutils'

module EMCrawler
 module Cache  
    class Http 
      attr_accessor :connections
      WAIT = 3
      
      def initialize( base_dir )
        @base_dir = File.expand_path base_dir
        FileUtils.mkdir_p(base_dir) unless File.exists?(@base_dir)
      end
      
      def connections; @connections ||= { };  end
      
      def shutdown
        connections.each{|conn| conn[:handle].close if conn }
      end
      
      def get( url, key, opts = { } )
        cached_path = @base_dir + '/' + key
        fiber = Fiber.current
        if File.exists?( cached_path  )
          puts ">>>> Getting file #{key} (#{url}) from cache"
          return IO.read( cached_path )
        else
          puts ">>>>> Getting file #{key} from URL #{url}"
          connection =  ( connections[url.authority] ||= { :handle => EventMachine::HttpRequest.new(url.origin), :hit_at => Time.now } )
          ap connections.keys
          t = ( diff = Time.now - connection[:hit_at] ) > WAIT ? WAIT : diff
          puts ">>>>> Sleeping for #{t} sec to retry #{url.to_s}"
          EM.add_timer(t) {
            http = connection[:handle].aget opts.merge!( { :path => url.path, :query => url.query, :keepalive => true } )
          
            cachr = lambda{|cached_path, data| 
                File.open( cached_path, 'w' ) do |f|
                  f.puts data
                end
            }
          
            http.callback { 
                data = http.response;
                cachr.call(cached_path, data)
                connection[:hit_at] = Time.now
                puts "!!!!!! #{url} => #{cached_path}"
                fiber.resume(data)
            }
          }
          
          Fiber.yield
        end
      end
    end
    
  end
  
end