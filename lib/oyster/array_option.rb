module Oyster
  class ArrayOption < Option
    
    def consume(list)
      data = []
      data << list.shift while !Oyster.is_name?(list.first)
      data
    end
    
    def default_value
      super([])
    end
    
  end
end

