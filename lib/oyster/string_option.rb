module Oyster
  class StringOption < Option
    
    def consume(list)
      list.shift
    end
    
    def default_value
      super(nil)
    end
    
  end
end

