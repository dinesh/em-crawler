
require 'active_support/hash_with_indifferent_access'

module DS
  module HashField
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def fields
          @fields ||= {}
        end
        
        def field name, args = {}
          args.assert_valid_keys(:default, :type, :required, :optional)
          fields[name] = { :default => nil }.update(args)
        end
      end
  end
  
  class MetaHash < HashWithIndifferentAccess
    include HashField
    
    def initialize opts = {}
      super
      self.class.fields.each{|k,v| store(k, opts[k] || v[:default]) }
      self
    end
    
    def method_missing sym, *args, &block
      if sym.to_s[-1].chr == "="
        method = sym.to_s[0..-2] 
        (has_key?(method) and method ) ? self.store(method, args.first) : super
      else
        has_key?(sym) ? self[sym] : super
      end

    end           
  end
  
end