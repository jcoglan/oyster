module Oyster
  class Specification
    
    include Enumerable
    
    def initialize
      @options     = []
      @subcommands = []
      @data        = {}
    end
    
    def each(&block)
      @options.sort_by { |o| o.name.to_s }.each(&block)
    end
    
    def method_missing(*args)
      opt = Option.create(*args)
      raise "Option name '#{opt.name}' is already used" if has_option?(opt.name)
      opt.alternate(shorthand_for(opt.name))
      @options << opt
    rescue
      name, value = args[0..1]
      @data[name.to_sym] = value.to_s
    end
    
    def subcommand(name, &block)
      opt = SubcommandOption.new(name, Oyster.spec(&block))
      raise "Subcommand name '#{opt.name}' is already used" if has_command?(name)
      @subcommands << opt
    end
    
    def has_option?(name)
      !self[name].nil?
    end
    
    def has_command?(name)
      !command(name).nil?
    end
    
    def command(name)
      @subcommands.each do |command|
        return command if command.has_name?(name)
      end
      nil
    end
    
    def parse(input = ARGV)
      input = input.dup
      output = {:unclaimed => []}
      
      while token = input.shift
        option = command(token)
        
        long, short = token.scan(LONG_NAME), token.scan(SHORT_NAME)
        long, short = [long, short].map { |s| s.flatten.first }
        
        input = short.scan(/./).map { |s| "-#{s}" } + input and next if short and short.size > 1
        
        negative = !!(long && long =~ /^no-/)
        long.sub!(/^no-/, '') if negative
        
        option ||= self[long] || self[short]
        output[:unclaimed] << token and next unless option
        
        output[option.name] = option.is_a?(FlagOption) ? !negative : option.consume(input)
      end
      
      @options.each do |option|
        next unless output[option.name].nil?
        output[option.name] ||= option.default_value
      end
      
      help and raise HelpRendered if output[:help]
      output
    end
    
  private
    
    def [](name)
      @options.each do |opt|
        return opt if opt.has_name?(name)
      end
      nil
    end
    
    def shorthand_for(name)
      initial = name.to_s.scan(/^./).first.downcase
      initial.upcase! if has_option?(initial)
      return nil if has_option?(initial)
      initial
    end
    
    def help
      display(@data[:name], 'NAME')
      display(@data[:synopsis], 'SYNOPSIS', false)
      display(@data[:description], 'DESCRIPTION')
      puts "\nOPTIONS"
      each do |option|
        print ' ' * HELP_INDENT
        puts option.help_names.join(', ')
        puts format(option.description, 2) + "\n\n"
      end
      display(@data[:notes], 'NOTES')
      display(@data[:author], 'AUTHOR')
      display(@data[:copyright], 'COPYRIGHT')
      self
    end
    
    def display(text, title, join = true)
      return unless text
      puts ""
      puts title if title
      puts format(text, 1, join)
    end
    
    def format(text, level = 1, join = true)
      lines   = text.split(/\n/)
      outdent = lines.inject(1000) { |n,s| [s.scan(/^\s*/).first.size, n].min }
      indent  = level * HELP_INDENT
      width   = HELP_WIDTH - indent
      
      lines.map { |line|
        line.sub(/\s*$/, '').sub(%r{^\s{#{outdent}}}, '')
      }.inject(['']) { |groups, line|
        groups << '' if line.empty? && !groups.last.empty?
        buffer = groups.last
        buffer << (line =~ /^\s+/ || !join ? "\n" : " ") unless buffer.empty?
        buffer << line
        groups
      }.map { |buffer|
        lines = (buffer =~ /\n/) ? buffer.split(/\n/) : buffer.scan(%r{(.{1,#{width}}\S*)\s*}).flatten
        lines.map { |l| (' ' * indent) + l }.join("\n")
      }.join("\n\n")
    end
    
  end
end

