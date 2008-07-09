module Oyster
  class Option
    
    def self.create(type, *args)
      name = type.to_s.sub(/^(.)/) { |m| m.upcase } + 'Option'
      klass = Oyster.const_get(name)
      klass.new(*args)
    end
    
    attr_reader :description
    
    def initialize(name, options = {}, description = '')
      @names       = [name.to_sym]
      @description = description
      @settings    = options
    end
    
    def has_name?(name)
      name && @names.include?(name.to_sym)
    end
    
    def name
      @names.first
    end
    
    def names
      @names.map { |name| name.to_s }.sort
    end
    
    def alternate(name)
      @names << name.to_sym unless has_name?(name) || name.nil?
    end
    
    def consume(list); end
    
    def default_value(value)
      @settings[:default].nil? ? value : @settings[:default]
    end
    
  end
end

