
require 'models/init'

module Models
  class Url < Base
    has_one :metadata
    after_save :generate_code
    
    private
    def generate_code
      unless code
        count = self.class.count + 1
        self.update_attributes( :code => Util.encode(count) )
      end
    end
    
  end
  
end