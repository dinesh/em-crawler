

module EMCrawler
  
  module Console
    
    def green message
      puts message.foreground(:green)
    end
    
    def red message
      puts message.foreground(:red)
    end
    
  end

end
