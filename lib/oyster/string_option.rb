module Oyster
  class StringOption < Option
    
    def consume(list)
      list.shift
    end
    
    def default_value
      super(nil)
    end
    
    def help_names
      super.map { |name| name + ' ARG' }
    end
    
  end
end

