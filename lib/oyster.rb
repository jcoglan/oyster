module Oyster
  VERSION = '0.9.0'
  
  def self.spec(*args, &block)
    spec = Specification.new
    spec.instance_eval(&block)
    spec.flag(:help, 'Displays this help message', :default => false) unless spec.has_option?(:help)
    spec
  end
end

require File.dirname(__FILE__) + '/oyster/specification'
require File.dirname(__FILE__) + '/oyster/option'
