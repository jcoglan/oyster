module Oyster
  VERSION = '0.9.0'
  
  LONG_NAME   = /^--([a-z][a-z0-9\-]+)$/i
  SHORT_NAME  = /^-([a-z0-9])$/i
  
  def self.spec(*args, &block)
    spec = Specification.new
    spec.instance_eval(&block)
    spec.flag(:help, 'Displays this help message', :default => false) unless spec.has_option?(:help)
    spec
  end
  
  def self.is_name?(string)
    !string.nil? and !!(string =~ LONG_NAME || string =~ SHORT_NAME)
  end
end

require File.dirname(__FILE__) + '/oyster/specification'
require File.dirname(__FILE__) + '/oyster/option'
require File.dirname(__FILE__) + '/oyster/flag_option'
require File.dirname(__FILE__) + '/oyster/string_option'
require File.dirname(__FILE__) + '/oyster/array_option'
