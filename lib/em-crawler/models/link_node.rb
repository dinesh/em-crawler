

module Models
  class LinkNode < Base
    belongs_to :destination, :class_name => 'Url'
    belongs_to :source, :class_name => 'Url'
    validate :same_vertex?
    
    def same_vertex?
      errors.add(:destination, 'should be present.') if destination_id.nil?
      errors.add(:source, 'should be present.')  if source_id.nil?
      if destination_id and source_id
        errors.add(:destionation, 'cannot add duplicate node with same destionation') if self.class.where(:destination_id => self.destination_id, :source_id => self.source_id).any?   
      end
      
    end
    
  end
end
