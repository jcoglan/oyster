module Oyster
  class FlagOption < Option
    
    def consume(list)
    end
    
    def default_value
      super(false)
    end
    
    def description
      super + (default_value ? ' (This is the default)' : '')
    end
    
  end
end

