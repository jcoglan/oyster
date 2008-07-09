module Oyster
  class Specification
    
    def initialize
      @options = []
    end
    
    def method_missing(*args)
      opt = Option.create(*args)
      raise "Option name '#{opt.name}' is already used" if has_option?(opt.name)
      opt.alternate(shorthand_for(opt.name))
      @options << opt
    end
    
    def [](name)
      @options.each do |opt|
        return opt if opt.has_name?(name)
      end
      nil
    end
    
    def has_option?(name)
      !self[name].nil?
    end
    
    def shorthand_for(name)
      initial = name.to_s.scan(/^./).first.downcase
      initial.upcase! if has_option?(initial)
      return nil if has_option?(initial)
      initial
    end
    
    def parse(input = ARGV.dup)
      output = {:unclaimed => []}
      
      while token = input.shift
        long, short = token.scan(/^--([a-z0-9\-]+)$/i), token.scan(/^-([a-z0-9])$/i)
        long, short = [long, short].map { |s| s.flatten.first }
        negative = !!(long && long =~ /^no-/)
        long.sub!(/^no-/, '') if negative
        
        option = self[long] || self[short]
        output[:unclaimed] << token and next unless option
        
        output[option.name] = option.is_a?(FlagOption) ? !negative : option.consume(list)
      end
      
      @options.each do |option|
        output[option.name] ||= option.default_value
      end
      
      output
    end
    
  end
end

