

module DS
  class MetaHash < HashWithIndifferentAccess
    def field name, args = {}
      self.store(name, args[:default])
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