

module Models
  class LinkNode < Base
    belongs_to :destination, :class_name => 'Url'
    belongs_to :source, :class_name => 'Url'
    validate :same_vertex?
    
    def same_vertex?
      self.class.where(:destination_id => self.destination_id, :source_id => self.source_id).none?   
    end
    
  end
end
