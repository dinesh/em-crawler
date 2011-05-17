require 'set'

class Set
  def slice! from, to = nil
    if to.nil?
      from, to = 0, from
    end
    
    count, temp = -1, []
    each{|o| 
      count += 1
      next if count <= from
      temp << o
      break if count >= to
    }
    subtract temp
    temp
  end
end

if __FILE__ == $0
  s = Set.new
  s.add 1
  s.merge( (1..20).to_a )
  puts s.slice!(5).inspect
  puts s.inspect
end