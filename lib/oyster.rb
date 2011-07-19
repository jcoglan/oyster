module Oyster
  LONG_NAME     = /^--([a-z\[][a-z0-9\]\-]+)$/i
  LONG_NAME_EQ  = /^--([a-z\[][a-z0-9\]\-]+=.*)$/i
  SHORT_NAME    = /^-([a-z0-9]+)$/i
  
  HELP_INDENT   = 7
  HELP_WIDTH    = 80
  
  STOP_FLAG     = '--'
  NEGATOR       = /^no-/
  
  WINDOWS = RUBY_PLATFORM.split('-').any? { |part| part =~ /mswin\d*/i }
  
  class HelpRendered < StandardError ; end
  
  def self.spec(*args, &block)
    spec = Specification.new
    spec.instance_eval(&block)
    spec.flag(:help, :default => false, :desc => 'Displays this help message') unless spec.has_option?(:help)
    spec
  end
  
  def self.is_name?(string)
    !string.nil? and !!(string =~ LONG_NAME || string =~ SHORT_NAME || string == STOP_FLAG)
  end
  
  ROOT = File.expand_path('..', __FILE__)
  
  require ROOT + '/oyster/specification'
  require ROOT + '/oyster/option'
  require ROOT + '/oyster/options/flag'
  require ROOT + '/oyster/options/string'
  require ROOT + '/oyster/options/integer'
  require ROOT + '/oyster/options/float'
  require ROOT + '/oyster/options/file'
  require ROOT + '/oyster/options/array'
  require ROOT + '/oyster/options/glob'
  require ROOT + '/oyster/options/shortcut'
  require ROOT + '/oyster/options/subcommand'
end
