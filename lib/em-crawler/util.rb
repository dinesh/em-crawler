
module EMCrawler
  module Util
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split('')
    BASE = 62

    def encode(value)
        s = []
        while value >= BASE
          value, rem = value.divmod(BASE)
          s << CHARS[rem]
        end
        s << CHARS[value]
        s.reverse.join("")
    end
    module_function :encode
    
    def decode(str)
        str = str.split('').reverse
        total = 0
        str.each_with_index do |v,k|
          total += (CHARS.index(v) * (BASE ** k))
        end
        total
    end
    module_function :decode
    
  end
  
end

if __FILE__ == $0
  50.times do |i|
    a = EMCrawler::Util.encode i
    puts a
    puts EMCrawler::Util.decode(a)
    puts "--" * 20
  end
  
end