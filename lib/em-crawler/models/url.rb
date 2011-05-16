

module Models
  class Url < Base
    has_one :metadata
    has_many :link_nodes, :foreign_key => 'source_id'
    has_many :incomings, :through => :link_nodes, :source => :source
    has_many :outgoings, :through => :link_nodes, :source => :destination
    DAMPING_FACTOR = 0.9
    validate :same_url?
    
    def frontier_rank
      unless new_record?
        d = DAMPING_FACTOR
        page_rank = (1-d) + d * outgoings.map{|out| out.page_rank/( out.outgoings.count || 0.99 ) }.sum
        total = ( ic = incomings.count ) + ( pr = page_rank )
        update_attribute(:page_rank , rank = (ic*0.2 + 0.8*pr)/total )
        rank
      else
        1
      end 
    end
      
    def add_outgoing auri
      begin
        ap "Fiber #{Fiber.current} for #{auri.to_s}"
        out = self.class.find_by_code( Util.digest(auri.to_s) )
        out = out ? out : self.class.init_from_address(auri)
        out.save if out.new_record?
        self.link_nodes << LinkNode.new(:destination => out) unless self.outgoing_ids.include?(out.id)
        out
      rescue Exception => e
        raise e
        ap e.backtrace
      end
      
    end
    
    def self.init_from_address auri
        new(   :uri    => auri.to_s, 
               :host   => auri.host, 
               :port   => auri.port, 
               :scheme => auri.scheme, 
               :path   => auri.path, 
               :query  => auri.query)
    end

    def self.get uri
      case uri
      when String
        where(:code =>  Util.digest(uri) ).first
      when Addressable::URI
        where( :code =>  Util.digest(uri.uri) ).first
      when Url
        uri
      end
      
    end
    private
    
    def same_url?
      self.code ||= Util.digest(self.uri)
      errors.add(:uri, "already registed the #{self.uri}.") if self.uri and self.class.find_by_code(self.code)
    end
    
    
  end
  
end